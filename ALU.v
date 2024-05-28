module ALU(
  input        clock,
  input        reset,
  input        io_op1Load,
  input        io_op2Load,
  input        io_addSig,
  input        io_subSig,
  input        io_divSig,
  input        io_mulSig,
  input        io_modSig,
  input        io_incSig,
  input        io_decSig,
  input  [7:0] io_op1In,
  input  [7:0] io_op2In,
  output [7:0] io_resultOut,
  output       io_zeroFlag,
  output       io_carryFlag
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] op1Reg; // @[ALU.scala 20:25]
  reg [7:0] op2Reg; // @[ALU.scala 21:25]
  reg [7:0] resultReg; // @[ALU.scala 22:28]
  reg  zeroFlagReg; // @[ALU.scala 23:30]
  wire [7:0] _resultReg_T_1 = op1Reg + op2Reg; // @[ALU.scala 35:29]
  wire [7:0] _GEN_2 = io_addSig ? _resultReg_T_1 : resultReg; // @[ALU.scala 34:22 35:19 22:28]
  wire [7:0] _resultReg_T_3 = op1Reg - op2Reg; // @[ALU.scala 39:29]
  wire [7:0] _GEN_3 = io_subSig ? _resultReg_T_3 : _GEN_2; // @[ALU.scala 38:22 39:19]
  wire [15:0] _resultReg_T_4 = op1Reg * op2Reg; // @[ALU.scala 43:29]
  wire [15:0] _GEN_4 = io_mulSig ? _resultReg_T_4 : {{8'd0}, _GEN_3}; // @[ALU.scala 42:22 43:19]
  wire [7:0] _resultReg_T_5 = op1Reg / op2Reg; // @[ALU.scala 47:29]
  wire [15:0] _GEN_5 = io_divSig ? {{8'd0}, _resultReg_T_5} : _GEN_4; // @[ALU.scala 46:22 47:19]
  wire [7:0] _resultReg_T_6 = op1Reg % op2Reg; // @[ALU.scala 51:29]
  wire [15:0] _GEN_6 = io_modSig ? {{8'd0}, _resultReg_T_6} : _GEN_5; // @[ALU.scala 50:22 51:19]
  wire [7:0] _resultReg_T_8 = op1Reg + 8'h1; // @[ALU.scala 55:29]
  wire [15:0] _GEN_7 = io_incSig ? {{8'd0}, _resultReg_T_8} : _GEN_6; // @[ALU.scala 54:22 55:19]
  wire [7:0] _resultReg_T_10 = op1Reg - 8'h1; // @[ALU.scala 59:29]
  wire [15:0] _GEN_8 = io_decSig ? {{8'd0}, _resultReg_T_10} : _GEN_7; // @[ALU.scala 58:22 59:19]
  wire  _T_2 = resultReg == 8'h0 | op1Reg == op2Reg; // @[ALU.scala 62:29]
  wire [15:0] _GEN_10 = reset ? 16'h0 : _GEN_8; // @[ALU.scala 22:{28,28}]
  assign io_resultOut = resultReg; // @[ALU.scala 68:18]
  assign io_zeroFlag = zeroFlagReg; // @[ALU.scala 69:17]
  assign io_carryFlag = 1'h0; // @[ALU.scala 70:18]
  always @(posedge clock) begin
    if (reset) begin // @[ALU.scala 20:25]
      op1Reg <= 8'h0; // @[ALU.scala 20:25]
    end else if (io_op1Load) begin // @[ALU.scala 26:23]
      op1Reg <= io_op1In; // @[ALU.scala 27:16]
    end
    if (reset) begin // @[ALU.scala 21:25]
      op2Reg <= 8'h0; // @[ALU.scala 21:25]
    end else if (io_op2Load) begin // @[ALU.scala 30:23]
      op2Reg <= io_op2In; // @[ALU.scala 31:16]
    end
    resultReg <= _GEN_10[7:0]; // @[ALU.scala 22:{28,28}]
    if (reset) begin // @[ALU.scala 23:30]
      zeroFlagReg <= 1'h0; // @[ALU.scala 23:30]
    end else begin
      zeroFlagReg <= _T_2;
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
  op1Reg = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  op2Reg = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  resultReg = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  zeroFlagReg = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
