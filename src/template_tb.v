`include "cells.v"

module template_tb ();
    reg  [7:0] io_in;
    wire [7:0] io_out;

    initial begin
        $monitor("%8b  %8b", io_in, io_out);
        io_in = 8'b00000000;
        #1 io_in = 8'b00000001;
        #1 io_in = 8'b00000000;
        #1 io_in = 8'b00000010;
        #1 io_in = 8'b00000010;
        #1 io_in = 8'b00000011;
        #1 io_in = 8'b00000010;
        #1 io_in = 8'b00000000;
    end

    githubusername_top dut(.io_i(io_in),
                   .io_o(io_out));
endmodule 
