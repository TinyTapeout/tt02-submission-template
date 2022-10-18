`include "cells.v"

module rising_edge_detect_tb ();
    reg  [7:0] io_in;
    wire [7:0] io_out;

    initial begin
        $monitor("%8b  %8b", io_in, io_out);
        io_in = 8'h00;
        #1 io_in = 8'h01;
        #1 io_in = 8'h00;
        #1 io_in = 8'h02;
        #1 io_in = 8'h02;
        #1 io_in = 8'h03;
        #1 io_in = 8'h02;
        #1 io_in = 8'h00;
    end

    rising_edge_detect red(.io_i(io_in),
                   .io_o(io_out));
endmodule 
