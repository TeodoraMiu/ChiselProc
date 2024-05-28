circuit InstructionPointer :
  module InstructionPointer :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip ipLoad : UInt<1>, flip ipInc : UInt<1>, flip cntIn : UInt<8>, cntOut : UInt<8>}

    reg cntReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[InstructionPointer.scala 10:23]
    when io.ipInc : @[InstructionPointer.scala 12:19]
      node _cntReg_T = add(cntReg, UInt<1>("h1")) @[InstructionPointer.scala 13:22]
      node _cntReg_T_1 = tail(_cntReg_T, 1) @[InstructionPointer.scala 13:22]
      cntReg <= _cntReg_T_1 @[InstructionPointer.scala 13:12]
    when io.ipLoad : @[InstructionPointer.scala 16:20]
      cntReg <= io.cntIn @[InstructionPointer.scala 17:12]
    io.cntOut <= cntReg @[InstructionPointer.scala 20:13]

