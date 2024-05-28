FIRRTL version 1.1.0
circuit InstructionPointer :
  module InstructionPointer :
    input clock : Clock
    input reset : UInt<1>
    input io_ipLoad : UInt<1>
    input io_ipInc : UInt<1>
    input io_cntIn : UInt<8>
    output io_cntOut : UInt<8>

    reg cntReg : UInt<8>, clock with :
      reset => (UInt<1>("h0"), cntReg) @[InstructionPointer.scala 10:23]
    node _cntReg_T = add(cntReg, UInt<1>("h1")) @[InstructionPointer.scala 13:22]
    node _cntReg_T_1 = tail(_cntReg_T, 1) @[InstructionPointer.scala 13:22]
    node _GEN_0 = mux(io_ipInc, _cntReg_T_1, cntReg) @[InstructionPointer.scala 12:19 13:12 10:23]
    node _GEN_1 = mux(io_ipLoad, io_cntIn, _GEN_0) @[InstructionPointer.scala 16:20 17:12]
    io_cntOut <= cntReg @[InstructionPointer.scala 20:13]
    cntReg <= mux(reset, UInt<8>("h0"), _GEN_1) @[InstructionPointer.scala 10:{23,23}]
