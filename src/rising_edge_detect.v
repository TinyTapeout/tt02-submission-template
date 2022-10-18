// Rising edge detect module
// Created 18 Oct 2022

module jdrosent_rising_edge_detect(
	input  [7:0] io_i,
	output [7:0] io_o);

	wire dff_o, not_dff_o;

	dff_cell re_detect (
		.clk(io_i[0]),
		.d(io_i[1]),
		.q(dff_o),
		.notq(not_dff_o));
	
	and_cell and1 (
		.a(io_i[1]),
		.b(not_dff_o),
		.out(io_o[2]));
	
	assign io_o[0] = io_i[0];
	assign io_o[1] = io_i[1];
	assign io_o[3] = dff_o;
	assign io_o[7:4] = io_i[7:4];
endmodule
