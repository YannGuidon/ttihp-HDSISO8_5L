`ifdef _udp_def_ihp_mux4
`else
`define _udp_def_ihp_mux4
primitive ihp_mux4 (z, a, b, c, d, s0, s1);
	output z;
	input d, c, b, a, s1, s0;
	table
		0  ?  ?  ?  0  0 : 0;
		1  ?  ?  ?  0  0 : 1;
		?  0  ?  ?  1  0 : 0;
		?  1  ?  ?  1  0 : 1;
		?  ?  0  ?  0  1 : 0;
		?  ?  1  ?  0  1 : 1;
		?  ?  ?  0  1  1 : 0;
		?  ?  ?  1  1  1 : 1;
		0  0  ?  ?  x  0 : 0;
		1  1  ?  ?  x  0 : 1;
		?  ?  0  0  x  1 : 0;
		?  ?  1  1  x  1 : 1;
		0  ?  0  ?  0  x : 0;
		1  ?  1  ?  0  x : 1;
		?  0  ?  0  1  x : 0;
		?  1  ?  1  1  x : 1;
		1  1  1  1  x  x : 1;
		0  0  0  0  x  x : 0;
	endtable
endprimitive
`endif

// type: mux4
`timescale 1ns/10ps
`celldefine
module sg13cmos5l_mux4_1 (X, A0, A1, A2, A3, S0, S1);
	output X;
	input A0, A1, A2, A3, S0, S1;

	// Function
	ihp_mux4 (X, A0, A1, A2, A3, S0, S1);

endmodule
`endcelldefine
