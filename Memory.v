module Memory(
  input         clock,
  input         reset,
  input         io_dataLoad,
  input         io_addressLoad,
  input  [15:0] io_addressIn,
  input  [15:0] io_dataIn,
  output [15:0] io_dataOut
);
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] mem [0:65534]; // @[Memory.scala 13:24]
  wire  mem_io_dataOut_MPORT_en; // @[Memory.scala 13:24]
  wire [15:0] mem_io_dataOut_MPORT_addr; // @[Memory.scala 13:24]
  wire [15:0] mem_io_dataOut_MPORT_data; // @[Memory.scala 13:24]
  wire [15:0] mem_MPORT_data; // @[Memory.scala 13:24]
  wire [15:0] mem_MPORT_addr; // @[Memory.scala 13:24]
  wire  mem_MPORT_mask; // @[Memory.scala 13:24]
  wire  mem_MPORT_en; // @[Memory.scala 13:24]
  reg  mem_io_dataOut_MPORT_en_pipe_0;
  reg [15:0] mem_io_dataOut_MPORT_addr_pipe_0;
  assign mem_io_dataOut_MPORT_en = mem_io_dataOut_MPORT_en_pipe_0;
  assign mem_io_dataOut_MPORT_addr = mem_io_dataOut_MPORT_addr_pipe_0;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign mem_io_dataOut_MPORT_data = mem[mem_io_dataOut_MPORT_addr]; // @[Memory.scala 13:24]
  `else
  assign mem_io_dataOut_MPORT_data = mem_io_dataOut_MPORT_addr >= 16'hffff ? _RAND_1[15:0] :
    mem[mem_io_dataOut_MPORT_addr]; // @[Memory.scala 13:24]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign mem_MPORT_data = io_dataIn;
  assign mem_MPORT_addr = io_addressIn;
  assign mem_MPORT_mask = 1'h1;
  assign mem_MPORT_en = io_dataLoad;
  assign io_dataOut = mem_io_dataOut_MPORT_data; // @[Memory.scala 19:14]
  always @(posedge clock) begin
    if (mem_MPORT_en & mem_MPORT_mask) begin
      mem[mem_MPORT_addr] <= mem_MPORT_data; // @[Memory.scala 13:24]
    end
    mem_io_dataOut_MPORT_en_pipe_0 <= io_addressLoad;
    if (io_addressLoad) begin
      mem_io_dataOut_MPORT_addr_pipe_0 <= io_addressIn;
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
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  _RAND_1 = {1{`RANDOM}};
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 65535; initvar = initvar+1)
    mem[initvar] = _RAND_0[15:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  mem_io_dataOut_MPORT_en_pipe_0 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  mem_io_dataOut_MPORT_addr_pipe_0 = _RAND_3[15:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
