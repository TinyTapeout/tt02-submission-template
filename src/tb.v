`default_nettype none `timescale 1ns / 1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/
module tb (
    // testbench is controlled by test.py
    input clk,
    input rst,
    output [5:0] lights
);

  // this part dumps the trace to a vcd file that can be viewed with GTKWave
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  wire left;
  wire right;
  wire haz;

  wire [7:0] inputs = {3'b0, haz, right, left, rst, clk};
  wire [7:0] outputs;
  assign lights = outputs[5:0];

  // instantiate the DUT
  thunderbird_taillight_ctrl #(
      .MAX_COUNT  (1000),
      .SYSTEM_FREQ(12500),
      .HZ         (8)
  ) dut_i (
      .io_in (inputs),
      .io_out(outputs)
  );

endmodule
