`ifdef _udp_def_ihp_latch_r_
`else
`define _udp_def_ihp_latch_r_
primitive ihp_latch_r (q, v, clk, d, r);
	output q;
	reg q;
	input v, clk, d, r;
	table
		* ? ? ? : ? : x;
		? ? ? 1 : ? : 0;
		? 0 ? 0 : ? : -;
		? 0 ? x : 0 : -;
		? 1 0 0 : ? : 0;
		? 1 0 x : ? : 0;
		? 1 1 0 : ? : 1;
		? x 0 0 : 0 : -;
		? x 0 x : 0 : -;
		? x 1 0 : 1 : -;
	endtable
endprimitive
`endif

// type: DLHR
`timescale 1ns/10ps
`celldefine
module sg13cmos5l_dlhr_1 (Q, Q_N, D, GATE, RESET_B);
	output Q, Q_N;
	input D, RESET_B, GATE;
	reg notifier;

	// Function
	wire int_fwire_IQ, int_fwire_IQN, int_fwire_r;

	not (int_fwire_r, RESET_B);
	ihp_latch_r (int_fwire_IQ, notifier, GATE, D, int_fwire_r);
	buf (Q, int_fwire_IQ);
	not (int_fwire_IQN, int_fwire_IQ);
	buf (Q_N, int_fwire_IQN);

endmodule
`endcelldefine
