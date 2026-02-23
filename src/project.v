/*
 * Copyright (c) 2026 Yann Guidon / whygee@f-cpu.org
 * SPDX-License-Identifier: Apache-2.0
 * Check the /doc and the diagrams at
 *   https://github.com/ygdes/ttihp-HDSISO8/tree/main/docs
 */

`default_nettype none

module tt_um_ygdes_hdsiso8 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

////////////////////////////// Plumbing //////////////////////////////

  // IO config & misc.
  assign uio_oe  = 8'b11111111; // port uio goes all out


  // General/housekeeping signals
  wire CLK_SEL, EXT_CLK, EXT_RST, D_IN, MX_DL_SEL;
  assign CLK_SEL   = ui_in[0];
  assign EXT_CLK   = ui_in[1];
  assign EXT_RST   = ui_in[2];
  assign D_IN      = ui_in[3];
  assign MX_DL_SEL = ui_in[4];

  wire CLK_OUT;
  assign uo_out[1] = CLK_OUT;


  // SISO
  wire DL_out, MX_out;
  // assign uo_out[0] = D_OUT;
  (* keep *) sg13g2_mux2_2 mux2_Din(.A0(DL_out), .A1(MX_out), .S(MX_DL_SEL), .X(uo_out[0]));

  wire [3:0] Johnson4;
  assign uo_out[2] = Johnson4[0];
  assign uo_out[3] = Johnson4[1];
  assign uo_out[4] = Johnson4[2];
  assign uo_out[5] = Johnson4[3];


  // LFSR
  wire SHOW_LFSR, LFSR_EN, DIN_SEL;
  assign SHOW_LFSR = ui_in[5];
  assign LFSR_EN   = ui_in[6];
  assign DIN_SEL   = ui_in[7];

  wire LFSR_PERIOD, LFSR_BIT;
  assign uo_out[6] = LFSR_PERIOD;
  assign uo_out[7] = LFSR_BIT;


  // multiplexed output
  wire [7:0] LFSR_state8, Decoded8;
  assign uio_out = SHOW_LFSR ? LFSR_state8 : Decoded8 ;


////////////////////////////// custom soup //////////////////////////////

  wire INT_RESET;

  // CLK_OUT = clk if CLK_SEL=0, else EXT_CLK
  // assign CLK_OUT = CLK_SEL ? EXT_CLK : clk;
  (* keep *) sg13g2_mux2_2 mux_clk(.A0(clk), .A1(EXT_CLK), .S(CLK_SEL), .X(CLK_OUT));

  // Combined and resynch'ed Reset
  (* keep *) sg13g2_dfrbpq_2 DFF_reset(.Q(INT_RESET), .D(EXT_RST), .RESET_B(rst_n), .CLK(CLK_OUT));


  // Select + resynch D_in
  //      SISO_in <= DIN_SEL ? LFSR_BIT : D_IN;
  // wire mux_Din;
  // (* keep *) sg13g2_mux2_2 mux2_Din(.A0(D_IN), .A1(LFSR_BIT), .S(DIN_SEL), .X(mux_Din));
  // (* keep *) sg13g2_dfrbpq_2 DFF_Din(.Q(SISO_in), .D(mux_Din), .RESET_B(INT_RESET), .CLK(CLK_OUT));
  // merged into 1
    (* keep *) sg13g2_sdfrbpq_1 sync_Din(.Q(SISO_in), .D(D_IN),
       .SCD(LFSR_BIT), .SCE(DIN_SEL), .RESET_B(INT_RESET), .CLK(CLK_OUT));

////////////////////////////// sub-modules //////////////////////////////

  LFSR8 lfsr(
    .CLK(CLK_OUT),
    .RESET(INT_RESET),
    .LFSR_EN(LFSR_EN),
    .LFSR_PERIOD(LFSR_PERIOD),
    .LFSR_BIT(LFSR_BIT),
    .LFSR_STATE(LFSR_state8));  // the LFSR state is directly routed to the byte output, will be muxed later.

  Johnson8 J8(
    .CLK(CLK_OUT),
    .RESET(INT_RESET),
    .DFF4(Johnson4),
    .Decoded8(Decoded8));


// JUST A TEST FOR NOW  !!!!

  // looping the SISO on itself to get 8× downsampling but no demux yet
  // First, sample the data at the right moment
  wire feedback;
  (* keep *) sg13g2_sdfrbpq_1 sync8(.Q(feedback), .D(SISO_in),
       .SCD(feedback), .SCE(Decoded8[4]), .RESET_B(INT_RESET), .CLK(CLK_OUT));

    wire [3:0] siso_in4, siso_out4, latch4;    // l'originalité des noms de variables......
  assign siso_in4[0] = feedback;
  assign siso_in4[1] = siso_out4[0];
  assign siso_in4[2] = siso_out4[1];  // au diable la syntaxe,
  assign siso_in4[3] = siso_out4[2];  // mate le formatage
  assign DL_out      = siso_out4[3];
  assign MX_out      = siso_out4[1];  // juste pour driver le signal, on verra après
  assign latch4 = {
    Decoded8[0], // Data is latched during the transition from [0] to [1]
    Decoded8[2],
    Decoded8[4],
    Decoded8[6]
  };

  siso_tranche4x4x4_dl_pos siso64(
    .siso_in( siso_in4 ),
    .siso_out(siso_out4),
    .latch(latch4});


////////////////////////////// All the dummies go here //////////////////////////////

  // List all unused inputs to prevent warnings
  wire _unused = &{
    ena,       // They said not to bother, then ... why provide it ?
    uio_in,
    1'b0};

endmodule
