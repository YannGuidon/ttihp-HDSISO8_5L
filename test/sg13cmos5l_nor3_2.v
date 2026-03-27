`timescale 1ns/10ps
`celldefine
module sg13cmos5l_nor3_2 (Y, A, B, C);
	output Y;
	input A, B, C;
	wire int_fwire_0;
	or (int_fwire_0, A, B, C);
	not (Y, int_fwire_0);
endmodule
`endcelldefine
