circuit Memory :
  module Memory :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip dataLoad : UInt<1>, flip addressLoad : UInt<1>, flip addressIn : UInt<16>, flip dataIn : UInt<16>, dataOut : UInt<16>}

    reg dataReg : UInt<16>, clock with :
      reset => (reset, UInt<16>("h0")) @[Memory.scala 12:24]
    smem mem : UInt<16> [65535] @[Memory.scala 13:24]
    when io.dataLoad : @[Memory.scala 15:22]
      write mport MPORT = mem[io.addressIn], clock
      MPORT <= io.dataIn
    wire _io_dataOut_WIRE : UInt @[Memory.scala 19:25]
    _io_dataOut_WIRE is invalid @[Memory.scala 19:25]
    when io.addressLoad : @[Memory.scala 19:25]
      _io_dataOut_WIRE <= io.addressIn @[Memory.scala 19:25]
      node _io_dataOut_T = or(_io_dataOut_WIRE, UInt<16>("h0")) @[Memory.scala 19:25]
      node _io_dataOut_T_1 = bits(_io_dataOut_T, 15, 0) @[Memory.scala 19:25]
      read mport io_dataOut_MPORT = mem[_io_dataOut_T_1], clock @[Memory.scala 19:25]
    io.dataOut <= io_dataOut_MPORT @[Memory.scala 19:14]

