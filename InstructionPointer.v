module InstructionPointer(
  input        clock,
  input        reset,
  input        io_ipLoad,
  input        io_ipInc,
  input  [7:0] io_cntIn,
  output [7:0] io_cntOut
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] cntReg; // @[InstructionPointer.scala 10:23]
  wire [7:0] _cntReg_T_1 = cntReg + 8'h1; // @[InstructionPointer.scala 13:22]
  assign io_cntOut = cntReg; // @[InstructionPointer.scala 20:13]
  always @(posedge clock) begin
    if (reset) begin // @[InstructionPointer.scala 10:23]
      cntReg <= 8'h0; // @[InstructionPointer.scala 10:23]
    end else if (io_ipLoad) begin // @[InstructionPointer.scala 16:20]
      cntReg <= io_cntIn; // @[InstructionPointer.scala 17:12]
    end else if (io_ipInc) begin // @[InstructionPointer.scala 12:19]
      cntReg <= _cntReg_T_1; // @[InstructionPointer.scala 13:12]
    end
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
  cntReg = _RAND_0[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
