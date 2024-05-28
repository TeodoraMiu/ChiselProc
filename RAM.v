module RAM(
  input        clock,
  input        reset,
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
  $readmemb("binary.bin", mem);
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
