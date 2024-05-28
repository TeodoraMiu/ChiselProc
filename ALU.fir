circuit ALU :
  module ALU :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip op1Load : UInt<1>, flip op2Load : UInt<1>, flip addSig : UInt<1>, flip subSig : UInt<1>, flip divSig : UInt<1>, flip mulSig : UInt<1>, flip modSig : UInt<1>, flip incSig : UInt<1>, flip decSig : UInt<1>, flip op1In : UInt<8>, flip op2In : UInt<8>, resultOut : UInt<8>, zeroFlag : UInt<1>, carryFlag : UInt<1>}

    reg op1Reg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[ALU.scala 20:25]
    reg op2Reg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[ALU.scala 21:25]
    reg resultReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[ALU.scala 22:28]
    reg zeroFlagReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[ALU.scala 23:30]
    reg carryFlagReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[ALU.scala 24:31]
    when io.op1Load : @[ALU.scala 26:23]
      op1Reg <= io.op1In @[ALU.scala 27:16]
    when io.op2Load : @[ALU.scala 30:23]
      op2Reg <= io.op2In @[ALU.scala 31:16]
    when io.addSig : @[ALU.scala 34:22]
      node _resultReg_T = add(op1Reg, op2Reg) @[ALU.scala 35:29]
      node _resultReg_T_1 = tail(_resultReg_T, 1) @[ALU.scala 35:29]
      resultReg <= _resultReg_T_1 @[ALU.scala 35:19]
    when io.subSig : @[ALU.scala 38:22]
      node _resultReg_T_2 = sub(op1Reg, op2Reg) @[ALU.scala 39:29]
      node _resultReg_T_3 = tail(_resultReg_T_2, 1) @[ALU.scala 39:29]
      resultReg <= _resultReg_T_3 @[ALU.scala 39:19]
    when io.mulSig : @[ALU.scala 42:22]
      node _resultReg_T_4 = mul(op1Reg, op2Reg) @[ALU.scala 43:29]
      resultReg <= _resultReg_T_4 @[ALU.scala 43:19]
    when io.divSig : @[ALU.scala 46:22]
      node _resultReg_T_5 = div(op1Reg, op2Reg) @[ALU.scala 47:29]
      resultReg <= _resultReg_T_5 @[ALU.scala 47:19]
    when io.modSig : @[ALU.scala 50:22]
      node _resultReg_T_6 = rem(op1Reg, op2Reg) @[ALU.scala 51:29]
      resultReg <= _resultReg_T_6 @[ALU.scala 51:19]
    when io.incSig : @[ALU.scala 54:22]
      node _resultReg_T_7 = add(op1Reg, UInt<1>("h1")) @[ALU.scala 55:29]
      node _resultReg_T_8 = tail(_resultReg_T_7, 1) @[ALU.scala 55:29]
      resultReg <= _resultReg_T_8 @[ALU.scala 55:19]
    when io.decSig : @[ALU.scala 58:22]
      node _resultReg_T_9 = sub(op1Reg, UInt<1>("h1")) @[ALU.scala 59:29]
      node _resultReg_T_10 = tail(_resultReg_T_9, 1) @[ALU.scala 59:29]
      resultReg <= _resultReg_T_10 @[ALU.scala 59:19]
    node _T = eq(resultReg, UInt<1>("h0")) @[ALU.scala 62:21]
    node _T_1 = eq(op1Reg, op2Reg) @[ALU.scala 62:39]
    node _T_2 = or(_T, _T_1) @[ALU.scala 62:29]
    when _T_2 : @[ALU.scala 62:51]
      zeroFlagReg <= UInt<1>("h1") @[ALU.scala 63:21]
    else :
      zeroFlagReg <= UInt<1>("h0") @[ALU.scala 65:21]
    io.resultOut <= resultReg @[ALU.scala 68:18]
    io.zeroFlag <= zeroFlagReg @[ALU.scala 69:17]
    io.carryFlag <= carryFlagReg @[ALU.scala 70:18]

