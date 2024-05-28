FIRRTL version 1.1.0
circuit Memory :
  module Memory :
    input clock : Clock
    input reset : UInt<1>
    input io_dataLoad : UInt<1>
    input io_addressLoad : UInt<1>
    input io_addressIn : UInt<16>
    input io_dataIn : UInt<16>
    output io_dataOut : UInt<16>

    mem mem : @[Memory.scala 13:24]
      data-type => UInt<16>
      depth => 65535
      read-latency => 1
      write-latency => 1
      reader => io_dataOut_MPORT
      writer => MPORT
      read-under-write => undefined
    reg dataReg : UInt<16>, clock with :
      reset => (UInt<1>("h0"), dataReg) @[Memory.scala 12:24]
    node _GEN_0 = validif(io_dataLoad, io_addressIn) @[Memory.scala 15:22]
    node _GEN_1 = validif(io_dataLoad, clock) @[Memory.scala 15:22]
    node _GEN_2 = mux(io_dataLoad, UInt<1>("h1"), UInt<1>("h0")) @[Memory.scala 15:22 13:24]
    node _GEN_3 = validif(io_dataLoad, UInt<1>("h1")) @[Memory.scala 15:22]
    node _GEN_4 = validif(io_dataLoad, io_dataIn) @[Memory.scala 15:22]
    node _GEN_5 = validif(io_addressLoad, io_addressIn) @[Memory.scala 19:{25,25}]
    node _io_dataOut_WIRE = _GEN_5 @[Memory.scala 19:25]
    node _io_dataOut_T = or(_io_dataOut_WIRE, UInt<16>("h0")) @[Memory.scala 19:25]
    node _io_dataOut_T_1 = bits(_io_dataOut_T, 15, 0) @[Memory.scala 19:25]
    node _GEN_6 = mux(io_addressLoad, UInt<1>("h1"), UInt<1>("h0")) @[Memory.scala 13:24 19:{25,25}]
    node _GEN_7 = validif(io_addressLoad, _io_dataOut_T_1) @[Memory.scala 19:{25,25}]
    node _GEN_8 = validif(io_addressLoad, clock) @[Memory.scala 19:{25,25}]
    io_dataOut <= mem.io_dataOut_MPORT.data @[Memory.scala 19:14]
    dataReg <= mux(reset, UInt<16>("h0"), dataReg) @[Memory.scala 12:{24,24,24}]
    mem.io_dataOut_MPORT.addr <= _GEN_7
    mem.io_dataOut_MPORT.en <= _GEN_6
    mem.io_dataOut_MPORT.clk <= _GEN_8
    mem.MPORT.addr <= _GEN_0
    mem.MPORT.en <= _GEN_2
    mem.MPORT.clk <= _GEN_1
    mem.MPORT.data <= _GEN_4
    mem.MPORT.mask <= _GEN_3
