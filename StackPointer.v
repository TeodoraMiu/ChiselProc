module StackPointer(
  input        clock,
  input        reset,
  input        io_spDec,
  input        io_spInc,
  output [7:0] io_spOut
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] spReg; // @[StackPointer.scala 9:22]
  wire [7:0] _spReg_T_1 = spReg - 8'h1; // @[StackPointer.scala 12:20]
  wire [7:0] _GEN_0 = io_spDec ? _spReg_T_1 : spReg; // @[StackPointer.scala 11:19 12:11 9:22]
  wire  _T = spReg < 8'hff; // @[StackPointer.scala 16:17]
  wire [7:0] _spReg_T_3 = spReg + 8'h1; // @[StackPointer.scala 17:22]
  assign io_spOut = spReg; // @[StackPointer.scala 25:12]
  always @(posedge clock) begin
    if (reset) begin // @[StackPointer.scala 9:22]
      spReg <= 8'hff; // @[StackPointer.scala 9:22]
    end else if (io_spInc) begin // @[StackPointer.scala 15:19]
      if (spReg < 8'hff) begin // @[StackPointer.scala 16:26]
        spReg <= _spReg_T_3; // @[StackPointer.scala 17:13]
      end else begin
        spReg <= _GEN_0;
      end
    end else begin
      spReg <= _GEN_0;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_spInc & ~_T & ~reset) begin
          $fwrite(32'h80000002,"Stack underflow!\n"); // @[StackPointer.scala 21:13]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
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
  spReg = _RAND_0[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
