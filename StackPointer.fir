circuit StackPointer :
  module StackPointer :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip spDec : UInt<1>, flip spInc : UInt<1>, spOut : UInt<8>}

    reg spReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("hff")) @[StackPointer.scala 9:22]
    when io.spDec : @[StackPointer.scala 11:19]
      node _spReg_T = sub(spReg, UInt<1>("h1")) @[StackPointer.scala 12:20]
      node _spReg_T_1 = tail(_spReg_T, 1) @[StackPointer.scala 12:20]
      spReg <= _spReg_T_1 @[StackPointer.scala 12:11]
    when io.spInc : @[StackPointer.scala 15:19]
      node _T = lt(spReg, UInt<8>("hff")) @[StackPointer.scala 16:17]
      when _T : @[StackPointer.scala 16:26]
        node _spReg_T_2 = add(spReg, UInt<1>("h1")) @[StackPointer.scala 17:22]
        node _spReg_T_3 = tail(_spReg_T_2, 1) @[StackPointer.scala 17:22]
        spReg <= _spReg_T_3 @[StackPointer.scala 17:13]
      else :
        node _T_1 = bits(reset, 0, 0) @[StackPointer.scala 21:13]
        node _T_2 = eq(_T_1, UInt<1>("h0")) @[StackPointer.scala 21:13]
        when _T_2 : @[StackPointer.scala 21:13]
          printf(clock, UInt<1>("h1"), "Stack underflow!\n") : printf @[StackPointer.scala 21:13]
    io.spOut <= spReg @[StackPointer.scala 25:12]

