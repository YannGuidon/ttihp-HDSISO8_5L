`timescale 1ns/10ps
`celldefine
module sg13cmos5l_or4_1 (X, A, B, C, D);
	output X;
	input A, B, C, D;
	or (X, A, B, C, D);
endmodule
`endcelldefine
