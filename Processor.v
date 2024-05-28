module RAM(
  input        clock,
  input        io_writeEn,
  input  [7:0] io_addrIn,
  input  [7:0] io_dataIn,
  output [7:0] io_dataOut
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] mem [0:255]; // @[RAM.scala 13:24]
  wire  mem_io_dataOut_MPORT_en; // @[RAM.scala 13:24]
  wire [7:0] mem_io_dataOut_MPORT_addr; // @[RAM.scala 13:24]
  wire [7:0] mem_io_dataOut_MPORT_data; // @[RAM.scala 13:24]
  wire [7:0] mem_MPORT_data; // @[RAM.scala 13:24]
  wire [7:0] mem_MPORT_addr; // @[RAM.scala 13:24]
  wire  mem_MPORT_mask; // @[RAM.scala 13:24]
  wire  mem_MPORT_en; // @[RAM.scala 13:24]
  reg  mem_io_dataOut_MPORT_en_pipe_0;
  reg [7:0] mem_io_dataOut_MPORT_addr_pipe_0;
  assign mem_io_dataOut_MPORT_en = mem_io_dataOut_MPORT_en_pipe_0;
  assign mem_io_dataOut_MPORT_addr = mem_io_dataOut_MPORT_addr_pipe_0;
  assign mem_io_dataOut_MPORT_data = mem[mem_io_dataOut_MPORT_addr]; // @[RAM.scala 13:24]
  assign mem_MPORT_data = io_dataIn;
  assign mem_MPORT_addr = io_addrIn;
  assign mem_MPORT_mask = 1'h1;
  assign mem_MPORT_en = io_writeEn;
  assign io_dataOut = mem_io_dataOut_MPORT_data; // @[RAM.scala 23:14]
  always @(posedge clock) begin
    if (mem_MPORT_en & mem_MPORT_mask) begin
      mem[mem_MPORT_addr] <= mem_MPORT_data; // @[RAM.scala 13:24]
    end
    mem_io_dataOut_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      mem_io_dataOut_MPORT_addr_pipe_0 <= io_addrIn;
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
  integer initvar;
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
  mem_io_dataOut_MPORT_en_pipe_0 = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  mem_io_dataOut_MPORT_addr_pipe_0 = _RAND_1[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
  $readmemb("program.bin", mem);
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
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
  output       io_zeroFlag
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
module Processor(
  input   clock,
  input   reset,
  output  io_finished
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
`endif // RANDOMIZE_REG_INIT
  wire  ram_clock; // @[Processor.scala 77:19]
  wire  ram_io_writeEn; // @[Processor.scala 77:19]
  wire [7:0] ram_io_addrIn; // @[Processor.scala 77:19]
  wire [7:0] ram_io_dataIn; // @[Processor.scala 77:19]
  wire [7:0] ram_io_dataOut; // @[Processor.scala 77:19]
  wire  alu_clock; // @[Processor.scala 88:19]
  wire  alu_reset; // @[Processor.scala 88:19]
  wire  alu_io_op1Load; // @[Processor.scala 88:19]
  wire  alu_io_op2Load; // @[Processor.scala 88:19]
  wire  alu_io_addSig; // @[Processor.scala 88:19]
  wire  alu_io_subSig; // @[Processor.scala 88:19]
  wire  alu_io_divSig; // @[Processor.scala 88:19]
  wire  alu_io_mulSig; // @[Processor.scala 88:19]
  wire  alu_io_modSig; // @[Processor.scala 88:19]
  wire  alu_io_incSig; // @[Processor.scala 88:19]
  wire  alu_io_decSig; // @[Processor.scala 88:19]
  wire [7:0] alu_io_op1In; // @[Processor.scala 88:19]
  wire [7:0] alu_io_op2In; // @[Processor.scala 88:19]
  wire [7:0] alu_io_resultOut; // @[Processor.scala 88:19]
  wire  alu_io_zeroFlag; // @[Processor.scala 88:19]
  reg  finishedReg; // @[Processor.scala 74:28]
  reg [7:0] instructionPointerReg; // @[Processor.scala 80:38]
  reg [7:0] aReg; // @[Processor.scala 81:21]
  reg [7:0] bReg; // @[Processor.scala 82:21]
  reg [7:0] cReg; // @[Processor.scala 83:21]
  reg [7:0] stackPointerReg; // @[Processor.scala 84:32]
  reg [7:0] mdr; // @[Processor.scala 85:20]
  reg [2:0] currentState; // @[Processor.scala 90:29]
  reg [7:0] dataRegister; // @[Processor.scala 91:29]
  reg [7:0] instruction_opcode; // @[Processor.scala 94:28]
  reg [7:0] instruction_operands_0; // @[Processor.scala 94:28]
  reg [7:0] instruction_operands_1; // @[Processor.scala 94:28]
  reg [1:0] bytesToRead; // @[Processor.scala 101:28]
  reg [1:0] operandCount; // @[Processor.scala 102:29]
  reg [2:0] tStateCount_value; // @[Counter.scala 61:40]
  wire  _T_3 = tStateCount_value == 3'h0; // @[Processor.scala 148:31]
  wire [2:0] _value_T_1 = tStateCount_value + 3'h1; // @[Counter.scala 77:24]
  wire  _T_4 = tStateCount_value == 3'h1; // @[Processor.scala 152:39]
  wire  _T_107 = tStateCount_value == 3'h2; // @[Processor.scala 517:43]
  wire  _GEN_162 = _T_4 ? 1'h0 : _T_107; // @[Processor.scala 130:12 512:52]
  wire  _GEN_171 = _T_3 ? 1'h0 : _GEN_162; // @[Processor.scala 130:12 497:44]
  wire  _T_131 = tStateCount_value == 3'h3; // @[Processor.scala 613:43]
  wire  _GEN_224 = _T_107 ? 1'h0 : _T_131; // @[Processor.scala 130:12 609:52]
  wire  _GEN_233 = _T_4 ? 1'h0 : _GEN_224; // @[Processor.scala 130:12 594:52]
  wire  _GEN_243 = _T_3 ? 1'h0 : _GEN_233; // @[Processor.scala 130:12 580:44]
  wire  _T_143 = tStateCount_value == 3'h4; // @[Processor.scala 663:43]
  wire  _GEN_265 = _T_131 ? 1'h0 : _T_143; // @[Processor.scala 130:12 659:52]
  wire  _GEN_273 = _T_107 ? 1'h0 : _GEN_265; // @[Processor.scala 130:12 654:52]
  wire  _GEN_282 = _T_4 ? 1'h0 : _GEN_273; // @[Processor.scala 130:12 650:52]
  wire  _GEN_292 = _T_3 ? 1'h0 : _GEN_282; // @[Processor.scala 130:12 635:44]
  wire  _GEN_1086 = 8'h20 == instruction_opcode & _GEN_243; // @[Processor.scala 130:12 322:23]
  wire  _GEN_1103 = 8'h1b == instruction_opcode ? _GEN_292 : _GEN_1086; // @[Processor.scala 322:23]
  wire  _GEN_1118 = 8'h18 == instruction_opcode ? _GEN_243 : _GEN_1103; // @[Processor.scala 322:23]
  wire  _GEN_1134 = 8'h1f == instruction_opcode ? _GEN_243 : _GEN_1118; // @[Processor.scala 322:23]
  wire  _GEN_1152 = 8'h1a == instruction_opcode ? _GEN_292 : _GEN_1134; // @[Processor.scala 322:23]
  wire  _GEN_1168 = 8'h17 == instruction_opcode ? _GEN_243 : _GEN_1152; // @[Processor.scala 322:23]
  wire  _GEN_1185 = 8'h1e == instruction_opcode ? _GEN_243 : _GEN_1168; // @[Processor.scala 322:23]
  wire  _GEN_1204 = 8'h19 == instruction_opcode ? _GEN_292 : _GEN_1185; // @[Processor.scala 322:23]
  wire  _GEN_1221 = 8'h16 == instruction_opcode ? _GEN_243 : _GEN_1204; // @[Processor.scala 322:23]
  wire  _GEN_1239 = 8'h1d == instruction_opcode ? _GEN_243 : _GEN_1221; // @[Processor.scala 322:23]
  wire  _GEN_1259 = 8'hb == instruction_opcode ? _GEN_292 : _GEN_1239; // @[Processor.scala 322:23]
  wire  _GEN_1277 = 8'ha == instruction_opcode ? _GEN_243 : _GEN_1259; // @[Processor.scala 322:23]
  wire  _GEN_1296 = 8'h1c == instruction_opcode ? _GEN_243 : _GEN_1277; // @[Processor.scala 322:23]
  wire  _GEN_1317 = 8'h9 == instruction_opcode ? _GEN_292 : _GEN_1296; // @[Processor.scala 322:23]
  wire  _GEN_1336 = 8'h8 == instruction_opcode ? _GEN_243 : _GEN_1317; // @[Processor.scala 322:23]
  wire  _GEN_1358 = 8'h7 == instruction_opcode ? _GEN_171 : _GEN_1336; // @[Processor.scala 322:23]
  wire  _GEN_1379 = 8'h6 == instruction_opcode ? _GEN_171 : _GEN_1358; // @[Processor.scala 322:23]
  wire  _GEN_1404 = 8'h5 == instruction_opcode ? 1'h0 : _GEN_1379; // @[Processor.scala 130:12 322:23]
  wire  _GEN_1427 = 8'h4 == instruction_opcode ? 1'h0 : _GEN_1404; // @[Processor.scala 130:12 322:23]
  wire  _GEN_1449 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1427; // @[Processor.scala 130:12 322:23]
  wire  _GEN_1471 = 8'h2 == instruction_opcode ? 1'h0 : _GEN_1449; // @[Processor.scala 130:12 322:23]
  wire  _GEN_1494 = 8'h1 == instruction_opcode ? 1'h0 : _GEN_1471; // @[Processor.scala 130:12 322:23]
  wire  _GEN_1517 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1494; // @[Processor.scala 130:12 322:23]
  wire  _GEN_1569 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1517; // @[Processor.scala 130:12 145:25]
  wire  _GEN_1598 = 3'h3 == currentState ? 1'h0 : _GEN_1569; // @[Processor.scala 130:12 145:25]
  wire  _GEN_1627 = 3'h2 == currentState ? 1'h0 : _GEN_1598; // @[Processor.scala 130:12 145:25]
  wire  _GEN_1657 = 3'h1 == currentState ? 1'h0 : _GEN_1627; // @[Processor.scala 130:12 145:25]
  wire  resultEn = 3'h0 == currentState ? 1'h0 : _GEN_1657; // @[Processor.scala 130:12 145:25]
  wire  _GEN_73 = _T_3 ? 1'h0 : _T_4; // @[Processor.scala 367:44 128:9]
  wire  _GEN_1512 = 8'h0 == instruction_opcode ? 1'h0 : 8'h1 == instruction_opcode & _GEN_73; // @[Processor.scala 322:23 128:9]
  wire  _GEN_1564 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1512; // @[Processor.scala 145:25 128:9]
  wire  _GEN_1593 = 3'h3 == currentState ? 1'h0 : _GEN_1564; // @[Processor.scala 145:25 128:9]
  wire  _GEN_1622 = 3'h2 == currentState ? 1'h0 : _GEN_1593; // @[Processor.scala 145:25 128:9]
  wire  _GEN_1653 = 3'h1 == currentState ? 1'h0 : _GEN_1622; // @[Processor.scala 145:25 128:9]
  wire  op2En = 3'h0 == currentState ? 1'h0 : _GEN_1653; // @[Processor.scala 145:25 128:9]
  wire  zeroFlag = alu_io_zeroFlag; // @[Processor.scala 122:29 1541:12]
  wire  _T_309 = ~zeroFlag; // @[Processor.scala 1346:17]
  wire  _GEN_998 = 8'h14 == instruction_opcode ? 1'h0 : 8'h10 == instruction_opcode & _GEN_243; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1011 = 8'h12 == instruction_opcode ? 1'h0 : _GEN_998; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1023 = 8'h11 == instruction_opcode ? 1'h0 : _GEN_1011; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1037 = 8'hf == instruction_opcode ? 1'h0 : _GEN_1023; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1039 = 8'he == instruction_opcode ? _T_309 : _GEN_1037; // @[Processor.scala 322:23]
  wire  _GEN_1053 = 8'hd == instruction_opcode ? zeroFlag : _GEN_1039; // @[Processor.scala 322:23]
  wire  _GEN_1067 = 8'hc == instruction_opcode | _GEN_1053; // @[Processor.scala 1330:17 322:23]
  wire  _GEN_1091 = 8'h20 == instruction_opcode ? 1'h0 : _GEN_1067; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1108 = 8'h1b == instruction_opcode ? 1'h0 : _GEN_1091; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1124 = 8'h18 == instruction_opcode ? 1'h0 : _GEN_1108; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1141 = 8'h1f == instruction_opcode ? 1'h0 : _GEN_1124; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1158 = 8'h1a == instruction_opcode ? 1'h0 : _GEN_1141; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1175 = 8'h17 == instruction_opcode ? 1'h0 : _GEN_1158; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1193 = 8'h1e == instruction_opcode ? 1'h0 : _GEN_1175; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1211 = 8'h19 == instruction_opcode ? 1'h0 : _GEN_1193; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1229 = 8'h16 == instruction_opcode ? 1'h0 : _GEN_1211; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1248 = 8'h1d == instruction_opcode ? 1'h0 : _GEN_1229; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1267 = 8'hb == instruction_opcode ? 1'h0 : _GEN_1248; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1286 = 8'ha == instruction_opcode ? 1'h0 : _GEN_1267; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1306 = 8'h1c == instruction_opcode ? 1'h0 : _GEN_1286; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1326 = 8'h9 == instruction_opcode ? 1'h0 : _GEN_1306; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1346 = 8'h8 == instruction_opcode ? 1'h0 : _GEN_1326; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1367 = 8'h7 == instruction_opcode ? 1'h0 : _GEN_1346; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1389 = 8'h6 == instruction_opcode ? 1'h0 : _GEN_1367; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1413 = 8'h5 == instruction_opcode ? 1'h0 : _GEN_1389; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1435 = 8'h4 == instruction_opcode ? 1'h0 : _GEN_1413; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1457 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1435; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1479 = 8'h2 == instruction_opcode ? 1'h0 : _GEN_1457; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1502 = 8'h1 == instruction_opcode ? 1'h0 : _GEN_1479; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1525 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1502; // @[Processor.scala 322:23 127:9]
  wire  _GEN_1577 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1525; // @[Processor.scala 145:25 127:9]
  wire  _GEN_1606 = 3'h3 == currentState ? 1'h0 : _GEN_1577; // @[Processor.scala 145:25 127:9]
  wire  _GEN_1635 = 3'h2 == currentState ? 1'h0 : _GEN_1606; // @[Processor.scala 145:25 127:9]
  wire  _GEN_1665 = 3'h1 == currentState ? 1'h0 : _GEN_1635; // @[Processor.scala 145:25 127:9]
  wire  op1En = 3'h0 == currentState ? 1'h0 : _GEN_1665; // @[Processor.scala 145:25 127:9]
  wire  _GEN_991 = 8'h10 == instruction_opcode ? 1'h0 : 8'h13 == instruction_opcode & _GEN_171; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1000 = 8'h14 == instruction_opcode ? 1'h0 : _GEN_991; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1004 = 8'h12 == instruction_opcode ? _GEN_171 : _GEN_1000; // @[Processor.scala 322:23]
  wire  _GEN_1019 = 8'h11 == instruction_opcode ? 1'h0 : _GEN_1004; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1033 = 8'hf == instruction_opcode ? 1'h0 : _GEN_1019; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1049 = 8'he == instruction_opcode ? 1'h0 : _GEN_1033; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1063 = 8'hd == instruction_opcode ? 1'h0 : _GEN_1049; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1077 = 8'hc == instruction_opcode ? 1'h0 : _GEN_1063; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1096 = 8'h20 == instruction_opcode ? 1'h0 : _GEN_1077; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1100 = 8'h1b == instruction_opcode ? _GEN_171 : _GEN_1096; // @[Processor.scala 322:23]
  wire  _GEN_1123 = 8'h18 == instruction_opcode ? 1'h0 : _GEN_1100; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1140 = 8'h1f == instruction_opcode ? 1'h0 : _GEN_1123; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1149 = 8'h1a == instruction_opcode ? _GEN_171 : _GEN_1140; // @[Processor.scala 322:23]
  wire  _GEN_1173 = 8'h17 == instruction_opcode ? 1'h0 : _GEN_1149; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1191 = 8'h1e == instruction_opcode ? 1'h0 : _GEN_1173; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1201 = 8'h19 == instruction_opcode ? _GEN_171 : _GEN_1191; // @[Processor.scala 322:23]
  wire  _GEN_1226 = 8'h16 == instruction_opcode ? 1'h0 : _GEN_1201; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1245 = 8'h1d == instruction_opcode ? 1'h0 : _GEN_1226; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1256 = 8'hb == instruction_opcode ? _GEN_171 : _GEN_1245; // @[Processor.scala 322:23]
  wire  _GEN_1282 = 8'ha == instruction_opcode ? 1'h0 : _GEN_1256; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1302 = 8'h1c == instruction_opcode ? 1'h0 : _GEN_1282; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1314 = 8'h9 == instruction_opcode ? _GEN_171 : _GEN_1302; // @[Processor.scala 322:23]
  wire  _GEN_1341 = 8'h8 == instruction_opcode ? 1'h0 : _GEN_1314; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1362 = 8'h7 == instruction_opcode ? 1'h0 : _GEN_1341; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1384 = 8'h6 == instruction_opcode ? 1'h0 : _GEN_1362; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1408 = 8'h5 == instruction_opcode ? 1'h0 : _GEN_1384; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1418 = 8'h4 == instruction_opcode ? _GEN_73 : _GEN_1408; // @[Processor.scala 322:23]
  wire  _GEN_1444 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1418; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1462 = 8'h2 == instruction_opcode ? _GEN_73 : _GEN_1444; // @[Processor.scala 322:23]
  wire  _GEN_1488 = 8'h1 == instruction_opcode ? 1'h0 : _GEN_1462; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1514 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1488; // @[Processor.scala 126:10 322:23]
  wire  _GEN_1566 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1514; // @[Processor.scala 126:10 145:25]
  wire  _GEN_1595 = 3'h3 == currentState ? 1'h0 : _GEN_1566; // @[Processor.scala 126:10 145:25]
  wire  _GEN_1624 = 3'h2 == currentState ? 1'h0 : _GEN_1595; // @[Processor.scala 126:10 145:25]
  wire  _GEN_1640 = 3'h1 == currentState ? _GEN_73 : _GEN_1624; // @[Processor.scala 145:25]
  wire  dataEn = 3'h0 == currentState ? _GEN_73 : _GEN_1640; // @[Processor.scala 145:25]
  wire [7:0] _GEN_15 = _T_3 ? instructionPointerReg : 8'h0; // @[Processor.scala 161:40 163:13 142:24]
  wire  _T_60 = 8'h0 == instruction_operands_0; // @[Processor.scala 340:44]
  wire  _T_61 = 8'h1 == instruction_operands_0; // @[Processor.scala 340:44]
  wire  _T_62 = 8'h2 == instruction_operands_0; // @[Processor.scala 340:44]
  wire [7:0] _GEN_56 = 8'h2 == instruction_operands_0 ? cReg : 8'h0; // @[Processor.scala 340:44 348:19 142:24]
  wire [7:0] _GEN_57 = 8'h1 == instruction_operands_0 ? bReg : _GEN_56; // @[Processor.scala 340:44 345:19]
  wire [7:0] _GEN_58 = 8'h0 == instruction_operands_0 ? aReg : _GEN_57; // @[Processor.scala 340:44 342:19]
  wire [7:0] _GEN_87 = _T_3 ? instruction_operands_0 : 8'h0; // @[Processor.scala 389:44 391:17 142:24]
  wire [7:0] _GEN_120 = _T_3 ? _GEN_58 : 8'h0; // @[Processor.scala 142:24 432:44]
  wire  _T_98 = 8'h0 == instruction_operands_1; // @[Processor.scala 478:46]
  wire  _T_99 = 8'h1 == instruction_operands_1; // @[Processor.scala 478:46]
  wire  _T_100 = 8'h2 == instruction_operands_1; // @[Processor.scala 478:46]
  wire [7:0] _GEN_130 = 8'h2 == instruction_operands_1 ? cReg : 8'h0; // @[Processor.scala 478:46 486:21 142:24]
  wire [7:0] _GEN_131 = 8'h1 == instruction_operands_1 ? bReg : _GEN_130; // @[Processor.scala 478:46 483:21]
  wire [7:0] _GEN_132 = 8'h0 == instruction_operands_1 ? aReg : _GEN_131; // @[Processor.scala 478:46 480:21]
  wire [7:0] _GEN_133 = _T_4 ? _GEN_132 : 8'h0; // @[Processor.scala 142:24 477:51]
  wire [7:0] _GEN_139 = _T_3 ? 8'h0 : _GEN_133; // @[Processor.scala 142:24 464:44]
  wire [7:0] _GEN_238 = _T_3 ? _GEN_58 : _GEN_133; // @[Processor.scala 580:44]
  wire [7:0] _GEN_278 = _T_4 ? instruction_operands_1 : 8'h0; // @[Processor.scala 650:52 652:17 142:24]
  wire [7:0] _GEN_287 = _T_3 ? _GEN_58 : _GEN_278; // @[Processor.scala 635:44]
  wire [7:0] _GEN_899 = _T_4 ? stackPointerReg : 8'h0; // @[Processor.scala 1406:52 1408:17 142:24]
  wire [7:0] _GEN_906 = _T_3 ? 8'h0 : _GEN_899; // @[Processor.scala 1392:44 142:24]
  wire [7:0] _GEN_979 = 8'h13 == instruction_opcode ? _GEN_906 : 8'h0; // @[Processor.scala 322:23 142:24]
  wire [7:0] _GEN_985 = 8'h10 == instruction_opcode ? _GEN_906 : _GEN_979; // @[Processor.scala 322:23]
  wire [7:0] _GEN_995 = 8'h14 == instruction_opcode ? 8'h0 : _GEN_985; // @[Processor.scala 322:23 142:24]
  wire [7:0] _GEN_1003 = 8'h12 == instruction_opcode ? _GEN_906 : _GEN_995; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1015 = 8'h11 == instruction_opcode ? _GEN_906 : _GEN_1003; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1025 = 8'hf == instruction_opcode ? _GEN_238 : _GEN_1015; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1042 = 8'he == instruction_opcode ? 8'h0 : _GEN_1025; // @[Processor.scala 322:23 142:24]
  wire [7:0] _GEN_1056 = 8'hd == instruction_opcode ? 8'h0 : _GEN_1042; // @[Processor.scala 322:23 142:24]
  wire [7:0] _GEN_1070 = 8'hc == instruction_opcode ? 8'h0 : _GEN_1056; // @[Processor.scala 322:23 142:24]
  wire [7:0] _GEN_1081 = 8'h20 == instruction_opcode ? _GEN_287 : _GEN_1070; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1097 = 8'h1b == instruction_opcode ? _GEN_287 : _GEN_1081; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1113 = 8'h18 == instruction_opcode ? _GEN_238 : _GEN_1097; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1129 = 8'h1f == instruction_opcode ? _GEN_287 : _GEN_1113; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1146 = 8'h1a == instruction_opcode ? _GEN_287 : _GEN_1129; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1163 = 8'h17 == instruction_opcode ? _GEN_238 : _GEN_1146; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1180 = 8'h1e == instruction_opcode ? _GEN_287 : _GEN_1163; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1198 = 8'h19 == instruction_opcode ? _GEN_287 : _GEN_1180; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1216 = 8'h16 == instruction_opcode ? _GEN_238 : _GEN_1198; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1234 = 8'h1d == instruction_opcode ? _GEN_287 : _GEN_1216; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1253 = 8'hb == instruction_opcode ? _GEN_287 : _GEN_1234; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1272 = 8'ha == instruction_opcode ? _GEN_238 : _GEN_1253; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1291 = 8'h1c == instruction_opcode ? _GEN_287 : _GEN_1272; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1311 = 8'h9 == instruction_opcode ? _GEN_287 : _GEN_1291; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1331 = 8'h8 == instruction_opcode ? _GEN_238 : _GEN_1311; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1351 = 8'h7 == instruction_opcode ? _GEN_120 : _GEN_1331; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1372 = 8'h6 == instruction_opcode ? _GEN_120 : _GEN_1351; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1396 = 8'h5 == instruction_opcode ? _GEN_139 : _GEN_1372; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1416 = 8'h4 == instruction_opcode ? _GEN_120 : _GEN_1396; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1443 = 8'h3 == instruction_opcode ? 8'h0 : _GEN_1416; // @[Processor.scala 322:23 142:24]
  wire [7:0] _GEN_1460 = 8'h2 == instruction_opcode ? _GEN_87 : _GEN_1443; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1487 = 8'h1 == instruction_opcode ? 8'h0 : _GEN_1460; // @[Processor.scala 322:23 142:24]
  wire [7:0] _GEN_1505 = 8'h0 == instruction_opcode ? _GEN_58 : _GEN_1487; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1529 = 3'h5 == currentState ? _GEN_1505 : 8'h0; // @[Processor.scala 142:24 145:25]
  wire [7:0] _GEN_1558 = 3'h4 == currentState ? 8'h0 : _GEN_1529; // @[Processor.scala 142:24 145:25]
  wire [7:0] _GEN_1587 = 3'h3 == currentState ? 8'h0 : _GEN_1558; // @[Processor.scala 142:24 145:25]
  wire [7:0] _GEN_1616 = 3'h2 == currentState ? 8'h0 : _GEN_1587; // @[Processor.scala 142:24 145:25]
  wire [7:0] _GEN_1638 = 3'h1 == currentState ? _GEN_15 : _GEN_1616; // @[Processor.scala 145:25]
  wire [7:0] _GEN_1668 = 3'h0 == currentState ? 8'h0 : _GEN_1638; // @[Processor.scala 145:25]
  wire [7:0] _GEN_1698 = dataEn ? ram_io_dataOut : _GEN_1668; // @[Processor.scala 1548:17 1549:9]
  wire [7:0] _GEN_1699 = op1En ? instruction_operands_0 : _GEN_1698; // @[Processor.scala 1554:16 1555:9]
  wire [7:0] _GEN_1700 = op2En ? instruction_operands_1 : _GEN_1699; // @[Processor.scala 1557:16 1558:9]
  wire [7:0] bus = resultEn ? alu_io_resultOut : _GEN_1700; // @[Processor.scala 1566:19 1567:9]
  wire [2:0] _GEN_2 = tStateCount_value == 3'h1 ? 3'h1 : currentState; // @[Processor.scala 152:48 156:22 90:29]
  wire [2:0] _GEN_3 = tStateCount_value == 3'h1 ? 3'h0 : tStateCount_value; // @[Processor.scala 152:48 Counter.scala 98:11 61:40]
  wire [2:0] _GEN_5 = tStateCount_value == 3'h0 ? _value_T_1 : _GEN_3; // @[Processor.scala 148:40 Counter.scala 77:15]
  wire [2:0] _GEN_8 = tStateCount_value == 3'h0 ? currentState : _GEN_2; // @[Processor.scala 148:40 90:29]
  wire  _T_10 = bytesToRead == 2'h0; // @[Processor.scala 171:27]
  wire [2:0] _GEN_9 = bytesToRead > 2'h0 ? 3'h4 : currentState; // @[Processor.scala 175:41 178:24 90:29]
  wire [2:0] _GEN_10 = bytesToRead == 2'h0 ? 3'h2 : _GEN_9; // @[Processor.scala 171:36 174:24]
  wire [7:0] _GEN_12 = _T_4 ? bus : dataRegister; // @[Processor.scala 165:47 168:22 91:29]
  wire [2:0] _GEN_14 = _T_4 ? _GEN_10 : currentState; // @[Processor.scala 165:47 90:29]
  wire [1:0] _GEN_20 = 8'h20 == dataRegister ? 2'h2 : bytesToRead; // @[Processor.scala 191:29 291:23 101:28]
  wire [1:0] _GEN_21 = 8'h1f == dataRegister ? 2'h2 : _GEN_20; // @[Processor.scala 191:29 288:23]
  wire [1:0] _GEN_22 = 8'h1e == dataRegister ? 2'h2 : _GEN_21; // @[Processor.scala 191:29 285:23]
  wire [1:0] _GEN_23 = 8'h1d == dataRegister ? 2'h2 : _GEN_22; // @[Processor.scala 191:29 282:23]
  wire [1:0] _GEN_24 = 8'h1c == dataRegister ? 2'h2 : _GEN_23; // @[Processor.scala 191:29 279:23]
  wire [1:0] _GEN_25 = 8'h10 == dataRegister ? 2'h1 : _GEN_24; // @[Processor.scala 191:29 276:23]
  wire [1:0] _GEN_26 = 8'h15 == dataRegister ? 2'h0 : _GEN_25; // @[Processor.scala 191:29 273:23]
  wire [1:0] _GEN_27 = 8'h13 == dataRegister ? 2'h0 : _GEN_26; // @[Processor.scala 191:29 270:23]
  wire [1:0] _GEN_28 = 8'h14 == dataRegister ? 2'h0 : _GEN_27; // @[Processor.scala 191:29 267:23]
  wire [1:0] _GEN_29 = 8'h12 == dataRegister ? 2'h1 : _GEN_28; // @[Processor.scala 191:29 264:23]
  wire [1:0] _GEN_30 = 8'h11 == dataRegister ? 2'h1 : _GEN_29; // @[Processor.scala 191:29 261:23]
  wire [1:0] _GEN_31 = 8'hf == dataRegister ? 2'h2 : _GEN_30; // @[Processor.scala 191:29 258:23]
  wire [1:0] _GEN_32 = 8'he == dataRegister ? 2'h1 : _GEN_31; // @[Processor.scala 191:29 255:23]
  wire [1:0] _GEN_33 = 8'hd == dataRegister ? 2'h1 : _GEN_32; // @[Processor.scala 191:29 252:23]
  wire [1:0] _GEN_34 = 8'hc == dataRegister ? 2'h1 : _GEN_33; // @[Processor.scala 191:29 249:23]
  wire [1:0] _GEN_35 = 8'h1b == dataRegister ? 2'h2 : _GEN_34; // @[Processor.scala 191:29 246:23]
  wire [1:0] _GEN_36 = 8'h1a == dataRegister ? 2'h2 : _GEN_35; // @[Processor.scala 191:29 243:23]
  wire [1:0] _GEN_37 = 8'h19 == dataRegister ? 2'h2 : _GEN_36; // @[Processor.scala 191:29 240:23]
  wire [1:0] _GEN_38 = 8'h18 == dataRegister ? 2'h2 : _GEN_37; // @[Processor.scala 191:29 237:23]
  wire [1:0] _GEN_39 = 8'h17 == dataRegister ? 2'h2 : _GEN_38; // @[Processor.scala 191:29 234:23]
  wire [1:0] _GEN_40 = 8'h16 == dataRegister ? 2'h2 : _GEN_39; // @[Processor.scala 191:29 231:23]
  wire [1:0] _GEN_41 = 8'hb == dataRegister ? 2'h2 : _GEN_40; // @[Processor.scala 191:29 228:23]
  wire [1:0] _GEN_42 = 8'ha == dataRegister ? 2'h2 : _GEN_41; // @[Processor.scala 191:29 225:23]
  wire [1:0] _GEN_43 = 8'h9 == dataRegister ? 2'h2 : _GEN_42; // @[Processor.scala 191:29 222:23]
  wire [1:0] _GEN_44 = 8'h8 == dataRegister ? 2'h2 : _GEN_43; // @[Processor.scala 191:29 219:23]
  wire [1:0] _GEN_45 = 8'h7 == dataRegister ? 2'h1 : _GEN_44; // @[Processor.scala 191:29 216:23]
  wire [1:0] _GEN_46 = 8'h6 == dataRegister ? 2'h1 : _GEN_45; // @[Processor.scala 191:29 213:23]
  wire [1:0] _GEN_47 = 8'h5 == dataRegister ? 2'h2 : _GEN_46; // @[Processor.scala 191:29 210:23]
  wire [1:0] _GEN_48 = 8'h4 == dataRegister ? 2'h2 : _GEN_47; // @[Processor.scala 191:29 207:23]
  wire [1:0] _GEN_49 = 8'h3 == dataRegister ? 2'h2 : _GEN_48; // @[Processor.scala 191:29 204:23]
  wire [1:0] _GEN_50 = 8'h2 == dataRegister ? 2'h2 : _GEN_49; // @[Processor.scala 191:29 201:23]
  wire [1:0] _GEN_51 = 8'h1 == dataRegister ? 2'h2 : _GEN_50; // @[Processor.scala 191:29 198:23]
  wire [1:0] _GEN_52 = 8'h0 == dataRegister ? 2'h2 : _GEN_51; // @[Processor.scala 191:29 195:23]
  wire [7:0] _instructionPointerReg_T_1 = instructionPointerReg + 8'h1; // @[Processor.scala 300:54]
  wire [2:0] _GEN_53 = _T_10 ? 3'h5 : 3'h1; // @[Processor.scala 301:34 304:22 308:22]
  wire [7:0] _GEN_54 = ~operandCount[0] ? dataRegister : instruction_operands_0; // @[Processor.scala 312:{42,42} 94:28]
  wire [7:0] _GEN_55 = operandCount[0] ? dataRegister : instruction_operands_1; // @[Processor.scala 312:{42,42} 94:28]
  wire [1:0] _bytesToRead_T_1 = bytesToRead - 2'h1; // @[Processor.scala 313:34]
  wire [1:0] _operandCount_T_1 = operandCount + 2'h1; // @[Processor.scala 314:36]
  wire [7:0] _GEN_59 = _T_100 ? bus : cReg; // @[Processor.scala 352:44 360:20 83:21]
  wire [7:0] _GEN_60 = _T_99 ? bus : bReg; // @[Processor.scala 352:44 357:20 82:21]
  wire [7:0] _GEN_61 = _T_99 ? cReg : _GEN_59; // @[Processor.scala 352:44 83:21]
  wire [7:0] _GEN_62 = _T_98 ? bus : aReg; // @[Processor.scala 352:44 354:20 81:21]
  wire [7:0] _GEN_63 = _T_98 ? bReg : _GEN_60; // @[Processor.scala 352:44 82:21]
  wire [7:0] _GEN_64 = _T_98 ? cReg : _GEN_61; // @[Processor.scala 352:44 83:21]
  wire [7:0] _GEN_65 = _T_62 ? cReg : mdr; // @[Processor.scala 368:46 376:21 85:20]
  wire [7:0] _GEN_66 = _T_61 ? bReg : _GEN_65; // @[Processor.scala 368:46 373:21]
  wire [7:0] _GEN_67 = _T_60 ? aReg : _GEN_66; // @[Processor.scala 368:46 370:21]
  wire [7:0] _GEN_71 = _T_3 ? _GEN_67 : mdr; // @[Processor.scala 367:44 85:20]
  wire [7:0] _GEN_82 = _T_4 ? _GEN_62 : aReg; // @[Processor.scala 393:52 81:21]
  wire [7:0] _GEN_83 = _T_4 ? _GEN_63 : bReg; // @[Processor.scala 393:52 82:21]
  wire [7:0] _GEN_84 = _T_4 ? _GEN_64 : cReg; // @[Processor.scala 393:52 83:21]
  wire [7:0] _GEN_90 = _T_3 ? aReg : _GEN_82; // @[Processor.scala 389:44 81:21]
  wire [7:0] _GEN_91 = _T_3 ? bReg : _GEN_83; // @[Processor.scala 389:44 82:21]
  wire [7:0] _GEN_92 = _T_3 ? cReg : _GEN_84; // @[Processor.scala 389:44 83:21]
  wire [7:0] _GEN_94 = _T_100 ? instruction_operands_0 : cReg; // @[Processor.scala 415:46 423:22 83:21]
  wire [7:0] _GEN_95 = _T_99 ? instruction_operands_0 : bReg; // @[Processor.scala 415:46 420:22 82:21]
  wire [7:0] _GEN_96 = _T_99 ? cReg : _GEN_94; // @[Processor.scala 415:46 83:21]
  wire [7:0] _GEN_97 = _T_98 ? instruction_operands_0 : aReg; // @[Processor.scala 415:46 417:22 81:21]
  wire [7:0] _GEN_98 = _T_98 ? bReg : _GEN_95; // @[Processor.scala 415:46 82:21]
  wire [7:0] _GEN_99 = _T_98 ? cReg : _GEN_96; // @[Processor.scala 415:46 83:21]
  wire [7:0] _GEN_100 = _T_3 ? _GEN_97 : aReg; // @[Processor.scala 413:44 81:21]
  wire [7:0] _GEN_101 = _T_3 ? _GEN_98 : bReg; // @[Processor.scala 413:44 82:21]
  wire [7:0] _GEN_102 = _T_3 ? _GEN_99 : cReg; // @[Processor.scala 413:44 83:21]
  wire [2:0] _GEN_103 = _T_3 ? 3'h1 : currentState; // @[Processor.scala 413:44 426:26 90:29]
  wire [2:0] _GEN_104 = _T_3 ? 3'h0 : tStateCount_value; // @[Processor.scala 413:44 Counter.scala 98:11 61:40]
  wire [7:0] _GEN_145 = _T_62 ? bus : cReg; // @[Processor.scala 519:46 527:22 83:21]
  wire [7:0] _GEN_146 = _T_61 ? bus : bReg; // @[Processor.scala 519:46 524:22 82:21]
  wire [7:0] _GEN_147 = _T_61 ? cReg : _GEN_145; // @[Processor.scala 519:46 83:21]
  wire [7:0] _GEN_148 = _T_60 ? bus : aReg; // @[Processor.scala 519:46 521:22 81:21]
  wire [7:0] _GEN_149 = _T_60 ? bReg : _GEN_146; // @[Processor.scala 519:46 82:21]
  wire [7:0] _GEN_150 = _T_60 ? cReg : _GEN_147; // @[Processor.scala 519:46 83:21]
  wire [7:0] _GEN_151 = tStateCount_value == 3'h2 ? _GEN_148 : aReg; // @[Processor.scala 517:52 81:21]
  wire [7:0] _GEN_152 = tStateCount_value == 3'h2 ? _GEN_149 : bReg; // @[Processor.scala 517:52 82:21]
  wire [7:0] _GEN_153 = tStateCount_value == 3'h2 ? _GEN_150 : cReg; // @[Processor.scala 517:52 83:21]
  wire [2:0] _GEN_155 = tStateCount_value == 3'h2 ? 3'h0 : tStateCount_value; // @[Processor.scala 517:52 Counter.scala 98:11 61:40]
  wire [2:0] _GEN_156 = tStateCount_value == 3'h2 ? 3'h1 : currentState; // @[Processor.scala 517:52 532:26 90:29]
  wire [2:0] _GEN_158 = _T_4 ? _value_T_1 : _GEN_155; // @[Processor.scala 512:52 Counter.scala 77:15]
  wire [7:0] _GEN_159 = _T_4 ? aReg : _GEN_151; // @[Processor.scala 512:52 81:21]
  wire [7:0] _GEN_160 = _T_4 ? bReg : _GEN_152; // @[Processor.scala 512:52 82:21]
  wire [7:0] _GEN_161 = _T_4 ? cReg : _GEN_153; // @[Processor.scala 512:52 83:21]
  wire [2:0] _GEN_163 = _T_4 ? currentState : _GEN_156; // @[Processor.scala 512:52 90:29]
  wire [2:0] _GEN_166 = _T_3 ? _value_T_1 : _GEN_158; // @[Processor.scala 497:44 Counter.scala 77:15]
  wire [7:0] _GEN_168 = _T_3 ? aReg : _GEN_159; // @[Processor.scala 497:44 81:21]
  wire [7:0] _GEN_169 = _T_3 ? bReg : _GEN_160; // @[Processor.scala 497:44 82:21]
  wire [7:0] _GEN_170 = _T_3 ? cReg : _GEN_161; // @[Processor.scala 497:44 83:21]
  wire [2:0] _GEN_172 = _T_3 ? currentState : _GEN_163; // @[Processor.scala 497:44 90:29]
  wire [7:0] _GEN_217 = tStateCount_value == 3'h3 ? _GEN_148 : aReg; // @[Processor.scala 613:52 81:21]
  wire [7:0] _GEN_218 = tStateCount_value == 3'h3 ? _GEN_149 : bReg; // @[Processor.scala 613:52 82:21]
  wire [7:0] _GEN_219 = tStateCount_value == 3'h3 ? _GEN_150 : cReg; // @[Processor.scala 613:52 83:21]
  wire [2:0] _GEN_220 = tStateCount_value == 3'h3 ? 3'h0 : tStateCount_value; // @[Processor.scala 613:52 Counter.scala 98:11 61:40]
  wire [2:0] _GEN_221 = tStateCount_value == 3'h3 ? 3'h1 : currentState; // @[Processor.scala 613:52 628:26 90:29]
  wire [2:0] _GEN_223 = _T_107 ? _value_T_1 : _GEN_220; // @[Processor.scala 609:52 Counter.scala 77:15]
  wire [7:0] _GEN_225 = _T_107 ? aReg : _GEN_217; // @[Processor.scala 609:52 81:21]
  wire [7:0] _GEN_226 = _T_107 ? bReg : _GEN_218; // @[Processor.scala 609:52 82:21]
  wire [7:0] _GEN_227 = _T_107 ? cReg : _GEN_219; // @[Processor.scala 609:52 83:21]
  wire [2:0] _GEN_228 = _T_107 ? currentState : _GEN_221; // @[Processor.scala 609:52 90:29]
  wire [2:0] _GEN_231 = _T_4 ? _value_T_1 : _GEN_223; // @[Processor.scala 594:52 Counter.scala 77:15]
  wire [7:0] _GEN_234 = _T_4 ? aReg : _GEN_225; // @[Processor.scala 594:52 81:21]
  wire [7:0] _GEN_235 = _T_4 ? bReg : _GEN_226; // @[Processor.scala 594:52 82:21]
  wire [7:0] _GEN_236 = _T_4 ? cReg : _GEN_227; // @[Processor.scala 594:52 83:21]
  wire [2:0] _GEN_237 = _T_4 ? currentState : _GEN_228; // @[Processor.scala 594:52 90:29]
  wire [2:0] _GEN_240 = _T_3 ? _value_T_1 : _GEN_231; // @[Processor.scala 580:44 Counter.scala 77:15]
  wire [7:0] _GEN_244 = _T_3 ? aReg : _GEN_234; // @[Processor.scala 580:44 81:21]
  wire [7:0] _GEN_245 = _T_3 ? bReg : _GEN_235; // @[Processor.scala 580:44 82:21]
  wire [7:0] _GEN_246 = _T_3 ? cReg : _GEN_236; // @[Processor.scala 580:44 83:21]
  wire [2:0] _GEN_247 = _T_3 ? currentState : _GEN_237; // @[Processor.scala 580:44 90:29]
  wire [7:0] _GEN_258 = tStateCount_value == 3'h4 ? _GEN_148 : aReg; // @[Processor.scala 663:52 81:21]
  wire [7:0] _GEN_259 = tStateCount_value == 3'h4 ? _GEN_149 : bReg; // @[Processor.scala 663:52 82:21]
  wire [7:0] _GEN_260 = tStateCount_value == 3'h4 ? _GEN_150 : cReg; // @[Processor.scala 663:52 83:21]
  wire [2:0] _GEN_261 = tStateCount_value == 3'h4 ? 3'h0 : tStateCount_value; // @[Processor.scala 663:52 Counter.scala 98:11 61:40]
  wire [2:0] _GEN_262 = tStateCount_value == 3'h4 ? 3'h1 : currentState; // @[Processor.scala 663:52 678:26 90:29]
  wire [2:0] _GEN_264 = _T_131 ? _value_T_1 : _GEN_261; // @[Processor.scala 659:52 Counter.scala 77:15]
  wire [7:0] _GEN_266 = _T_131 ? aReg : _GEN_258; // @[Processor.scala 659:52 81:21]
  wire [7:0] _GEN_267 = _T_131 ? bReg : _GEN_259; // @[Processor.scala 659:52 82:21]
  wire [7:0] _GEN_268 = _T_131 ? cReg : _GEN_260; // @[Processor.scala 659:52 83:21]
  wire [2:0] _GEN_269 = _T_131 ? currentState : _GEN_262; // @[Processor.scala 659:52 90:29]
  wire [2:0] _GEN_271 = _T_107 ? _value_T_1 : _GEN_264; // @[Processor.scala 654:52 Counter.scala 77:15]
  wire [7:0] _GEN_274 = _T_107 ? aReg : _GEN_266; // @[Processor.scala 654:52 81:21]
  wire [7:0] _GEN_275 = _T_107 ? bReg : _GEN_267; // @[Processor.scala 654:52 82:21]
  wire [7:0] _GEN_276 = _T_107 ? cReg : _GEN_268; // @[Processor.scala 654:52 83:21]
  wire [2:0] _GEN_277 = _T_107 ? currentState : _GEN_269; // @[Processor.scala 654:52 90:29]
  wire [2:0] _GEN_279 = _T_4 ? _value_T_1 : _GEN_271; // @[Processor.scala 650:52 Counter.scala 77:15]
  wire [7:0] _GEN_283 = _T_4 ? aReg : _GEN_274; // @[Processor.scala 650:52 81:21]
  wire [7:0] _GEN_284 = _T_4 ? bReg : _GEN_275; // @[Processor.scala 650:52 82:21]
  wire [7:0] _GEN_285 = _T_4 ? cReg : _GEN_276; // @[Processor.scala 650:52 83:21]
  wire [2:0] _GEN_286 = _T_4 ? currentState : _GEN_277; // @[Processor.scala 650:52 90:29]
  wire [2:0] _GEN_289 = _T_3 ? _value_T_1 : _GEN_279; // @[Processor.scala 635:44 Counter.scala 77:15]
  wire [7:0] _GEN_293 = _T_3 ? aReg : _GEN_283; // @[Processor.scala 635:44 81:21]
  wire [7:0] _GEN_294 = _T_3 ? bReg : _GEN_284; // @[Processor.scala 635:44 82:21]
  wire [7:0] _GEN_295 = _T_3 ? cReg : _GEN_285; // @[Processor.scala 635:44 83:21]
  wire [2:0] _GEN_296 = _T_3 ? currentState : _GEN_286; // @[Processor.scala 635:44 90:29]
  wire [7:0] _GEN_875 = zeroFlag ? bus : instructionPointerReg; // @[Processor.scala 1337:27 1339:35 80:38]
  wire [7:0] _GEN_877 = ~zeroFlag ? bus : instructionPointerReg; // @[Processor.scala 1346:28 1348:35 80:38]
  wire [7:0] _stackPointerReg_T_1 = stackPointerReg - 8'h1; // @[Processor.scala 1413:48]
  wire [7:0] _GEN_896 = _T_107 ? _stackPointerReg_T_1 : stackPointerReg; // @[Processor.scala 1411:51 1413:29 84:32]
  wire [7:0] _GEN_902 = _T_4 ? stackPointerReg : _GEN_896; // @[Processor.scala 1406:52 84:32]
  wire [7:0] _GEN_908 = _T_3 ? stackPointerReg : _GEN_902; // @[Processor.scala 1392:44 84:32]
  wire [7:0] _stackPointerReg_T_3 = stackPointerReg + 8'h1; // @[Processor.scala 1423:48]
  wire [7:0] _GEN_929 = _T_3 ? _stackPointerReg_T_3 : stackPointerReg; // @[Processor.scala 1421:44 1423:29 84:32]
  wire [7:0] _GEN_938 = _T_131 ? bus : instructionPointerReg; // @[Processor.scala 1467:51 1470:35 80:38]
  wire [7:0] _GEN_944 = _T_107 ? instructionPointerReg : _GEN_938; // @[Processor.scala 1463:51 80:38]
  wire [7:0] _GEN_951 = _T_4 ? instructionPointerReg : _GEN_944; // @[Processor.scala 1458:51 80:38]
  wire [7:0] _GEN_953 = _T_3 ? instructionPointerReg : mdr; // @[Processor.scala 1454:44 1456:17 85:20]
  wire [7:0] _GEN_959 = _T_3 ? instructionPointerReg : _GEN_951; // @[Processor.scala 1454:44 80:38]
  wire [7:0] _GEN_962 = _T_107 ? bus : instructionPointerReg; // @[Processor.scala 1486:51 1489:35 80:38]
  wire [7:0] _GEN_968 = _T_4 ? instructionPointerReg : _GEN_962; // @[Processor.scala 1482:51 80:38]
  wire [7:0] _GEN_974 = _T_3 ? instructionPointerReg : _GEN_968; // @[Processor.scala 1478:44 80:38]
  wire [2:0] _GEN_976 = 8'h15 == instruction_opcode ? 3'h6 : currentState; // @[Processor.scala 322:23 1497:24 90:29]
  wire [7:0] _GEN_977 = 8'h13 == instruction_opcode ? _GEN_929 : stackPointerReg; // @[Processor.scala 322:23 84:32]
  wire [2:0] _GEN_978 = 8'h13 == instruction_opcode ? _GEN_166 : tStateCount_value; // @[Processor.scala 322:23 Counter.scala 61:40]
  wire [7:0] _GEN_981 = 8'h13 == instruction_opcode ? _GEN_974 : instructionPointerReg; // @[Processor.scala 322:23 80:38]
  wire [2:0] _GEN_982 = 8'h13 == instruction_opcode ? _GEN_172 : _GEN_976; // @[Processor.scala 322:23]
  wire [7:0] _GEN_983 = 8'h10 == instruction_opcode ? _GEN_953 : mdr; // @[Processor.scala 322:23 85:20]
  wire [2:0] _GEN_984 = 8'h10 == instruction_opcode ? _GEN_240 : _GEN_978; // @[Processor.scala 322:23]
  wire [7:0] _GEN_987 = 8'h10 == instruction_opcode ? _GEN_908 : _GEN_977; // @[Processor.scala 322:23]
  wire [7:0] _GEN_989 = 8'h10 == instruction_opcode ? _GEN_959 : _GEN_981; // @[Processor.scala 322:23]
  wire [2:0] _GEN_990 = 8'h10 == instruction_opcode ? _GEN_247 : _GEN_982; // @[Processor.scala 322:23]
  wire [2:0] _GEN_992 = 8'h14 == instruction_opcode ? 3'h1 : _GEN_990; // @[Processor.scala 322:23 1449:24]
  wire [7:0] _GEN_993 = 8'h14 == instruction_opcode ? mdr : _GEN_983; // @[Processor.scala 322:23 85:20]
  wire [2:0] _GEN_994 = 8'h14 == instruction_opcode ? tStateCount_value : _GEN_984; // @[Processor.scala 322:23 Counter.scala 61:40]
  wire  _GEN_996 = 8'h14 == instruction_opcode ? 1'h0 : 8'h10 == instruction_opcode & _GEN_73; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_997 = 8'h14 == instruction_opcode ? stackPointerReg : _GEN_987; // @[Processor.scala 322:23 84:32]
  wire [7:0] _GEN_999 = 8'h14 == instruction_opcode ? instructionPointerReg : _GEN_989; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1001 = 8'h12 == instruction_opcode ? _GEN_929 : _GEN_997; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1002 = 8'h12 == instruction_opcode ? _GEN_166 : _GEN_994; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1005 = 8'h12 == instruction_opcode ? _GEN_168 : aReg; // @[Processor.scala 322:23 81:21]
  wire [7:0] _GEN_1006 = 8'h12 == instruction_opcode ? _GEN_169 : bReg; // @[Processor.scala 322:23 82:21]
  wire [7:0] _GEN_1007 = 8'h12 == instruction_opcode ? _GEN_170 : cReg; // @[Processor.scala 322:23 83:21]
  wire [2:0] _GEN_1008 = 8'h12 == instruction_opcode ? _GEN_172 : _GEN_992; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1009 = 8'h12 == instruction_opcode ? mdr : _GEN_993; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1010 = 8'h12 == instruction_opcode ? 1'h0 : _GEN_996; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1012 = 8'h12 == instruction_opcode ? instructionPointerReg : _GEN_999; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1013 = 8'h11 == instruction_opcode ? _GEN_71 : _GEN_1009; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1014 = 8'h11 == instruction_opcode ? _GEN_166 : _GEN_1002; // @[Processor.scala 322:23]
  wire  _GEN_1016 = 8'h11 == instruction_opcode ? _GEN_73 : _GEN_1010; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1017 = 8'h11 == instruction_opcode ? _GEN_908 : _GEN_1001; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1018 = 8'h11 == instruction_opcode ? _GEN_172 : _GEN_1008; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1020 = 8'h11 == instruction_opcode ? aReg : _GEN_1005; // @[Processor.scala 322:23 81:21]
  wire [7:0] _GEN_1021 = 8'h11 == instruction_opcode ? bReg : _GEN_1006; // @[Processor.scala 322:23 82:21]
  wire [7:0] _GEN_1022 = 8'h11 == instruction_opcode ? cReg : _GEN_1007; // @[Processor.scala 322:23 83:21]
  wire [7:0] _GEN_1024 = 8'h11 == instruction_opcode ? instructionPointerReg : _GEN_1012; // @[Processor.scala 322:23 80:38]
  wire [2:0] _GEN_1027 = 8'hf == instruction_opcode ? _GEN_5 : _GEN_1014; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1029 = 8'hf == instruction_opcode ? _GEN_8 : _GEN_1018; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1030 = 8'hf == instruction_opcode ? mdr : _GEN_1013; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1031 = 8'hf == instruction_opcode ? 1'h0 : _GEN_1016; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1032 = 8'hf == instruction_opcode ? stackPointerReg : _GEN_1017; // @[Processor.scala 322:23 84:32]
  wire [7:0] _GEN_1034 = 8'hf == instruction_opcode ? aReg : _GEN_1020; // @[Processor.scala 322:23 81:21]
  wire [7:0] _GEN_1035 = 8'hf == instruction_opcode ? bReg : _GEN_1021; // @[Processor.scala 322:23 82:21]
  wire [7:0] _GEN_1036 = 8'hf == instruction_opcode ? cReg : _GEN_1022; // @[Processor.scala 322:23 83:21]
  wire [7:0] _GEN_1038 = 8'hf == instruction_opcode ? instructionPointerReg : _GEN_1024; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1040 = 8'he == instruction_opcode ? _GEN_877 : _GEN_1038; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1041 = 8'he == instruction_opcode ? 3'h1 : _GEN_1029; // @[Processor.scala 322:23 1350:24]
  wire  _GEN_1043 = 8'he == instruction_opcode ? 1'h0 : 8'hf == instruction_opcode & _T_3; // @[Processor.scala 131:11 322:23]
  wire [2:0] _GEN_1044 = 8'he == instruction_opcode ? tStateCount_value : _GEN_1027; // @[Processor.scala 322:23 Counter.scala 61:40]
  wire  _GEN_1045 = 8'he == instruction_opcode ? 1'h0 : 8'hf == instruction_opcode & _GEN_73; // @[Processor.scala 132:11 322:23]
  wire [7:0] _GEN_1046 = 8'he == instruction_opcode ? mdr : _GEN_1030; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1047 = 8'he == instruction_opcode ? 1'h0 : _GEN_1031; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1048 = 8'he == instruction_opcode ? stackPointerReg : _GEN_1032; // @[Processor.scala 322:23 84:32]
  wire [7:0] _GEN_1050 = 8'he == instruction_opcode ? aReg : _GEN_1034; // @[Processor.scala 322:23 81:21]
  wire [7:0] _GEN_1051 = 8'he == instruction_opcode ? bReg : _GEN_1035; // @[Processor.scala 322:23 82:21]
  wire [7:0] _GEN_1052 = 8'he == instruction_opcode ? cReg : _GEN_1036; // @[Processor.scala 322:23 83:21]
  wire [7:0] _GEN_1054 = 8'hd == instruction_opcode ? _GEN_875 : _GEN_1040; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1055 = 8'hd == instruction_opcode ? 3'h1 : _GEN_1041; // @[Processor.scala 322:23 1341:24]
  wire  _GEN_1057 = 8'hd == instruction_opcode ? 1'h0 : _GEN_1043; // @[Processor.scala 131:11 322:23]
  wire [2:0] _GEN_1058 = 8'hd == instruction_opcode ? tStateCount_value : _GEN_1044; // @[Processor.scala 322:23 Counter.scala 61:40]
  wire  _GEN_1059 = 8'hd == instruction_opcode ? 1'h0 : _GEN_1045; // @[Processor.scala 132:11 322:23]
  wire [7:0] _GEN_1060 = 8'hd == instruction_opcode ? mdr : _GEN_1046; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1061 = 8'hd == instruction_opcode ? 1'h0 : _GEN_1047; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1062 = 8'hd == instruction_opcode ? stackPointerReg : _GEN_1048; // @[Processor.scala 322:23 84:32]
  wire [7:0] _GEN_1064 = 8'hd == instruction_opcode ? aReg : _GEN_1050; // @[Processor.scala 322:23 81:21]
  wire [7:0] _GEN_1065 = 8'hd == instruction_opcode ? bReg : _GEN_1051; // @[Processor.scala 322:23 82:21]
  wire [7:0] _GEN_1066 = 8'hd == instruction_opcode ? cReg : _GEN_1052; // @[Processor.scala 322:23 83:21]
  wire [7:0] _GEN_1068 = 8'hc == instruction_opcode ? bus : _GEN_1054; // @[Processor.scala 322:23 1331:33]
  wire [2:0] _GEN_1069 = 8'hc == instruction_opcode ? 3'h1 : _GEN_1055; // @[Processor.scala 322:23 1332:24]
  wire  _GEN_1071 = 8'hc == instruction_opcode ? 1'h0 : _GEN_1057; // @[Processor.scala 131:11 322:23]
  wire [2:0] _GEN_1072 = 8'hc == instruction_opcode ? tStateCount_value : _GEN_1058; // @[Processor.scala 322:23 Counter.scala 61:40]
  wire  _GEN_1073 = 8'hc == instruction_opcode ? 1'h0 : _GEN_1059; // @[Processor.scala 132:11 322:23]
  wire [7:0] _GEN_1074 = 8'hc == instruction_opcode ? mdr : _GEN_1060; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1075 = 8'hc == instruction_opcode ? 1'h0 : _GEN_1061; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1076 = 8'hc == instruction_opcode ? stackPointerReg : _GEN_1062; // @[Processor.scala 322:23 84:32]
  wire [7:0] _GEN_1078 = 8'hc == instruction_opcode ? aReg : _GEN_1064; // @[Processor.scala 322:23 81:21]
  wire [7:0] _GEN_1079 = 8'hc == instruction_opcode ? bReg : _GEN_1065; // @[Processor.scala 322:23 82:21]
  wire [7:0] _GEN_1080 = 8'hc == instruction_opcode ? cReg : _GEN_1066; // @[Processor.scala 322:23 83:21]
  wire  _GEN_1082 = 8'h20 == instruction_opcode ? _T_3 : _GEN_1071; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1083 = 8'h20 == instruction_opcode ? _GEN_240 : _GEN_1072; // @[Processor.scala 322:23]
  wire  _GEN_1084 = 8'h20 == instruction_opcode ? _GEN_73 : _GEN_1073; // @[Processor.scala 322:23]
  wire  _GEN_1085 = 8'h20 == instruction_opcode & _GEN_171; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1087 = 8'h20 == instruction_opcode ? _GEN_244 : _GEN_1078; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1088 = 8'h20 == instruction_opcode ? _GEN_245 : _GEN_1079; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1089 = 8'h20 == instruction_opcode ? _GEN_246 : _GEN_1080; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1090 = 8'h20 == instruction_opcode ? _GEN_247 : _GEN_1069; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1092 = 8'h20 == instruction_opcode ? instructionPointerReg : _GEN_1068; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1093 = 8'h20 == instruction_opcode ? mdr : _GEN_1074; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1094 = 8'h20 == instruction_opcode ? 1'h0 : _GEN_1075; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1095 = 8'h20 == instruction_opcode ? stackPointerReg : _GEN_1076; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1098 = 8'h1b == instruction_opcode ? _T_3 : _GEN_1082; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1099 = 8'h1b == instruction_opcode ? _GEN_289 : _GEN_1083; // @[Processor.scala 322:23]
  wire  _GEN_1101 = 8'h1b == instruction_opcode ? _GEN_171 : _GEN_1084; // @[Processor.scala 322:23]
  wire  _GEN_1102 = 8'h1b == instruction_opcode ? _GEN_243 : _GEN_1085; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1104 = 8'h1b == instruction_opcode ? _GEN_293 : _GEN_1087; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1105 = 8'h1b == instruction_opcode ? _GEN_294 : _GEN_1088; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1106 = 8'h1b == instruction_opcode ? _GEN_295 : _GEN_1089; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1107 = 8'h1b == instruction_opcode ? _GEN_296 : _GEN_1090; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1109 = 8'h1b == instruction_opcode ? instructionPointerReg : _GEN_1092; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1110 = 8'h1b == instruction_opcode ? mdr : _GEN_1093; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1111 = 8'h1b == instruction_opcode ? 1'h0 : _GEN_1094; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1112 = 8'h1b == instruction_opcode ? stackPointerReg : _GEN_1095; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1114 = 8'h18 == instruction_opcode ? _T_3 : _GEN_1098; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1115 = 8'h18 == instruction_opcode ? _GEN_240 : _GEN_1099; // @[Processor.scala 322:23]
  wire  _GEN_1116 = 8'h18 == instruction_opcode ? _GEN_73 : _GEN_1101; // @[Processor.scala 322:23]
  wire  _GEN_1117 = 8'h18 == instruction_opcode ? _GEN_171 : _GEN_1102; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1119 = 8'h18 == instruction_opcode ? _GEN_244 : _GEN_1104; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1120 = 8'h18 == instruction_opcode ? _GEN_245 : _GEN_1105; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1121 = 8'h18 == instruction_opcode ? _GEN_246 : _GEN_1106; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1122 = 8'h18 == instruction_opcode ? _GEN_247 : _GEN_1107; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1125 = 8'h18 == instruction_opcode ? instructionPointerReg : _GEN_1109; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1126 = 8'h18 == instruction_opcode ? mdr : _GEN_1110; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1127 = 8'h18 == instruction_opcode ? 1'h0 : _GEN_1111; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1128 = 8'h18 == instruction_opcode ? stackPointerReg : _GEN_1112; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1130 = 8'h1f == instruction_opcode ? _T_3 : _GEN_1114; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1131 = 8'h1f == instruction_opcode ? _GEN_240 : _GEN_1115; // @[Processor.scala 322:23]
  wire  _GEN_1132 = 8'h1f == instruction_opcode ? _GEN_73 : _GEN_1116; // @[Processor.scala 322:23]
  wire  _GEN_1133 = 8'h1f == instruction_opcode & _GEN_171; // @[Processor.scala 136:10 322:23]
  wire [7:0] _GEN_1135 = 8'h1f == instruction_opcode ? _GEN_244 : _GEN_1119; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1136 = 8'h1f == instruction_opcode ? _GEN_245 : _GEN_1120; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1137 = 8'h1f == instruction_opcode ? _GEN_246 : _GEN_1121; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1138 = 8'h1f == instruction_opcode ? _GEN_247 : _GEN_1122; // @[Processor.scala 322:23]
  wire  _GEN_1139 = 8'h1f == instruction_opcode ? 1'h0 : _GEN_1117; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1142 = 8'h1f == instruction_opcode ? instructionPointerReg : _GEN_1125; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1143 = 8'h1f == instruction_opcode ? mdr : _GEN_1126; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1144 = 8'h1f == instruction_opcode ? 1'h0 : _GEN_1127; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1145 = 8'h1f == instruction_opcode ? stackPointerReg : _GEN_1128; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1147 = 8'h1a == instruction_opcode ? _T_3 : _GEN_1130; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1148 = 8'h1a == instruction_opcode ? _GEN_289 : _GEN_1131; // @[Processor.scala 322:23]
  wire  _GEN_1150 = 8'h1a == instruction_opcode ? _GEN_171 : _GEN_1132; // @[Processor.scala 322:23]
  wire  _GEN_1151 = 8'h1a == instruction_opcode ? _GEN_243 : _GEN_1133; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1153 = 8'h1a == instruction_opcode ? _GEN_293 : _GEN_1135; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1154 = 8'h1a == instruction_opcode ? _GEN_294 : _GEN_1136; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1155 = 8'h1a == instruction_opcode ? _GEN_295 : _GEN_1137; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1156 = 8'h1a == instruction_opcode ? _GEN_296 : _GEN_1138; // @[Processor.scala 322:23]
  wire  _GEN_1157 = 8'h1a == instruction_opcode ? 1'h0 : _GEN_1139; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1159 = 8'h1a == instruction_opcode ? instructionPointerReg : _GEN_1142; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1160 = 8'h1a == instruction_opcode ? mdr : _GEN_1143; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1161 = 8'h1a == instruction_opcode ? 1'h0 : _GEN_1144; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1162 = 8'h1a == instruction_opcode ? stackPointerReg : _GEN_1145; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1164 = 8'h17 == instruction_opcode ? _T_3 : _GEN_1147; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1165 = 8'h17 == instruction_opcode ? _GEN_240 : _GEN_1148; // @[Processor.scala 322:23]
  wire  _GEN_1166 = 8'h17 == instruction_opcode ? _GEN_73 : _GEN_1150; // @[Processor.scala 322:23]
  wire  _GEN_1167 = 8'h17 == instruction_opcode ? _GEN_171 : _GEN_1151; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1169 = 8'h17 == instruction_opcode ? _GEN_244 : _GEN_1153; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1170 = 8'h17 == instruction_opcode ? _GEN_245 : _GEN_1154; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1171 = 8'h17 == instruction_opcode ? _GEN_246 : _GEN_1155; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1172 = 8'h17 == instruction_opcode ? _GEN_247 : _GEN_1156; // @[Processor.scala 322:23]
  wire  _GEN_1174 = 8'h17 == instruction_opcode ? 1'h0 : _GEN_1157; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1176 = 8'h17 == instruction_opcode ? instructionPointerReg : _GEN_1159; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1177 = 8'h17 == instruction_opcode ? mdr : _GEN_1160; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1178 = 8'h17 == instruction_opcode ? 1'h0 : _GEN_1161; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1179 = 8'h17 == instruction_opcode ? stackPointerReg : _GEN_1162; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1181 = 8'h1e == instruction_opcode ? _T_3 : _GEN_1164; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1182 = 8'h1e == instruction_opcode ? _GEN_240 : _GEN_1165; // @[Processor.scala 322:23]
  wire  _GEN_1183 = 8'h1e == instruction_opcode ? _GEN_73 : _GEN_1166; // @[Processor.scala 322:23]
  wire  _GEN_1184 = 8'h1e == instruction_opcode & _GEN_171; // @[Processor.scala 135:10 322:23]
  wire [7:0] _GEN_1186 = 8'h1e == instruction_opcode ? _GEN_244 : _GEN_1169; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1187 = 8'h1e == instruction_opcode ? _GEN_245 : _GEN_1170; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1188 = 8'h1e == instruction_opcode ? _GEN_246 : _GEN_1171; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1189 = 8'h1e == instruction_opcode ? _GEN_247 : _GEN_1172; // @[Processor.scala 322:23]
  wire  _GEN_1190 = 8'h1e == instruction_opcode ? 1'h0 : _GEN_1167; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1192 = 8'h1e == instruction_opcode ? 1'h0 : _GEN_1174; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1194 = 8'h1e == instruction_opcode ? instructionPointerReg : _GEN_1176; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1195 = 8'h1e == instruction_opcode ? mdr : _GEN_1177; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1196 = 8'h1e == instruction_opcode ? 1'h0 : _GEN_1178; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1197 = 8'h1e == instruction_opcode ? stackPointerReg : _GEN_1179; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1199 = 8'h19 == instruction_opcode ? _T_3 : _GEN_1181; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1200 = 8'h19 == instruction_opcode ? _GEN_289 : _GEN_1182; // @[Processor.scala 322:23]
  wire  _GEN_1202 = 8'h19 == instruction_opcode ? _GEN_171 : _GEN_1183; // @[Processor.scala 322:23]
  wire  _GEN_1203 = 8'h19 == instruction_opcode ? _GEN_243 : _GEN_1184; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1205 = 8'h19 == instruction_opcode ? _GEN_293 : _GEN_1186; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1206 = 8'h19 == instruction_opcode ? _GEN_294 : _GEN_1187; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1207 = 8'h19 == instruction_opcode ? _GEN_295 : _GEN_1188; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1208 = 8'h19 == instruction_opcode ? _GEN_296 : _GEN_1189; // @[Processor.scala 322:23]
  wire  _GEN_1209 = 8'h19 == instruction_opcode ? 1'h0 : _GEN_1190; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1210 = 8'h19 == instruction_opcode ? 1'h0 : _GEN_1192; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1212 = 8'h19 == instruction_opcode ? instructionPointerReg : _GEN_1194; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1213 = 8'h19 == instruction_opcode ? mdr : _GEN_1195; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1214 = 8'h19 == instruction_opcode ? 1'h0 : _GEN_1196; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1215 = 8'h19 == instruction_opcode ? stackPointerReg : _GEN_1197; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1217 = 8'h16 == instruction_opcode ? _T_3 : _GEN_1199; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1218 = 8'h16 == instruction_opcode ? _GEN_240 : _GEN_1200; // @[Processor.scala 322:23]
  wire  _GEN_1219 = 8'h16 == instruction_opcode ? _GEN_73 : _GEN_1202; // @[Processor.scala 322:23]
  wire  _GEN_1220 = 8'h16 == instruction_opcode ? _GEN_171 : _GEN_1203; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1222 = 8'h16 == instruction_opcode ? _GEN_244 : _GEN_1205; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1223 = 8'h16 == instruction_opcode ? _GEN_245 : _GEN_1206; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1224 = 8'h16 == instruction_opcode ? _GEN_246 : _GEN_1207; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1225 = 8'h16 == instruction_opcode ? _GEN_247 : _GEN_1208; // @[Processor.scala 322:23]
  wire  _GEN_1227 = 8'h16 == instruction_opcode ? 1'h0 : _GEN_1209; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1228 = 8'h16 == instruction_opcode ? 1'h0 : _GEN_1210; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1230 = 8'h16 == instruction_opcode ? instructionPointerReg : _GEN_1212; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1231 = 8'h16 == instruction_opcode ? mdr : _GEN_1213; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1232 = 8'h16 == instruction_opcode ? 1'h0 : _GEN_1214; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1233 = 8'h16 == instruction_opcode ? stackPointerReg : _GEN_1215; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1235 = 8'h1d == instruction_opcode ? _T_3 : _GEN_1217; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1236 = 8'h1d == instruction_opcode ? _GEN_240 : _GEN_1218; // @[Processor.scala 322:23]
  wire  _GEN_1237 = 8'h1d == instruction_opcode ? _GEN_73 : _GEN_1219; // @[Processor.scala 322:23]
  wire  _GEN_1238 = 8'h1d == instruction_opcode & _GEN_171; // @[Processor.scala 134:10 322:23]
  wire [7:0] _GEN_1240 = 8'h1d == instruction_opcode ? _GEN_244 : _GEN_1222; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1241 = 8'h1d == instruction_opcode ? _GEN_245 : _GEN_1223; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1242 = 8'h1d == instruction_opcode ? _GEN_246 : _GEN_1224; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1243 = 8'h1d == instruction_opcode ? _GEN_247 : _GEN_1225; // @[Processor.scala 322:23]
  wire  _GEN_1244 = 8'h1d == instruction_opcode ? 1'h0 : _GEN_1220; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1246 = 8'h1d == instruction_opcode ? 1'h0 : _GEN_1227; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1247 = 8'h1d == instruction_opcode ? 1'h0 : _GEN_1228; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1249 = 8'h1d == instruction_opcode ? instructionPointerReg : _GEN_1230; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1250 = 8'h1d == instruction_opcode ? mdr : _GEN_1231; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1251 = 8'h1d == instruction_opcode ? 1'h0 : _GEN_1232; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1252 = 8'h1d == instruction_opcode ? stackPointerReg : _GEN_1233; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1254 = 8'hb == instruction_opcode ? _T_3 : _GEN_1235; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1255 = 8'hb == instruction_opcode ? _GEN_289 : _GEN_1236; // @[Processor.scala 322:23]
  wire  _GEN_1257 = 8'hb == instruction_opcode ? _GEN_171 : _GEN_1237; // @[Processor.scala 322:23]
  wire  _GEN_1258 = 8'hb == instruction_opcode ? _GEN_243 : _GEN_1238; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1260 = 8'hb == instruction_opcode ? _GEN_293 : _GEN_1240; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1261 = 8'hb == instruction_opcode ? _GEN_294 : _GEN_1241; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1262 = 8'hb == instruction_opcode ? _GEN_295 : _GEN_1242; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1263 = 8'hb == instruction_opcode ? _GEN_296 : _GEN_1243; // @[Processor.scala 322:23]
  wire  _GEN_1264 = 8'hb == instruction_opcode ? 1'h0 : _GEN_1244; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1265 = 8'hb == instruction_opcode ? 1'h0 : _GEN_1246; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1266 = 8'hb == instruction_opcode ? 1'h0 : _GEN_1247; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1268 = 8'hb == instruction_opcode ? instructionPointerReg : _GEN_1249; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1269 = 8'hb == instruction_opcode ? mdr : _GEN_1250; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1270 = 8'hb == instruction_opcode ? 1'h0 : _GEN_1251; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1271 = 8'hb == instruction_opcode ? stackPointerReg : _GEN_1252; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1273 = 8'ha == instruction_opcode ? _T_3 : _GEN_1254; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1274 = 8'ha == instruction_opcode ? _GEN_240 : _GEN_1255; // @[Processor.scala 322:23]
  wire  _GEN_1275 = 8'ha == instruction_opcode ? _GEN_73 : _GEN_1257; // @[Processor.scala 322:23]
  wire  _GEN_1276 = 8'ha == instruction_opcode ? _GEN_171 : _GEN_1258; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1278 = 8'ha == instruction_opcode ? _GEN_244 : _GEN_1260; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1279 = 8'ha == instruction_opcode ? _GEN_245 : _GEN_1261; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1280 = 8'ha == instruction_opcode ? _GEN_246 : _GEN_1262; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1281 = 8'ha == instruction_opcode ? _GEN_247 : _GEN_1263; // @[Processor.scala 322:23]
  wire  _GEN_1283 = 8'ha == instruction_opcode ? 1'h0 : _GEN_1264; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1284 = 8'ha == instruction_opcode ? 1'h0 : _GEN_1265; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1285 = 8'ha == instruction_opcode ? 1'h0 : _GEN_1266; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1287 = 8'ha == instruction_opcode ? instructionPointerReg : _GEN_1268; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1288 = 8'ha == instruction_opcode ? mdr : _GEN_1269; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1289 = 8'ha == instruction_opcode ? 1'h0 : _GEN_1270; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1290 = 8'ha == instruction_opcode ? stackPointerReg : _GEN_1271; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1292 = 8'h1c == instruction_opcode ? _T_3 : _GEN_1273; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1293 = 8'h1c == instruction_opcode ? _GEN_240 : _GEN_1274; // @[Processor.scala 322:23]
  wire  _GEN_1294 = 8'h1c == instruction_opcode ? _GEN_73 : _GEN_1275; // @[Processor.scala 322:23]
  wire  _GEN_1295 = 8'h1c == instruction_opcode & _GEN_171; // @[Processor.scala 133:10 322:23]
  wire [7:0] _GEN_1297 = 8'h1c == instruction_opcode ? _GEN_244 : _GEN_1278; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1298 = 8'h1c == instruction_opcode ? _GEN_245 : _GEN_1279; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1299 = 8'h1c == instruction_opcode ? _GEN_246 : _GEN_1280; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1300 = 8'h1c == instruction_opcode ? _GEN_247 : _GEN_1281; // @[Processor.scala 322:23]
  wire  _GEN_1301 = 8'h1c == instruction_opcode ? 1'h0 : _GEN_1276; // @[Processor.scala 134:10 322:23]
  wire  _GEN_1303 = 8'h1c == instruction_opcode ? 1'h0 : _GEN_1283; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1304 = 8'h1c == instruction_opcode ? 1'h0 : _GEN_1284; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1305 = 8'h1c == instruction_opcode ? 1'h0 : _GEN_1285; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1307 = 8'h1c == instruction_opcode ? instructionPointerReg : _GEN_1287; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1308 = 8'h1c == instruction_opcode ? mdr : _GEN_1288; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1309 = 8'h1c == instruction_opcode ? 1'h0 : _GEN_1289; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1310 = 8'h1c == instruction_opcode ? stackPointerReg : _GEN_1290; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1312 = 8'h9 == instruction_opcode ? _T_3 : _GEN_1292; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1313 = 8'h9 == instruction_opcode ? _GEN_289 : _GEN_1293; // @[Processor.scala 322:23]
  wire  _GEN_1315 = 8'h9 == instruction_opcode ? _GEN_171 : _GEN_1294; // @[Processor.scala 322:23]
  wire  _GEN_1316 = 8'h9 == instruction_opcode ? _GEN_243 : _GEN_1295; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1318 = 8'h9 == instruction_opcode ? _GEN_293 : _GEN_1297; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1319 = 8'h9 == instruction_opcode ? _GEN_294 : _GEN_1298; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1320 = 8'h9 == instruction_opcode ? _GEN_295 : _GEN_1299; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1321 = 8'h9 == instruction_opcode ? _GEN_296 : _GEN_1300; // @[Processor.scala 322:23]
  wire  _GEN_1322 = 8'h9 == instruction_opcode ? 1'h0 : _GEN_1301; // @[Processor.scala 134:10 322:23]
  wire  _GEN_1323 = 8'h9 == instruction_opcode ? 1'h0 : _GEN_1303; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1324 = 8'h9 == instruction_opcode ? 1'h0 : _GEN_1304; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1325 = 8'h9 == instruction_opcode ? 1'h0 : _GEN_1305; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1327 = 8'h9 == instruction_opcode ? instructionPointerReg : _GEN_1307; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1328 = 8'h9 == instruction_opcode ? mdr : _GEN_1308; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1329 = 8'h9 == instruction_opcode ? 1'h0 : _GEN_1309; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1330 = 8'h9 == instruction_opcode ? stackPointerReg : _GEN_1310; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1332 = 8'h8 == instruction_opcode ? _T_3 : _GEN_1312; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1333 = 8'h8 == instruction_opcode ? _GEN_240 : _GEN_1313; // @[Processor.scala 322:23]
  wire  _GEN_1334 = 8'h8 == instruction_opcode ? _GEN_73 : _GEN_1315; // @[Processor.scala 322:23]
  wire  _GEN_1335 = 8'h8 == instruction_opcode ? _GEN_171 : _GEN_1316; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1337 = 8'h8 == instruction_opcode ? _GEN_244 : _GEN_1318; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1338 = 8'h8 == instruction_opcode ? _GEN_245 : _GEN_1319; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1339 = 8'h8 == instruction_opcode ? _GEN_246 : _GEN_1320; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1340 = 8'h8 == instruction_opcode ? _GEN_247 : _GEN_1321; // @[Processor.scala 322:23]
  wire  _GEN_1342 = 8'h8 == instruction_opcode ? 1'h0 : _GEN_1322; // @[Processor.scala 134:10 322:23]
  wire  _GEN_1343 = 8'h8 == instruction_opcode ? 1'h0 : _GEN_1323; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1344 = 8'h8 == instruction_opcode ? 1'h0 : _GEN_1324; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1345 = 8'h8 == instruction_opcode ? 1'h0 : _GEN_1325; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1347 = 8'h8 == instruction_opcode ? instructionPointerReg : _GEN_1327; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1348 = 8'h8 == instruction_opcode ? mdr : _GEN_1328; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1349 = 8'h8 == instruction_opcode ? 1'h0 : _GEN_1329; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1350 = 8'h8 == instruction_opcode ? stackPointerReg : _GEN_1330; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1352 = 8'h7 == instruction_opcode ? _T_3 : _GEN_1332; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1353 = 8'h7 == instruction_opcode ? _GEN_166 : _GEN_1333; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1355 = 8'h7 == instruction_opcode ? _GEN_168 : _GEN_1337; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1356 = 8'h7 == instruction_opcode ? _GEN_169 : _GEN_1338; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1357 = 8'h7 == instruction_opcode ? _GEN_170 : _GEN_1339; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1359 = 8'h7 == instruction_opcode ? _GEN_172 : _GEN_1340; // @[Processor.scala 322:23]
  wire  _GEN_1360 = 8'h7 == instruction_opcode ? 1'h0 : _GEN_1334; // @[Processor.scala 132:11 322:23]
  wire  _GEN_1361 = 8'h7 == instruction_opcode ? 1'h0 : _GEN_1335; // @[Processor.scala 133:10 322:23]
  wire  _GEN_1363 = 8'h7 == instruction_opcode ? 1'h0 : _GEN_1342; // @[Processor.scala 134:10 322:23]
  wire  _GEN_1364 = 8'h7 == instruction_opcode ? 1'h0 : _GEN_1343; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1365 = 8'h7 == instruction_opcode ? 1'h0 : _GEN_1344; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1366 = 8'h7 == instruction_opcode ? 1'h0 : _GEN_1345; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1368 = 8'h7 == instruction_opcode ? instructionPointerReg : _GEN_1347; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1369 = 8'h7 == instruction_opcode ? mdr : _GEN_1348; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1370 = 8'h7 == instruction_opcode ? 1'h0 : _GEN_1349; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1371 = 8'h7 == instruction_opcode ? stackPointerReg : _GEN_1350; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1373 = 8'h6 == instruction_opcode ? _T_3 : _GEN_1352; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1374 = 8'h6 == instruction_opcode ? _GEN_166 : _GEN_1353; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1376 = 8'h6 == instruction_opcode ? _GEN_168 : _GEN_1355; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1377 = 8'h6 == instruction_opcode ? _GEN_169 : _GEN_1356; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1378 = 8'h6 == instruction_opcode ? _GEN_170 : _GEN_1357; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1380 = 8'h6 == instruction_opcode ? _GEN_172 : _GEN_1359; // @[Processor.scala 322:23]
  wire  _GEN_1381 = 8'h6 == instruction_opcode ? 1'h0 : 8'h7 == instruction_opcode & _GEN_73; // @[Processor.scala 139:10 322:23]
  wire  _GEN_1382 = 8'h6 == instruction_opcode ? 1'h0 : _GEN_1360; // @[Processor.scala 132:11 322:23]
  wire  _GEN_1383 = 8'h6 == instruction_opcode ? 1'h0 : _GEN_1361; // @[Processor.scala 133:10 322:23]
  wire  _GEN_1385 = 8'h6 == instruction_opcode ? 1'h0 : _GEN_1363; // @[Processor.scala 134:10 322:23]
  wire  _GEN_1386 = 8'h6 == instruction_opcode ? 1'h0 : _GEN_1364; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1387 = 8'h6 == instruction_opcode ? 1'h0 : _GEN_1365; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1388 = 8'h6 == instruction_opcode ? 1'h0 : _GEN_1366; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1390 = 8'h6 == instruction_opcode ? instructionPointerReg : _GEN_1368; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1391 = 8'h6 == instruction_opcode ? mdr : _GEN_1369; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1392 = 8'h6 == instruction_opcode ? 1'h0 : _GEN_1370; // @[Processor.scala 129:11 322:23]
  wire [7:0] _GEN_1393 = 8'h6 == instruction_opcode ? stackPointerReg : _GEN_1371; // @[Processor.scala 322:23 84:32]
  wire [7:0] _GEN_1394 = 8'h5 == instruction_opcode ? _GEN_71 : _GEN_1391; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1395 = 8'h5 == instruction_opcode ? _GEN_5 : _GEN_1374; // @[Processor.scala 322:23]
  wire  _GEN_1397 = 8'h5 == instruction_opcode ? _GEN_73 : _GEN_1392; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1398 = 8'h5 == instruction_opcode ? _GEN_8 : _GEN_1380; // @[Processor.scala 322:23]
  wire  _GEN_1399 = 8'h5 == instruction_opcode ? 1'h0 : _GEN_1373; // @[Processor.scala 131:11 322:23]
  wire  _GEN_1400 = 8'h5 == instruction_opcode ? 1'h0 : 8'h6 == instruction_opcode & _GEN_73; // @[Processor.scala 138:10 322:23]
  wire [7:0] _GEN_1401 = 8'h5 == instruction_opcode ? aReg : _GEN_1376; // @[Processor.scala 322:23 81:21]
  wire [7:0] _GEN_1402 = 8'h5 == instruction_opcode ? bReg : _GEN_1377; // @[Processor.scala 322:23 82:21]
  wire [7:0] _GEN_1403 = 8'h5 == instruction_opcode ? cReg : _GEN_1378; // @[Processor.scala 322:23 83:21]
  wire  _GEN_1405 = 8'h5 == instruction_opcode ? 1'h0 : _GEN_1381; // @[Processor.scala 139:10 322:23]
  wire  _GEN_1406 = 8'h5 == instruction_opcode ? 1'h0 : _GEN_1382; // @[Processor.scala 132:11 322:23]
  wire  _GEN_1407 = 8'h5 == instruction_opcode ? 1'h0 : _GEN_1383; // @[Processor.scala 133:10 322:23]
  wire  _GEN_1409 = 8'h5 == instruction_opcode ? 1'h0 : _GEN_1385; // @[Processor.scala 134:10 322:23]
  wire  _GEN_1410 = 8'h5 == instruction_opcode ? 1'h0 : _GEN_1386; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1411 = 8'h5 == instruction_opcode ? 1'h0 : _GEN_1387; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1412 = 8'h5 == instruction_opcode ? 1'h0 : _GEN_1388; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1414 = 8'h5 == instruction_opcode ? instructionPointerReg : _GEN_1390; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1415 = 8'h5 == instruction_opcode ? stackPointerReg : _GEN_1393; // @[Processor.scala 322:23 84:32]
  wire [2:0] _GEN_1417 = 8'h4 == instruction_opcode ? _GEN_5 : _GEN_1395; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1419 = 8'h4 == instruction_opcode ? _GEN_90 : _GEN_1401; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1420 = 8'h4 == instruction_opcode ? _GEN_91 : _GEN_1402; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1421 = 8'h4 == instruction_opcode ? _GEN_92 : _GEN_1403; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1422 = 8'h4 == instruction_opcode ? _GEN_8 : _GEN_1398; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1423 = 8'h4 == instruction_opcode ? mdr : _GEN_1394; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1424 = 8'h4 == instruction_opcode ? 1'h0 : _GEN_1397; // @[Processor.scala 129:11 322:23]
  wire  _GEN_1425 = 8'h4 == instruction_opcode ? 1'h0 : _GEN_1399; // @[Processor.scala 131:11 322:23]
  wire  _GEN_1426 = 8'h4 == instruction_opcode ? 1'h0 : _GEN_1400; // @[Processor.scala 138:10 322:23]
  wire  _GEN_1428 = 8'h4 == instruction_opcode ? 1'h0 : _GEN_1405; // @[Processor.scala 139:10 322:23]
  wire  _GEN_1429 = 8'h4 == instruction_opcode ? 1'h0 : _GEN_1406; // @[Processor.scala 132:11 322:23]
  wire  _GEN_1430 = 8'h4 == instruction_opcode ? 1'h0 : _GEN_1407; // @[Processor.scala 133:10 322:23]
  wire  _GEN_1431 = 8'h4 == instruction_opcode ? 1'h0 : _GEN_1409; // @[Processor.scala 134:10 322:23]
  wire  _GEN_1432 = 8'h4 == instruction_opcode ? 1'h0 : _GEN_1410; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1433 = 8'h4 == instruction_opcode ? 1'h0 : _GEN_1411; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1434 = 8'h4 == instruction_opcode ? 1'h0 : _GEN_1412; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1436 = 8'h4 == instruction_opcode ? instructionPointerReg : _GEN_1414; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1437 = 8'h4 == instruction_opcode ? stackPointerReg : _GEN_1415; // @[Processor.scala 322:23 84:32]
  wire [7:0] _GEN_1438 = 8'h3 == instruction_opcode ? _GEN_100 : _GEN_1419; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1439 = 8'h3 == instruction_opcode ? _GEN_101 : _GEN_1420; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1440 = 8'h3 == instruction_opcode ? _GEN_102 : _GEN_1421; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1441 = 8'h3 == instruction_opcode ? _GEN_103 : _GEN_1422; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1442 = 8'h3 == instruction_opcode ? _GEN_104 : _GEN_1417; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1445 = 8'h3 == instruction_opcode ? mdr : _GEN_1423; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1446 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1424; // @[Processor.scala 129:11 322:23]
  wire  _GEN_1447 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1425; // @[Processor.scala 131:11 322:23]
  wire  _GEN_1448 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1426; // @[Processor.scala 138:10 322:23]
  wire  _GEN_1450 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1428; // @[Processor.scala 139:10 322:23]
  wire  _GEN_1451 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1429; // @[Processor.scala 132:11 322:23]
  wire  _GEN_1452 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1430; // @[Processor.scala 133:10 322:23]
  wire  _GEN_1453 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1431; // @[Processor.scala 134:10 322:23]
  wire  _GEN_1454 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1432; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1455 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1433; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1456 = 8'h3 == instruction_opcode ? 1'h0 : _GEN_1434; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1458 = 8'h3 == instruction_opcode ? instructionPointerReg : _GEN_1436; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1459 = 8'h3 == instruction_opcode ? stackPointerReg : _GEN_1437; // @[Processor.scala 322:23 84:32]
  wire [2:0] _GEN_1461 = 8'h2 == instruction_opcode ? _GEN_5 : _GEN_1442; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1463 = 8'h2 == instruction_opcode ? _GEN_90 : _GEN_1438; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1464 = 8'h2 == instruction_opcode ? _GEN_91 : _GEN_1439; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1465 = 8'h2 == instruction_opcode ? _GEN_92 : _GEN_1440; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1466 = 8'h2 == instruction_opcode ? _GEN_8 : _GEN_1441; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1467 = 8'h2 == instruction_opcode ? mdr : _GEN_1445; // @[Processor.scala 322:23 85:20]
  wire  _GEN_1468 = 8'h2 == instruction_opcode ? 1'h0 : _GEN_1446; // @[Processor.scala 129:11 322:23]
  wire  _GEN_1469 = 8'h2 == instruction_opcode ? 1'h0 : _GEN_1447; // @[Processor.scala 131:11 322:23]
  wire  _GEN_1470 = 8'h2 == instruction_opcode ? 1'h0 : _GEN_1448; // @[Processor.scala 138:10 322:23]
  wire  _GEN_1472 = 8'h2 == instruction_opcode ? 1'h0 : _GEN_1450; // @[Processor.scala 139:10 322:23]
  wire  _GEN_1473 = 8'h2 == instruction_opcode ? 1'h0 : _GEN_1451; // @[Processor.scala 132:11 322:23]
  wire  _GEN_1474 = 8'h2 == instruction_opcode ? 1'h0 : _GEN_1452; // @[Processor.scala 133:10 322:23]
  wire  _GEN_1475 = 8'h2 == instruction_opcode ? 1'h0 : _GEN_1453; // @[Processor.scala 134:10 322:23]
  wire  _GEN_1476 = 8'h2 == instruction_opcode ? 1'h0 : _GEN_1454; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1477 = 8'h2 == instruction_opcode ? 1'h0 : _GEN_1455; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1478 = 8'h2 == instruction_opcode ? 1'h0 : _GEN_1456; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1480 = 8'h2 == instruction_opcode ? instructionPointerReg : _GEN_1458; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1481 = 8'h2 == instruction_opcode ? stackPointerReg : _GEN_1459; // @[Processor.scala 322:23 84:32]
  wire [7:0] _GEN_1482 = 8'h1 == instruction_opcode ? _GEN_71 : _GEN_1467; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1483 = 8'h1 == instruction_opcode ? _GEN_5 : _GEN_1461; // @[Processor.scala 322:23]
  wire  _GEN_1485 = 8'h1 == instruction_opcode ? _GEN_73 : _GEN_1468; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1486 = 8'h1 == instruction_opcode ? _GEN_8 : _GEN_1466; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1489 = 8'h1 == instruction_opcode ? aReg : _GEN_1463; // @[Processor.scala 322:23 81:21]
  wire [7:0] _GEN_1490 = 8'h1 == instruction_opcode ? bReg : _GEN_1464; // @[Processor.scala 322:23 82:21]
  wire [7:0] _GEN_1491 = 8'h1 == instruction_opcode ? cReg : _GEN_1465; // @[Processor.scala 322:23 83:21]
  wire  _GEN_1492 = 8'h1 == instruction_opcode ? 1'h0 : _GEN_1469; // @[Processor.scala 131:11 322:23]
  wire  _GEN_1493 = 8'h1 == instruction_opcode ? 1'h0 : _GEN_1470; // @[Processor.scala 138:10 322:23]
  wire  _GEN_1495 = 8'h1 == instruction_opcode ? 1'h0 : _GEN_1472; // @[Processor.scala 139:10 322:23]
  wire  _GEN_1496 = 8'h1 == instruction_opcode ? 1'h0 : _GEN_1473; // @[Processor.scala 132:11 322:23]
  wire  _GEN_1497 = 8'h1 == instruction_opcode ? 1'h0 : _GEN_1474; // @[Processor.scala 133:10 322:23]
  wire  _GEN_1498 = 8'h1 == instruction_opcode ? 1'h0 : _GEN_1475; // @[Processor.scala 134:10 322:23]
  wire  _GEN_1499 = 8'h1 == instruction_opcode ? 1'h0 : _GEN_1476; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1500 = 8'h1 == instruction_opcode ? 1'h0 : _GEN_1477; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1501 = 8'h1 == instruction_opcode ? 1'h0 : _GEN_1478; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1503 = 8'h1 == instruction_opcode ? instructionPointerReg : _GEN_1480; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1504 = 8'h1 == instruction_opcode ? stackPointerReg : _GEN_1481; // @[Processor.scala 322:23 84:32]
  wire [7:0] _GEN_1506 = 8'h0 == instruction_opcode ? _GEN_62 : _GEN_1489; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1507 = 8'h0 == instruction_opcode ? _GEN_63 : _GEN_1490; // @[Processor.scala 322:23]
  wire [7:0] _GEN_1508 = 8'h0 == instruction_opcode ? _GEN_64 : _GEN_1491; // @[Processor.scala 322:23]
  wire [2:0] _GEN_1509 = 8'h0 == instruction_opcode ? 3'h1 : _GEN_1486; // @[Processor.scala 322:23 363:24]
  wire [7:0] _GEN_1510 = 8'h0 == instruction_opcode ? mdr : _GEN_1482; // @[Processor.scala 322:23 85:20]
  wire [2:0] _GEN_1511 = 8'h0 == instruction_opcode ? tStateCount_value : _GEN_1483; // @[Processor.scala 322:23 Counter.scala 61:40]
  wire  _GEN_1513 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1485; // @[Processor.scala 129:11 322:23]
  wire  _GEN_1515 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1492; // @[Processor.scala 131:11 322:23]
  wire  _GEN_1516 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1493; // @[Processor.scala 138:10 322:23]
  wire  _GEN_1518 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1495; // @[Processor.scala 139:10 322:23]
  wire  _GEN_1519 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1496; // @[Processor.scala 132:11 322:23]
  wire  _GEN_1520 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1497; // @[Processor.scala 133:10 322:23]
  wire  _GEN_1521 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1498; // @[Processor.scala 134:10 322:23]
  wire  _GEN_1522 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1499; // @[Processor.scala 135:10 322:23]
  wire  _GEN_1523 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1500; // @[Processor.scala 136:10 322:23]
  wire  _GEN_1524 = 8'h0 == instruction_opcode ? 1'h0 : _GEN_1501; // @[Processor.scala 137:10 322:23]
  wire [7:0] _GEN_1526 = 8'h0 == instruction_opcode ? instructionPointerReg : _GEN_1503; // @[Processor.scala 322:23 80:38]
  wire [7:0] _GEN_1527 = 8'h0 == instruction_opcode ? stackPointerReg : _GEN_1504; // @[Processor.scala 322:23 84:32]
  wire  _GEN_1528 = 3'h6 == currentState | finishedReg; // @[Processor.scala 145:25 1504:19 74:28]
  wire [7:0] _GEN_1530 = 3'h5 == currentState ? _GEN_1506 : aReg; // @[Processor.scala 145:25 81:21]
  wire [7:0] _GEN_1531 = 3'h5 == currentState ? _GEN_1507 : bReg; // @[Processor.scala 145:25 82:21]
  wire [7:0] _GEN_1532 = 3'h5 == currentState ? _GEN_1508 : cReg; // @[Processor.scala 145:25 83:21]
  wire [2:0] _GEN_1533 = 3'h5 == currentState ? _GEN_1509 : currentState; // @[Processor.scala 145:25 90:29]
  wire [7:0] _GEN_1534 = 3'h5 == currentState ? _GEN_1510 : mdr; // @[Processor.scala 145:25 85:20]
  wire [2:0] _GEN_1535 = 3'h5 == currentState ? _GEN_1511 : tStateCount_value; // @[Processor.scala 145:25 Counter.scala 61:40]
  wire [7:0] _GEN_1550 = 3'h5 == currentState ? _GEN_1526 : instructionPointerReg; // @[Processor.scala 145:25 80:38]
  wire [7:0] _GEN_1551 = 3'h5 == currentState ? _GEN_1527 : stackPointerReg; // @[Processor.scala 145:25 84:32]
  wire  _GEN_1552 = 3'h5 == currentState ? finishedReg : _GEN_1528; // @[Processor.scala 145:25 74:28]
  wire [7:0] _GEN_1553 = 3'h4 == currentState ? _GEN_54 : instruction_operands_0; // @[Processor.scala 145:25 94:28]
  wire [7:0] _GEN_1554 = 3'h4 == currentState ? _GEN_55 : instruction_operands_1; // @[Processor.scala 145:25 94:28]
  wire [1:0] _GEN_1555 = 3'h4 == currentState ? _bytesToRead_T_1 : bytesToRead; // @[Processor.scala 145:25 313:19 101:28]
  wire [1:0] _GEN_1556 = 3'h4 == currentState ? _operandCount_T_1 : operandCount; // @[Processor.scala 145:25 314:20 102:29]
  wire [2:0] _GEN_1557 = 3'h4 == currentState ? 3'h3 : _GEN_1533; // @[Processor.scala 145:25 315:20]
  wire [7:0] _GEN_1559 = 3'h4 == currentState ? aReg : _GEN_1530; // @[Processor.scala 145:25 81:21]
  wire [7:0] _GEN_1560 = 3'h4 == currentState ? bReg : _GEN_1531; // @[Processor.scala 145:25 82:21]
  wire [7:0] _GEN_1561 = 3'h4 == currentState ? cReg : _GEN_1532; // @[Processor.scala 145:25 83:21]
  wire [7:0] _GEN_1562 = 3'h4 == currentState ? mdr : _GEN_1534; // @[Processor.scala 145:25 85:20]
  wire [2:0] _GEN_1563 = 3'h4 == currentState ? tStateCount_value : _GEN_1535; // @[Processor.scala 145:25 Counter.scala 61:40]
  wire  _GEN_1565 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1513; // @[Processor.scala 129:11 145:25]
  wire  _GEN_1567 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1515; // @[Processor.scala 131:11 145:25]
  wire  _GEN_1568 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1516; // @[Processor.scala 138:10 145:25]
  wire  _GEN_1570 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1518; // @[Processor.scala 139:10 145:25]
  wire  _GEN_1571 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1519; // @[Processor.scala 132:11 145:25]
  wire  _GEN_1572 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1520; // @[Processor.scala 133:10 145:25]
  wire  _GEN_1573 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1521; // @[Processor.scala 134:10 145:25]
  wire  _GEN_1574 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1522; // @[Processor.scala 135:10 145:25]
  wire  _GEN_1575 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1523; // @[Processor.scala 136:10 145:25]
  wire  _GEN_1576 = 3'h4 == currentState ? 1'h0 : 3'h5 == currentState & _GEN_1524; // @[Processor.scala 137:10 145:25]
  wire [7:0] _GEN_1578 = 3'h4 == currentState ? instructionPointerReg : _GEN_1550; // @[Processor.scala 145:25 80:38]
  wire [7:0] _GEN_1579 = 3'h4 == currentState ? stackPointerReg : _GEN_1551; // @[Processor.scala 145:25 84:32]
  wire  _GEN_1580 = 3'h4 == currentState ? finishedReg : _GEN_1552; // @[Processor.scala 145:25 74:28]
  wire [7:0] _GEN_1581 = 3'h3 == currentState ? _instructionPointerReg_T_1 : _GEN_1578; // @[Processor.scala 145:25 300:29]
  wire [2:0] _GEN_1582 = 3'h3 == currentState ? _GEN_53 : _GEN_1557; // @[Processor.scala 145:25]
  wire [7:0] _GEN_1583 = 3'h3 == currentState ? instruction_operands_0 : _GEN_1553; // @[Processor.scala 145:25 94:28]
  wire [7:0] _GEN_1584 = 3'h3 == currentState ? instruction_operands_1 : _GEN_1554; // @[Processor.scala 145:25 94:28]
  wire [1:0] _GEN_1585 = 3'h3 == currentState ? bytesToRead : _GEN_1555; // @[Processor.scala 145:25 101:28]
  wire [1:0] _GEN_1586 = 3'h3 == currentState ? operandCount : _GEN_1556; // @[Processor.scala 145:25 102:29]
  wire [7:0] _GEN_1588 = 3'h3 == currentState ? aReg : _GEN_1559; // @[Processor.scala 145:25 81:21]
  wire [7:0] _GEN_1589 = 3'h3 == currentState ? bReg : _GEN_1560; // @[Processor.scala 145:25 82:21]
  wire [7:0] _GEN_1590 = 3'h3 == currentState ? cReg : _GEN_1561; // @[Processor.scala 145:25 83:21]
  wire [7:0] _GEN_1591 = 3'h3 == currentState ? mdr : _GEN_1562; // @[Processor.scala 145:25 85:20]
  wire [2:0] _GEN_1592 = 3'h3 == currentState ? tStateCount_value : _GEN_1563; // @[Processor.scala 145:25 Counter.scala 61:40]
  wire  _GEN_1594 = 3'h3 == currentState ? 1'h0 : _GEN_1565; // @[Processor.scala 129:11 145:25]
  wire  _GEN_1596 = 3'h3 == currentState ? 1'h0 : _GEN_1567; // @[Processor.scala 131:11 145:25]
  wire  _GEN_1597 = 3'h3 == currentState ? 1'h0 : _GEN_1568; // @[Processor.scala 138:10 145:25]
  wire  _GEN_1599 = 3'h3 == currentState ? 1'h0 : _GEN_1570; // @[Processor.scala 139:10 145:25]
  wire  _GEN_1600 = 3'h3 == currentState ? 1'h0 : _GEN_1571; // @[Processor.scala 132:11 145:25]
  wire  _GEN_1601 = 3'h3 == currentState ? 1'h0 : _GEN_1572; // @[Processor.scala 133:10 145:25]
  wire  _GEN_1602 = 3'h3 == currentState ? 1'h0 : _GEN_1573; // @[Processor.scala 134:10 145:25]
  wire  _GEN_1603 = 3'h3 == currentState ? 1'h0 : _GEN_1574; // @[Processor.scala 135:10 145:25]
  wire  _GEN_1604 = 3'h3 == currentState ? 1'h0 : _GEN_1575; // @[Processor.scala 136:10 145:25]
  wire  _GEN_1605 = 3'h3 == currentState ? 1'h0 : _GEN_1576; // @[Processor.scala 137:10 145:25]
  wire [7:0] _GEN_1607 = 3'h3 == currentState ? stackPointerReg : _GEN_1579; // @[Processor.scala 145:25 84:32]
  wire  _GEN_1608 = 3'h3 == currentState ? finishedReg : _GEN_1580; // @[Processor.scala 145:25 74:28]
  wire  _GEN_1623 = 3'h2 == currentState ? 1'h0 : _GEN_1594; // @[Processor.scala 129:11 145:25]
  wire  _GEN_1625 = 3'h2 == currentState ? 1'h0 : _GEN_1596; // @[Processor.scala 131:11 145:25]
  wire  _GEN_1626 = 3'h2 == currentState ? 1'h0 : _GEN_1597; // @[Processor.scala 138:10 145:25]
  wire  _GEN_1628 = 3'h2 == currentState ? 1'h0 : _GEN_1599; // @[Processor.scala 139:10 145:25]
  wire  _GEN_1629 = 3'h2 == currentState ? 1'h0 : _GEN_1600; // @[Processor.scala 132:11 145:25]
  wire  _GEN_1630 = 3'h2 == currentState ? 1'h0 : _GEN_1601; // @[Processor.scala 133:10 145:25]
  wire  _GEN_1631 = 3'h2 == currentState ? 1'h0 : _GEN_1602; // @[Processor.scala 134:10 145:25]
  wire  _GEN_1632 = 3'h2 == currentState ? 1'h0 : _GEN_1603; // @[Processor.scala 135:10 145:25]
  wire  _GEN_1633 = 3'h2 == currentState ? 1'h0 : _GEN_1604; // @[Processor.scala 136:10 145:25]
  wire  _GEN_1634 = 3'h2 == currentState ? 1'h0 : _GEN_1605; // @[Processor.scala 137:10 145:25]
  wire  _GEN_1654 = 3'h1 == currentState ? 1'h0 : _GEN_1623; // @[Processor.scala 129:11 145:25]
  wire  _GEN_1655 = 3'h1 == currentState ? 1'h0 : _GEN_1625; // @[Processor.scala 131:11 145:25]
  wire  _GEN_1656 = 3'h1 == currentState ? 1'h0 : _GEN_1626; // @[Processor.scala 138:10 145:25]
  wire  _GEN_1658 = 3'h1 == currentState ? 1'h0 : _GEN_1628; // @[Processor.scala 139:10 145:25]
  wire  _GEN_1659 = 3'h1 == currentState ? 1'h0 : _GEN_1629; // @[Processor.scala 132:11 145:25]
  wire  _GEN_1660 = 3'h1 == currentState ? 1'h0 : _GEN_1630; // @[Processor.scala 133:10 145:25]
  wire  _GEN_1661 = 3'h1 == currentState ? 1'h0 : _GEN_1631; // @[Processor.scala 134:10 145:25]
  wire  _GEN_1662 = 3'h1 == currentState ? 1'h0 : _GEN_1632; // @[Processor.scala 135:10 145:25]
  wire  _GEN_1663 = 3'h1 == currentState ? 1'h0 : _GEN_1633; // @[Processor.scala 136:10 145:25]
  wire  _GEN_1664 = 3'h1 == currentState ? 1'h0 : _GEN_1634; // @[Processor.scala 137:10 145:25]
  RAM ram ( // @[Processor.scala 77:19]
    .clock(ram_clock),
    .io_writeEn(ram_io_writeEn),
    .io_addrIn(ram_io_addrIn),
    .io_dataIn(ram_io_dataIn),
    .io_dataOut(ram_io_dataOut)
  );
  ALU alu ( // @[Processor.scala 88:19]
    .clock(alu_clock),
    .reset(alu_reset),
    .io_op1Load(alu_io_op1Load),
    .io_op2Load(alu_io_op2Load),
    .io_addSig(alu_io_addSig),
    .io_subSig(alu_io_subSig),
    .io_divSig(alu_io_divSig),
    .io_mulSig(alu_io_mulSig),
    .io_modSig(alu_io_modSig),
    .io_incSig(alu_io_incSig),
    .io_decSig(alu_io_decSig),
    .io_op1In(alu_io_op1In),
    .io_op2In(alu_io_op2In),
    .io_resultOut(alu_io_resultOut),
    .io_zeroFlag(alu_io_zeroFlag)
  );
  assign io_finished = finishedReg; // @[Processor.scala 1508:15]
  assign ram_clock = clock;
  assign ram_io_writeEn = 3'h0 == currentState ? 1'h0 : _GEN_1654; // @[Processor.scala 129:11 145:25]
  assign ram_io_addrIn = resultEn ? alu_io_resultOut : _GEN_1700; // @[Processor.scala 1566:19 1567:9]
  assign ram_io_dataIn = mdr; // @[Processor.scala 1514:17]
  assign alu_clock = clock;
  assign alu_reset = reset;
  assign alu_io_op1Load = 3'h0 == currentState ? 1'h0 : _GEN_1655; // @[Processor.scala 131:11 145:25]
  assign alu_io_op2Load = 3'h0 == currentState ? 1'h0 : _GEN_1659; // @[Processor.scala 132:11 145:25]
  assign alu_io_addSig = 3'h0 == currentState ? 1'h0 : _GEN_1660; // @[Processor.scala 133:10 145:25]
  assign alu_io_subSig = 3'h0 == currentState ? 1'h0 : _GEN_1661; // @[Processor.scala 134:10 145:25]
  assign alu_io_divSig = 3'h0 == currentState ? 1'h0 : _GEN_1663; // @[Processor.scala 136:10 145:25]
  assign alu_io_mulSig = 3'h0 == currentState ? 1'h0 : _GEN_1662; // @[Processor.scala 135:10 145:25]
  assign alu_io_modSig = 3'h0 == currentState ? 1'h0 : _GEN_1664; // @[Processor.scala 137:10 145:25]
  assign alu_io_incSig = 3'h0 == currentState ? 1'h0 : _GEN_1656; // @[Processor.scala 138:10 145:25]
  assign alu_io_decSig = 3'h0 == currentState ? 1'h0 : _GEN_1658; // @[Processor.scala 139:10 145:25]
  assign alu_io_op1In = resultEn ? alu_io_resultOut : _GEN_1700; // @[Processor.scala 1566:19 1567:9]
  assign alu_io_op2In = resultEn ? alu_io_resultOut : _GEN_1700; // @[Processor.scala 1566:19 1567:9]
  always @(posedge clock) begin
    if (reset) begin // @[Processor.scala 74:28]
      finishedReg <= 1'h0; // @[Processor.scala 74:28]
    end else if (!(3'h0 == currentState)) begin // @[Processor.scala 145:25]
      if (!(3'h1 == currentState)) begin // @[Processor.scala 145:25]
        if (!(3'h2 == currentState)) begin // @[Processor.scala 145:25]
          finishedReg <= _GEN_1608;
        end
      end
    end
    if (reset) begin // @[Processor.scala 80:38]
      instructionPointerReg <= 8'h0; // @[Processor.scala 80:38]
    end else if (3'h0 == currentState) begin // @[Processor.scala 145:25]
      if (!(tStateCount_value == 3'h0)) begin // @[Processor.scala 148:40]
        if (tStateCount_value == 3'h1) begin // @[Processor.scala 152:48]
          instructionPointerReg <= bus; // @[Processor.scala 155:31]
        end
      end
    end else if (!(3'h1 == currentState)) begin // @[Processor.scala 145:25]
      if (!(3'h2 == currentState)) begin // @[Processor.scala 145:25]
        instructionPointerReg <= _GEN_1581;
      end
    end
    if (reset) begin // @[Processor.scala 81:21]
      aReg <= 8'h0; // @[Processor.scala 81:21]
    end else if (!(3'h0 == currentState)) begin // @[Processor.scala 145:25]
      if (!(3'h1 == currentState)) begin // @[Processor.scala 145:25]
        if (!(3'h2 == currentState)) begin // @[Processor.scala 145:25]
          aReg <= _GEN_1588;
        end
      end
    end
    if (reset) begin // @[Processor.scala 82:21]
      bReg <= 8'h0; // @[Processor.scala 82:21]
    end else if (!(3'h0 == currentState)) begin // @[Processor.scala 145:25]
      if (!(3'h1 == currentState)) begin // @[Processor.scala 145:25]
        if (!(3'h2 == currentState)) begin // @[Processor.scala 145:25]
          bReg <= _GEN_1589;
        end
      end
    end
    if (reset) begin // @[Processor.scala 83:21]
      cReg <= 8'h0; // @[Processor.scala 83:21]
    end else if (!(3'h0 == currentState)) begin // @[Processor.scala 145:25]
      if (!(3'h1 == currentState)) begin // @[Processor.scala 145:25]
        if (!(3'h2 == currentState)) begin // @[Processor.scala 145:25]
          cReg <= _GEN_1590;
        end
      end
    end
    if (reset) begin // @[Processor.scala 84:32]
      stackPointerReg <= 8'h0; // @[Processor.scala 84:32]
    end else if (!(3'h0 == currentState)) begin // @[Processor.scala 145:25]
      if (!(3'h1 == currentState)) begin // @[Processor.scala 145:25]
        if (!(3'h2 == currentState)) begin // @[Processor.scala 145:25]
          stackPointerReg <= _GEN_1607;
        end
      end
    end
    if (reset) begin // @[Processor.scala 85:20]
      mdr <= 8'h0; // @[Processor.scala 85:20]
    end else if (!(3'h0 == currentState)) begin // @[Processor.scala 145:25]
      if (!(3'h1 == currentState)) begin // @[Processor.scala 145:25]
        if (!(3'h2 == currentState)) begin // @[Processor.scala 145:25]
          mdr <= _GEN_1591;
        end
      end
    end
    if (reset) begin // @[Processor.scala 90:29]
      currentState <= 3'h0; // @[Processor.scala 90:29]
    end else if (3'h0 == currentState) begin // @[Processor.scala 145:25]
      if (!(tStateCount_value == 3'h0)) begin // @[Processor.scala 148:40]
        if (tStateCount_value == 3'h1) begin // @[Processor.scala 152:48]
          currentState <= 3'h1; // @[Processor.scala 156:22]
        end
      end
    end else if (3'h1 == currentState) begin // @[Processor.scala 145:25]
      if (!(_T_3)) begin // @[Processor.scala 161:40]
        currentState <= _GEN_14;
      end
    end else if (3'h2 == currentState) begin // @[Processor.scala 145:25]
      currentState <= 3'h3; // @[Processor.scala 296:20]
    end else begin
      currentState <= _GEN_1582;
    end
    if (reset) begin // @[Processor.scala 91:29]
      dataRegister <= 8'h0; // @[Processor.scala 91:29]
    end else if (!(3'h0 == currentState)) begin // @[Processor.scala 145:25]
      if (3'h1 == currentState) begin // @[Processor.scala 145:25]
        if (!(_T_3)) begin // @[Processor.scala 161:40]
          dataRegister <= _GEN_12;
        end
      end
    end
    if (reset) begin // @[Processor.scala 94:28]
      instruction_opcode <= 8'h0; // @[Processor.scala 94:28]
    end else if (!(3'h0 == currentState)) begin // @[Processor.scala 145:25]
      if (!(3'h1 == currentState)) begin // @[Processor.scala 145:25]
        if (3'h2 == currentState) begin // @[Processor.scala 145:25]
          instruction_opcode <= dataRegister; // @[Processor.scala 185:26]
        end
      end
    end
    if (reset) begin // @[Processor.scala 94:28]
      instruction_operands_0 <= 8'h0; // @[Processor.scala 94:28]
    end else if (!(3'h0 == currentState)) begin // @[Processor.scala 145:25]
      if (!(3'h1 == currentState)) begin // @[Processor.scala 145:25]
        if (!(3'h2 == currentState)) begin // @[Processor.scala 145:25]
          instruction_operands_0 <= _GEN_1583;
        end
      end
    end
    if (reset) begin // @[Processor.scala 94:28]
      instruction_operands_1 <= 8'h0; // @[Processor.scala 94:28]
    end else if (!(3'h0 == currentState)) begin // @[Processor.scala 145:25]
      if (!(3'h1 == currentState)) begin // @[Processor.scala 145:25]
        if (!(3'h2 == currentState)) begin // @[Processor.scala 145:25]
          instruction_operands_1 <= _GEN_1584;
        end
      end
    end
    if (reset) begin // @[Processor.scala 101:28]
      bytesToRead <= 2'h0; // @[Processor.scala 101:28]
    end else if (!(3'h0 == currentState)) begin // @[Processor.scala 145:25]
      if (!(3'h1 == currentState)) begin // @[Processor.scala 145:25]
        if (3'h2 == currentState) begin // @[Processor.scala 145:25]
          bytesToRead <= _GEN_52;
        end else begin
          bytesToRead <= _GEN_1585;
        end
      end
    end
    if (reset) begin // @[Processor.scala 102:29]
      operandCount <= 2'h0; // @[Processor.scala 102:29]
    end else if (!(3'h0 == currentState)) begin // @[Processor.scala 145:25]
      if (!(3'h1 == currentState)) begin // @[Processor.scala 145:25]
        if (3'h2 == currentState) begin // @[Processor.scala 145:25]
          operandCount <= 2'h0; // @[Processor.scala 188:20]
        end else begin
          operandCount <= _GEN_1586;
        end
      end
    end
    if (reset) begin // @[Counter.scala 61:40]
      tStateCount_value <= 3'h0; // @[Counter.scala 61:40]
    end else if (3'h0 == currentState) begin // @[Processor.scala 145:25]
      tStateCount_value <= _GEN_5;
    end else if (3'h1 == currentState) begin // @[Processor.scala 145:25]
      tStateCount_value <= _GEN_5;
    end else if (!(3'h2 == currentState)) begin // @[Processor.scala 145:25]
      tStateCount_value <= _GEN_1592;
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
  finishedReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  instructionPointerReg = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  aReg = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  bReg = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  cReg = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  stackPointerReg = _RAND_5[7:0];
  _RAND_6 = {1{`RANDOM}};
  mdr = _RAND_6[7:0];
  _RAND_7 = {1{`RANDOM}};
  currentState = _RAND_7[2:0];
  _RAND_8 = {1{`RANDOM}};
  dataRegister = _RAND_8[7:0];
  _RAND_9 = {1{`RANDOM}};
  instruction_opcode = _RAND_9[7:0];
  _RAND_10 = {1{`RANDOM}};
  instruction_operands_0 = _RAND_10[7:0];
  _RAND_11 = {1{`RANDOM}};
  instruction_operands_1 = _RAND_11[7:0];
  _RAND_12 = {1{`RANDOM}};
  bytesToRead = _RAND_12[1:0];
  _RAND_13 = {1{`RANDOM}};
  operandCount = _RAND_13[1:0];
  _RAND_14 = {1{`RANDOM}};
  tStateCount_value = _RAND_14[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
