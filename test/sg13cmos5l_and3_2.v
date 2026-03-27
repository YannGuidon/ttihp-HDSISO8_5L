`timescale 1ns/10ps
`celldefine
module sg13cmos5l_and3_2 (X, A, B, C);
	output X;
	input A, B, C;
	and (X, A, B, C);
endmodule
`endcelldefine
