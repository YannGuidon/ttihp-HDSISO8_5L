`timescale 1ns/10ps
`celldefine
module sg13cmos5l_buf_16 (X, A);
	output X;
	input A;
	buf (X, A);
endmodule
`endcelldefine
