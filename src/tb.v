`default_nettype none
`timescale 1ns/1ps

module tb (
    input clk,
    input rst,
    output [6:0] segments
   );
    `ifdef COCOTB_SIM
        initial begin
            $dumpfile ("tb.vcd");
            $dumpvars (0, tb);
            #1;
        end
        localparam MAX_COUNT = 100;
    `else
        localparam MAX_COUNT = 16_000_000;
    `endif

    wire [7:0] inputs = {6'b0, rst, clk};
    wire [7:0] outputs;
    assign segments = outputs[6:0];

    seven_segment_seconds #(.MAX_COUNT(100)) seven_segment_seconds(
        .io_in  (inputs),
        .io_out (outputs)
        );

endmodule
