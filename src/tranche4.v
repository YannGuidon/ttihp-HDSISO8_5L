/*
 * Copyright (c) 2026 Yann Guidon / whygee@f-cpu.org
 * SPDX-License-Identifier: Apache-2.0
 * Check the /doc and the diagrams at
 *   https://github.com/ygdes/ttihp-HDSISO8/tree/main/docs
 *
 * 3 versions are provided :
 *  - siso_slice4x4_dl_neg is the ol'good version using standard latches. reliable but large.
 *  - siso_slice4x4_dl_neg does the same but smaller and less constrained timing.
 *  - siso_slice4x4_dl_pos is siso_slice4x4_dl_neg but with inverted control signal, for bubble pushing.
 *
 */

// sg13g2_dlhq_1 area = 30.8
// sg13g2_inv_4  area = 10.9
// Total : 134.1
module siso_slice4_dl_neg (      // Pulse low to latch
    input  wire [3:0] siso_in,   // 4 staggered data inputs
    output wire [3:0] siso_out,  // 4 staggered data outputs
    input  wire       latch,     // pass/keep signal
);

  wire local;
  (* keep *) sg13g2_inv_4  AmpShow0(.Y(local), .A(latch));
  (* keep *) sg13g2_dlhq_1 l0(.Q(siso_out[0]), .D(siso_in[0]), .GATE(local));
  (* keep *) sg13g2_dlhq_1 l1(.Q(siso_out[1]), .D(siso_in[1]), .GATE(local));
  (* keep *) sg13g2_dlhq_1 l2(.Q(siso_out[2]), .D(siso_in[2]), .GATE(local));
  (* keep *) sg13g2_dlhq_1 l3(.Q(siso_out[3]), .D(siso_in[3]), .GATE(local));

  // and that's all.
endmodule;

.................................................................................

// area: 536.4
module siso_slice4x4_dl_neg (    // Pulse low to latch
    input  wire [3:0] siso_in,   // 4 staggered data inputs
    output wire [3:0] siso_out,  // 4 staggered data outputs
    input  wire [3:0] latch,     // pass/keep signals
);

  wire [3:0] t1, t2, t3;
  siso_slice4_dl_neg slice0(.siso_in(siso_in), .siso_out(t1),       .latch(latch[3]));
  siso_slice4_dl_neg slice1(.siso_in(t1),      .siso_out(t2),       .latch(latch[2]));
  siso_slice4_dl_neg slice2(.siso_in(t2),      .siso_out(t3),       .latch(latch[1]));
  siso_slice4_dl_neg slice3(.siso_in(t3),      .siso_out(siso_out), .latch(latch[0]));

  // et voilà.
endmodule;

/////////////////////////////////////////////////////////////////////////////////

// sg13g2_mux2_1 area = 18.2
// sg13g2_inv_4  area = 10.9
// Total : 83.7

module siso_slice4_mx_neg (      // Pulse low to latch
    input  wire [3:0] siso_in,   // 4 staggered data inputs
    output wire [3:0] siso_out,  // 4 staggered data outputs
    input  wire       latch,     // pass/keep signal
);

  wire local;
  wire [3:0] fb;
  (* keep *) sg13g2_inv_4  AmpShow0(.Y(local), .A(latch));
  (* keep *) sg13g2_mux2_2 mx0(.A0(siso_in[0]), .A1(fb[0]), .X(fb[0]), .S(local));
  (* keep *) sg13g2_mux2_2 mx1(.A0(siso_in[1]), .A1(fb[1]), .X(fb[1]), .S(local));
  (* keep *) sg13g2_mux2_2 mx2(.A0(siso_in[2]), .A1(fb[2]), .X(fb[2]), .S(local));
  (* keep *) sg13g2_mux2_2 mx3(.A0(siso_in[3]), .A1(fb[3]), .X(fb[3]), .S(local));

  assign siso_out = fb;
endmodule;

.................................................................................

// area: 334.8
module siso_slice4x4_mx_neg (    // Pulse low to latch
    input  wire [3:0] siso_in,   // 4 staggered data inputs
    output wire [3:0] siso_out,  // 4 staggered data outputs
    input  wire [3:0] latch,     // pass/keep signals
);

  wire [3:0] t1, t2, t3;
  siso_slice4_mx_neg slice0(.siso_in(siso_in), .siso_out(t1),       .latch(latch[3]));
  siso_slice4_mx_neg slice1(.siso_in(t1),      .siso_out(t2),       .latch(latch[2]));
  siso_slice4_mx_neg slice2(.siso_in(t2),      .siso_out(t3),       .latch(latch[1]));
  siso_slice4_mx_neg slice3(.siso_in(t3),      .siso_out(siso_out), .latch(latch[0]));
endmodule;

/////////////////////////////////////////////////////////////////////////////////

module siso_slice4_mx_pos (      // Pulse high to latch
    input  wire [3:0] siso_in,   // 4 staggered data inputs
    output wire [3:0] siso_out,  // 4 staggered data outputs
    input  wire       latch,     // pass/keep signal
);

  wire local;
  wire [3:0] fb;
  (* keep *) sg13g2_inv_4  AmpShow0(.Y(local), .A(latch));
  (* keep *) sg13g2_mux2_2 mx0(.A1(siso_in[0]), .A0(fb[0]), .X(fb[0]), .S(local));
  (* keep *) sg13g2_mux2_2 mx1(.A1(siso_in[1]), .A0(fb[1]), .X(fb[1]), .S(local));
  (* keep *) sg13g2_mux2_2 mx2(.A1(siso_in[2]), .A0(fb[2]), .X(fb[2]), .S(local));
  (* keep *) sg13g2_mux2_2 mx3(.A1(siso_in[3]), .A0(fb[3]), .X(fb[3]), .S(local));

  assign siso_out = fb;
endmodule;

.................................................................................

// area: 334.8
module siso_slice4x4_mx_pos (    // Pulse high to latch
    input  wire [3:0] siso_in,   // 4 staggered data inputs
    output wire [3:0] siso_out,  // 4 staggered data outputs
    input  wire [3:0] latch,     // pass/keep signals
);

  wire [3:0] t1, t2, t3;
  siso_slice4_mx_pos slice0(.siso_in(siso_in), .siso_out(t1),       .latch(latch[3]));
  siso_slice4_mx_pos slice1(.siso_in(t1),      .siso_out(t2),       .latch(latch[2]));
  siso_slice4_mx_pos slice2(.siso_in(t2),      .siso_out(t3),       .latch(latch[1]));
  siso_slice4_mx_pos slice3(.siso_in(t3),      .siso_out(siso_out), .latch(latch[0]));
endmodule;

