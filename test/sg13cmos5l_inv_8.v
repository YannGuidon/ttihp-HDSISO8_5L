`timescale 1ns/10ps
`celldefine
module sg13cmos5l_inv_8 (Y, A);
	output Y;
	input A;
	not (Y, A);
endmodule
`endcelldefine
