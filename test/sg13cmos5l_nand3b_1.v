`timescale 1ns/10ps
`celldefine
module sg13cmos5l_nand3b_1 (Y, A_N, B, C);
	output Y;
	input A_N, B, C;
	wire A_N__bar, int_fwire_0;
	not (A_N__bar, A_N);
	and (int_fwire_0, A_N__bar, B, C);
	not (Y, int_fwire_0);
endmodule
`endcelldefine
