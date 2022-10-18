// Rising edge detect module
// Created 18 Oct 2022

module jdrosent_rising_edge_detect(
	input  [7:0] io_in,
	output [7:0] io_out);

	wire dff_o, not_dff_o;

	dff_cell re_detect (
		.clk(io_in[0]),
		.d(io_in[1]),
		.q(dff_o),
		.notq(not_dff_o));
	
	and_cell and1 (
		.a(io_in[1]),
		.b(not_dff_o),
		.out(io_out[2]));
	
	assign io_out[0] = io_in[0];
	assign io_out[1] = io_in[1];
	assign io_out[3] = dff_o;
	assign io_out[7:4] = io_in[7:4];
endmodule
