module stevenmburns_incrementor(
  input [7:0] io_in,
  output [7:0] io_out
);
  
assign io_out = io_in + 1'b1;

endmodule
