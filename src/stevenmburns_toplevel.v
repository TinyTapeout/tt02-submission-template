module stevenmburns_toplevel(
  input [7:0] io_in,
  output [7:0] io_out
);
  
Scan u0(.clock(io_in[0]),
	.reset(io_in[1]),
	.io_ld(io_in[2]),
	.io_u_bit(io_in[3]),
	.io_v_bit(io_in[3]),
	.io_z_bit(io_out[0]),
	.io_done(io_out[1]));

endmodule
