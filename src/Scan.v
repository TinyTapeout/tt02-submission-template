module Scan(
  input   clock,
  input   reset,
  input   io_ld,
  input   io_u_bit,
  input   io_v_bit,
  output  io_z_bit,
  output  io_done
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [23:0] u; // @[Scan.scala 14:18]
  reg [23:0] v; // @[Scan.scala 15:18]
  wire [24:0] _u_T = {u, 1'h0}; // @[Scan.scala 19:13]
  wire [24:0] _GEN_4 = {{24'd0}, io_u_bit}; // @[Scan.scala 19:19]
  wire [24:0] _u_T_1 = _u_T | _GEN_4; // @[Scan.scala 19:19]
  wire [24:0] _v_T = {v, 1'h0}; // @[Scan.scala 20:13]
  wire [24:0] _GEN_5 = {{24'd0}, io_v_bit}; // @[Scan.scala 20:19]
  wire [24:0] _v_T_1 = _v_T | _GEN_5; // @[Scan.scala 20:19]
  wire [23:0] _u_T_3 = u - v; // @[Scan.scala 22:12]
  wire [23:0] _v_T_3 = v - u; // @[Scan.scala 24:12]
  wire [23:0] _GEN_0 = u > v ? _u_T_3 : u; // @[Scan.scala 14:18 21:23 22:7]
  wire [23:0] _GEN_1 = u > v ? v : _v_T_3; // @[Scan.scala 15:18 21:23 24:7]
  wire [24:0] _GEN_2 = io_ld ? _u_T_1 : {{1'd0}, _GEN_0}; // @[Scan.scala 18:16 19:7]
  wire [24:0] _GEN_3 = io_ld ? _v_T_1 : {{1'd0}, _GEN_1}; // @[Scan.scala 18:16 20:7]
  wire [24:0] _GEN_6 = reset ? 25'h0 : _GEN_2; // @[Scan.scala 14:{18,18}]
  wire [24:0] _GEN_7 = reset ? 25'h0 : _GEN_3; // @[Scan.scala 15:{18,18}]
  assign io_z_bit = u[23]; // @[Scan.scala 17:16]
  assign io_done = v == 24'h0; // @[Scan.scala 27:16]
  always @(posedge clock) begin
    u <= _GEN_6[23:0]; // @[Scan.scala 14:{18,18}]
    v <= _GEN_7[23:0]; // @[Scan.scala 15:{18,18}]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  u = _RAND_0[23:0];
  _RAND_1 = {1{`RANDOM}};
  v = _RAND_1[23:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
