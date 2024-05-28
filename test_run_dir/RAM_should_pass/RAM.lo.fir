FIRRTL version 1.1.0
circuit RAM :
  module RAM :
    input clock : Clock
    input reset : UInt<1>
    input io_dataLoad : UInt<1>
    input io_addrLoad : UInt<1>
    input io_addrIn : UInt<8>
    input io_dataIn : UInt<8>
    output io_dataOut : UInt<8>

    mem mem : @[RAM.scala 13:24]
      data-type => UInt<16>
      depth => 65535
      read-latency => 1
      write-latency => 1
      reader => io_dataOut_MPORT
      writer => MPORT
      read-under-write => undefined
    reg dataReg : UInt<16>, clock with :
      reset => (UInt<1>("h0"), dataReg) @[RAM.scala 12:24]
    node _GEN_0 = validif(io_dataLoad, io_addrIn) @[RAM.scala 15:22]
    node _GEN_1 = validif(io_dataLoad, clock) @[RAM.scala 15:22]
    node _GEN_2 = mux(io_dataLoad, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 15:22 13:24]
    node _GEN_3 = validif(io_dataLoad, UInt<1>("h1")) @[RAM.scala 15:22]
    node _GEN_4 = validif(io_dataLoad, io_dataIn) @[RAM.scala 15:22]
    node _GEN_5 = validif(io_addrLoad, io_addrIn) @[RAM.scala 19:{25,25}]
    node _io_dataOut_WIRE = _GEN_5 @[RAM.scala 19:25]
    node _io_dataOut_T = or(_io_dataOut_WIRE, UInt<16>("h0")) @[RAM.scala 19:25]
    node _io_dataOut_T_1 = bits(_io_dataOut_T, 15, 0) @[RAM.scala 19:25]
    node _GEN_6 = mux(io_addrLoad, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 13:24 19:{25,25}]
    node _GEN_7 = validif(io_addrLoad, _io_dataOut_T_1) @[RAM.scala 19:{25,25}]
    node _GEN_8 = validif(io_addrLoad, clock) @[RAM.scala 19:{25,25}]
    io_dataOut <= bits(mem.io_dataOut_MPORT.data, 7, 0) @[RAM.scala 19:14]
    dataReg <= mux(reset, UInt<16>("h0"), dataReg) @[RAM.scala 12:{24,24,24}]
    mem.io_dataOut_MPORT.addr <= _GEN_7
    mem.io_dataOut_MPORT.en <= _GEN_6
    mem.io_dataOut_MPORT.clk <= _GEN_8
    mem.MPORT.addr <= pad(_GEN_0, 16)
    mem.MPORT.en <= _GEN_2
    mem.MPORT.clk <= _GEN_1
    mem.MPORT.data <= pad(_GEN_4, 16)
    mem.MPORT.mask <= _GEN_3
