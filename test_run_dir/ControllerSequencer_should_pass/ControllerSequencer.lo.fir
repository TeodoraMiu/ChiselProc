FIRRTL version 1.1.0
circuit ControllerSequencer :
  module ProgramCounter :
    input clock : Clock
    input reset : UInt<1>
    input io_pcLoad : UInt<1>
    input io_pcInc : UInt<1>
    input io_counterIn : UInt<16>
    output io_counterOut : UInt<16>

    reg cntReg : UInt<16>, clock with :
      reset => (UInt<1>("h0"), cntReg) @[ProgramCounter.scala 10:23]
    node _cntReg_T = add(cntReg, UInt<1>("h1")) @[ProgramCounter.scala 13:22]
    node _cntReg_T_1 = tail(_cntReg_T, 1) @[ProgramCounter.scala 13:22]
    node _GEN_0 = mux(io_pcInc, _cntReg_T_1, cntReg) @[ProgramCounter.scala 12:19 13:12 10:23]
    node _GEN_1 = mux(io_pcLoad, io_counterIn, _GEN_0) @[ProgramCounter.scala 16:20 17:12]
    io_counterOut <= cntReg @[ProgramCounter.scala 20:17]
    cntReg <= mux(reset, UInt<16>("h0"), _GEN_1) @[ProgramCounter.scala 10:{23,23}]

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

  module ControllerSequencer :
    input clock : Clock
    input reset : UInt<1>
    input io_pcEn : UInt<1>
    input io_pcInc : UInt<1>
    input io_dataEn : UInt<1>
    input io_pcLoad : UInt<1>
    input io_addressLoad : UInt<1>
    input io_dataLoad : UInt<1>
    output io_programCounterCounter : UInt<16>

    inst programCounter of ProgramCounter @[ControllerSequencer.scala 15:30]
    inst memory of Memory @[ControllerSequencer.scala 16:22]
    node _GEN_0 = mux(io_pcEn, programCounter.io_counterOut, UInt<16>("h0")) @[ControllerSequencer.scala 35:18 19:24 36:9]
    node _GEN_1 = mux(io_dataEn, memory.io_dataOut, _GEN_0) @[ControllerSequencer.scala 38:20 39:9]
    node bus = _GEN_1 @[ControllerSequencer.scala 19:24]
    io_programCounterCounter <= programCounter.io_counterOut @[ControllerSequencer.scala 32:28]
    programCounter.clock <= clock
    programCounter.reset <= reset
    programCounter.io_pcLoad <= io_pcLoad @[ControllerSequencer.scala 21:28]
    programCounter.io_pcInc <= io_pcInc @[ControllerSequencer.scala 22:27]
    programCounter.io_counterIn <= bus @[ControllerSequencer.scala 27:31]
    memory.clock <= clock
    memory.reset <= reset
    memory.io_dataLoad <= io_dataLoad @[ControllerSequencer.scala 23:22]
    memory.io_addressLoad <= io_addressLoad @[ControllerSequencer.scala 24:25]
    memory.io_addressIn <= bus @[ControllerSequencer.scala 29:23]
    memory.io_dataIn <= bus @[ControllerSequencer.scala 28:20]
