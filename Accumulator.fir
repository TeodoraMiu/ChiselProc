circuit Accumulator :
  module Accumulator :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip accLoad : UInt<1>, flip accIn : UInt<8>, accOut : UInt<8>}

    reg accReg : UInt<8>, clock with :
      reset => (reset, UInt<8>("h0")) @[Accumulator.scala 9:25]
    when io.accLoad : @[Accumulator.scala 11:23]
      accReg <= io.accIn @[Accumulator.scala 12:16]
    io.accOut <= accReg @[Accumulator.scala 15:15]

