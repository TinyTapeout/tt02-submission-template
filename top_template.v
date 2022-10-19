// Tiny Tapeout 02
// Verilog Example Template

module githubusername_top_template(	//prepend your github username to the top module
	input  [7:0] io_in,		//leave port names unchanged
	output [7:0] io_out);
	
	// declare internal wires or regs
	wire clock;
	wire usersignal;
	wire dff_q;
	wire dff_notq;
	wire risingedgedetect;
	
	assign clock = io_in[0]; //use the first input, io_in[0], for a clock if needed
	
	//available cells can be found in /src/cells.v
	//you can also implicitly declare cells using verilog syntax:
	//e.g. reg example_dff;
	//e.g. assign io_out[2] = usersignal & !dff_q;
	dff_cell example_dff (	
		.clk(clock), 
		.d(usersignal), 
		.q(dff_q),
		.notq(dff_notq));
	
	and_cell example_and (
		.a(usersignal),
		.b(dff_notq),
		.out(risingedgedetect));
	
	assign io_out[0] = io_in[0];
	assign io_out[1] = io_in[1];
	assign io_out[2] = risingedgedetect;
	assign io_out[3] = dff_q;
	assign io_out[7:4] = io_in[7:4];
endmodule
