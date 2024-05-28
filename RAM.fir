circuit RAM :
  module RAM :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip writeEn : UInt<1>, flip addrIn : UInt<8>, flip dataIn : UInt<8>, dataOut : UInt<8>}

    smem mem : UInt<8> [256] @[RAM.scala 13:24]
    reg mdr : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[RAM.scala 15:20]
    when io.writeEn : @[RAM.scala 19:21]
      write mport MPORT = mem[io.addrIn], clock
      MPORT <= io.dataIn
    wire _io_dataOut_WIRE : UInt @[RAM.scala 23:25]
    _io_dataOut_WIRE is invalid @[RAM.scala 23:25]
    when UInt<1>("h1") : @[RAM.scala 23:25]
      _io_dataOut_WIRE <= io.addrIn @[RAM.scala 23:25]
      node _io_dataOut_T = or(_io_dataOut_WIRE, UInt<8>("h0")) @[RAM.scala 23:25]
      node _io_dataOut_T_1 = bits(_io_dataOut_T, 7, 0) @[RAM.scala 23:25]
      read mport io_dataOut_MPORT = mem[_io_dataOut_T_1], clock @[RAM.scala 23:25]
    io.dataOut <= io_dataOut_MPORT @[RAM.scala 23:14]

