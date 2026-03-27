`timescale 1ns/10ps
`celldefine
module sg13cmos5l_and2_2 (X, A, B);
	output X;
	input A, B;
	and (X, A, B);
endmodule
`endcelldefine
