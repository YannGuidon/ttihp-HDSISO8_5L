`timescale 1ns/10ps
`celldefine
module sg13cmos5l_or2_2 (X, A, B);
	output X;
	input A, B;
	or (X, A, B);
endmodule
`endcelldefine
