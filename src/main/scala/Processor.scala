import chisel3._
import chisel3.util._

class Processor() extends Module {
  val io = IO(new Bundle {
    // This output is currently unused, but must be added in order for the Processor to be synthesized by Vivado
    val finished = Output(Bool())
  })

  // state machine for the processor's lifecycle
  object ProcessorState extends ChiselEnum {
    val INIT, FETCH, DECODE, INC_IP, STORE_OPERAND, EXECUTE, HALT = Value
  }

  // case class InstructionType(opcode: UInt, numOperands: UInt)

  // a list of all possible instructions in this processor
  object Instructions {
    val MOVRR = 0.U // reg to reg
    val MOVRV = 1.U // reg to var
    val MOVVR = 2.U // var to reg
    val MOVCR = 3.U // constant to reg
    val MOVPR = 4.U // pointer to reg
    val MOVRP = 5.U // reg to pointer
    val INC = 6.U
    val DEC = 7.U
    val ADD = 8.U
    val ADDI = 9.U
    val SUB = 10.U
    val SUBI = 11.U
    val JMP = 12.U
    val JZ = 13.U
    val JNZ = 14.U
    val CMP = 15.U
    val CALL = 16.U
    val PUSH = 17.U
    val POP = 18.U
    val RET = 19.U
    val NOP = 20.U
    val HLT = 21.U
    val MUL = 22.U
    val DIV = 23.U
    val MOD = 24.U
    val MULI = 25.U
    val DIVI = 26.U
    val MODI = 27.U
    val ADDC = 28.U
    val SUBC = 29.U
    val MULC = 30.U
    val DIVC = 31.U
    val MODC = 32.U
    val CMPC = 33.U
  }

  // the max number of opcodes an instruction can have
  val maxOperandNum = 2

  // a structure that contains an instruction: opcode and operand(s)
  class Instruction extends Bundle {
    val opcode = UInt(8.W)
    val operands = Vec(maxOperandNum, UInt(8.W))
  }

  // notation for all usable registers in this processor
  object RegisterNotation {
    val REG_A = 0.U
    val REG_B = 1.U
    val REG_C = 2.U
  }

  import ProcessorState._
  import Instructions._
  import RegisterNotation._

  val finishedReg = RegInit(false.B)

  // RAM initialization
  val ram = Module(new RAM())

  // Register initialization
  val instructionPointerReg = RegInit(0.U(8.W))
  val aReg = RegInit(0.U(8.W))
  val bReg = RegInit(0.U(8.W))
  val cReg = RegInit(0.U(8.W))
  val stackPointerReg = RegInit(0.U(8.W))
  val mdr = RegInit(0.U(8.W)) // this is here now because I'm trying to fix the readmemb problem by simplifying the RAM module

  // ALU initialization
  val alu = Module(new ALU())
  
  val currentState = RegInit(INIT)
  val dataRegister = RegInit(0.U(8.W))

  // the instruction register that contains the current instruction we are evaluating
  val instruction = RegInit({
    val instr = Wire(new Instruction())
    instr.opcode := 0.U
    instr.operands := VecInit(0.U, 0.U)
    instr // similar to Rust returns
  })

  val bytesToRead = RegInit(0.U(2.W))
  val operandCount = RegInit(0.U(2.W))
  val tStateCount = new Counter(8) // T state counter for each instruction

  // SIGNALS
  val dataEn = WireDefault(false.B)
  val op1En = WireDefault(false.B)
  val op2En = WireDefault(false.B)
  val writeEn = WireDefault(false.B)
  val resultEn = WireDefault(false.B)
  val op1Load = WireDefault(false.B)
  val op2Load = WireDefault(false.B)
  val addSig = WireDefault(false.B)
  val subSig = WireDefault(false.B)
  val mulSig = WireDefault(false.B)
  val divSig = WireDefault(false.B)
  val modSig = WireDefault(false.B)
  val incSig = WireDefault(false.B)
  val decSig = WireDefault(false.B)

  // flags
  val zeroFlag = WireDefault(false.B)
  val carryFlag = WireDefault(false.B) // TODO

  // RESET signals
  dataEn := false.B
  op1En := false.B
  op2En := false.B
  writeEn := false.B
  resultEn := false.B
  op1Load := false.B
  op2Load := false.B
  addSig := false.B
  subSig := false.B
  mulSig := false.B
  divSig := false.B
  modSig := false.B
  incSig := false.B
  decSig := false.B

  // Define the bus : a wire 8 bits wide with initial value 0
  val bus = WireDefault(0.U(8.W)) 

  // State machine
  switch (currentState) {
    is(INIT) {
      // initialize the IR with the first value in memory
      when (tStateCount.value === 0.U) {
        // Step 1: get value at memory location op1
        bus := 0.U
        tStateCount.inc()
      } . elsewhen (tStateCount.value === 1.U) {
        // Step 2: store value from RAM into accumulator
        dataEn := true.B
        instructionPointerReg := bus
        currentState := FETCH
        tStateCount.reset()
      }
    }
    is(FETCH) {
      when (tStateCount.value === 0.U) {
        // Phase 1: fetch data in memory at address of instruction pointer
        bus := instructionPointerReg // place instruction pointer value on bus
        tStateCount.inc()
      } .elsewhen (tStateCount.value === 1.U) {
        // Phase 2: store data in dataRegister
        dataEn := true.B
        dataRegister := bus
        tStateCount.reset()

        when (bytesToRead === 0.U) {
          // this means that we have not yet discovered the opcode
          // (we can't be here unless this is a new instruction)
          currentState := DECODE
        } .elsewhen (bytesToRead > 0.U) {
          // this means we have discovered the opcode and we have more operands
          // to read
          currentState := STORE_OPERAND
        }
      }
    }
    is(DECODE) {
      // printf(p"byte from memory: $ram.io.dataOut\n")
      // here we have to see what we got
      instruction.opcode := dataRegister // this should be reading from the bus,
      // NOT directly from the RAM output
      // this means I need another state, or another T count
      operandCount := 0.U
      // val dataAsUInt: UInt = ram.io.dataOut
      // bytesToRead := Instructions.instructionMap(dataAsUInt).numOperands
      switch (dataRegister) {
        // I'll do it like this for now, since I want to have the processor finished before making
        // tweaks to scala
        is(MOVRR) {
          bytesToRead := 2.U // MOV could use a single byte if we decide to use 4 bits for first reg and 4 bits for second reg
        }
        is(MOVRV) {
          bytesToRead := 2.U
        }
        is(MOVVR) {
          bytesToRead := 2.U
        }
        is(MOVCR) {
          bytesToRead := 2.U
        }
        is(MOVPR) {
          bytesToRead := 2.U
        }
        is(MOVRP) {
          bytesToRead := 2.U
        }
        is(INC) {
          bytesToRead := 1.U
        }
        is(DEC) {
          bytesToRead := 1.U
        }
        is(ADD) {
          bytesToRead := 2.U
        }
        is(ADDI) {
          bytesToRead := 2.U
        }
        is(SUB) {
          bytesToRead := 2.U
        }
        is(SUBI) {
          bytesToRead := 2.U
        }
        is(MUL) {
          bytesToRead := 2.U
        }
        is(DIV) {
          bytesToRead := 2.U
        }
        is(MOD) {
          bytesToRead := 2.U
        }
        is(MULI) {
          bytesToRead := 2.U
        }
        is(DIVI) {
          bytesToRead := 2.U
        }
        is(MODI) {
          bytesToRead := 2.U
        }
        is(JMP) {
          bytesToRead := 1.U
        }
        is(JZ) {
          bytesToRead := 1.U
        }
        is(JNZ) {
          bytesToRead := 1.U
        }
        is(CMP) {
          bytesToRead := 2.U
        }
        is(PUSH) {
          bytesToRead := 1.U
        }
        is(POP) {
          bytesToRead := 1.U
        }
        is(NOP) {
          bytesToRead := 0.U
        }
        is(RET) {
          bytesToRead := 0.U
        }
        is(HLT) {
          bytesToRead := 0.U
        }
        is(CALL) {
          bytesToRead := 1.U
        }
        is(ADDC) {
          bytesToRead := 2.U
        }
        is(SUBC) {
          bytesToRead := 2.U
        }
        is(MULC) {
          bytesToRead := 2.U
        }
        is(DIVC) {
          bytesToRead := 2.U
        }
        is(MODC) {
          bytesToRead := 2.U
        }
        is(CMPC) {
          bytesToRead := 2.U
        }
        // default case doesn't exist in chisel
        // I will have to verify instruction corectness in the assembler
      }
      currentState := INC_IP
    }
    is(INC_IP) {
      // ipInc := true.B
      instructionPointerReg := instructionPointerReg + 1.U
      when (bytesToRead === 0.U) {
        // we have finished reading all of the operands (if any)
        // we can now execute the instruction
        currentState := EXECUTE
      } .otherwise {
        // we have not yet finished reading all of the operands
        // we need to fetch the next one from memory
        currentState := FETCH
      }
    }
    is(STORE_OPERAND) {
      instruction.operands(operandCount) := dataRegister
      bytesToRead := bytesToRead - 1.U
      operandCount := operandCount + 1.U
      currentState := INC_IP
    }
    is(EXECUTE) {
      val opcode = instruction.opcode
      val operands = instruction.operands
      // execute (or continue executing, if optimized) the current instruction
      // see what instruction it is
      switch (opcode) {
        // is(DEF) {
        //   // DEF routine (DEF value address)
        //   // write a value to an address in RAM
        //   when (tStateCount.value === 0.U) {
        //     mdr := instruction.operands(0)
        //     tStateCount.inc()
        //   } .elsewhen (tStateCount.value === 1.U) {
        //     op2En := true.B
        //     writeEn := true.B
        //     currentState := FETCH
        //     tStateCount.reset()
        //   }
        // }
        is(MOVRR) {
          // MOV routine
          // move value of register x in register y
          // check first operand
          switch (instruction.operands(0)) {
            is (REG_A) {
              bus := aReg // I'm doing it this way, or else I would have to write every possible combination of A=B, B=C, etc
            }
            is (REG_B) {
              bus := bReg
            }
            is (REG_C) {
              bus := cReg
            }
          }
          // check second operand
          switch (instruction.operands(1)) {
            is (REG_A) {
              aReg := bus
            }
            is (REG_B) {
              bReg := bus
            }
            is (REG_C) {
              cReg := bus
            }
          }
          currentState := FETCH
        }
        is(MOVRV) {
          // move a register into a variable (or write to variable)
          when (tStateCount.value === 0.U) {
            switch (instruction.operands(0)) {
              is (REG_A) {
                mdr := aReg
              }
              is (REG_B) {
                mdr := bReg
              }
              is (REG_C) {
                mdr := cReg
              }
            }
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 1.U) {
            op2En := true.B
            writeEn := true.B
            currentState := FETCH
            tStateCount.reset()
          }
        }
        is(MOVVR) {
          // move a variable into a register (or read from a variable)
          when (tStateCount.value === 0.U) {
            // Step 1: get value at memory location op1
            bus := instruction.operands(0)
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // Step 2: store value from RAM into accumulator
            dataEn := true.B
            switch (instruction.operands(1)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            currentState := FETCH
            tStateCount.reset()
          }
        }
        is(MOVCR) {
          // move a constant into a register
          when (tStateCount.value === 0.U) {
            // Step 2: store value from RAM into accumulator
            switch (instruction.operands(1)) {
              is (REG_A) {
                aReg := instruction.operands(0)
              }
              is (REG_B) {
                bReg := instruction.operands(0)
              }
              is (REG_C) {
                cReg := instruction.operands(0)
              }
            }
            currentState := FETCH
            tStateCount.reset()
          }
        }
        is(MOVPR) {
          // move a value pointed to to a register (or read value pointed to)
          when (tStateCount.value === 0.U) {
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 1.U) {
            dataEn := true.B
            switch (instruction.operands(1)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            currentState := FETCH
            tStateCount.reset()
          }
        }
        is(MOVRP) {
          // move a register value to the value pointed to (or write to value pointed to)
          when (tStateCount.value === 0.U) {
            switch (instruction.operands(0)) {
              is (REG_A) {
                mdr := aReg
              }
              is (REG_B) {
                mdr := bReg
              }
              is (REG_C) {
                mdr := cReg
              }
            }
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 1.U) {
            switch (instruction.operands(1)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            writeEn := true.B
            currentState := FETCH
            tStateCount.reset()
          }
        }
        is(INC) {
          // INC Routine
          // +1 for the selected register
          when (tStateCount.value === 0.U) {
            // see what register we have, place it on the bus and take it in alu as op1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // send incSig
            incSig := true.B
            tStateCount.inc()
            
          } . elsewhen (tStateCount.value === 2.U) {
            // put new value inside register
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            resultEn := true.B
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(DEC) {
          // REC Routine
          // -1 for the selected register
          when (tStateCount.value === 0.U) {
            // see what register we have, place it on the bus and take it in alu as op1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // send decSig
            decSig := true.B
            tStateCount.inc()
            
          } . elsewhen (tStateCount.value === 2.U) {
            // put new value inside register
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            resultEn := true.B
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(ADD) {
          // ADD routine
          // add the accumulator to the selected register and store the result in the
          // accumulator
          when (tStateCount.value === 0.U) {
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // take register as op2
            switch (instruction.operands(1)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // send mulSig
            addSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // store result in first reg
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(ADDI) {
          // ADDI routine
          // add the accumulator to the selected value from memory and store 
          // the result in the accumulator
          when (tStateCount.value === 0.U) {
            // take accumulator as op1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B // LOAD TO ALU
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // get value from memory
            bus := instruction.operands(1) 
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // take value from memory as op2
            dataEn := true.B
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // send addSig
            addSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 4.U) {
            // store result in first register
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(ADDC) {
          // ADDC routine
          // add the accumulator to the constant
          when (tStateCount.value === 0.U) {
            // take accumulator as op1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B // LOAD TO ALU
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // get value from memory
            bus := instruction.operands(1) 
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // send addSig
            addSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // store result in first register
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(SUB) {
          // SUB routine
          // sub from the accumulator the selected register and store 
          // the result in the accumulator
          when (tStateCount.value === 0.U) {
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // take register as op2
            switch (instruction.operands(1)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // send mulSig
            subSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // store result in first reg
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(SUBI) {
          // SUBI routine
          // subtract from the accumulator the selected value from memory and store 
          // the result in the accumulator
          when (tStateCount.value === 0.U) {
            // take accumulator as op1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // get value from memory
            bus := instruction.operands(1)
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // take value from memory as op2
            dataEn := true.B
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // send subSig
            subSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 4.U) {
            // store result in accumulator
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(SUBC) {
          // SUBC routine
          // subtract from the accumulator the selected value from memory and store 
          // the result in the accumulator
          when (tStateCount.value === 0.U) {
            // take accumulator as op1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // get value from memory
            bus := instruction.operands(1)
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // send subSig
            subSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // store result in accumulator
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(MUL) {
          // MUL routine
          // multiply the two regs and store the result in the first reg
          when (tStateCount.value === 0.U) {
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // take register as op2
            switch (instruction.operands(1)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // send mulSig
            mulSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // store result in first reg
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(MULI) {
          // MULI routine
          // multiply from the accumulator the selected value from memory and store 
          // the result in the accumulator
          when (tStateCount.value === 0.U) {
            // take accumulator as op1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // get value from memory
            bus := instruction.operands(1)
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // take value from memory as op2
            dataEn := true.B
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // send subSig
            mulSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 4.U) {
            // store result in accumulator
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(MULC) {
          // MULC routine
          // multiply from the accumulator the selected value from memory and store 
          // the result in the accumulator
          when (tStateCount.value === 0.U) {
            // take accumulator as op1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // get value from memory
            bus := instruction.operands(1)
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // send subSig
            mulSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // store result in accumulator
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(DIV) {
          // DIV routine
          // divide the two regs and store the result in the first reg
          when (tStateCount.value === 0.U) {
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // take register as op2
            switch (instruction.operands(1)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // send divSig
            divSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // store result in first reg
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(DIVI) {
          // SUBI routine
          // subtract from the accumulator the selected value from memory and store 
          // the result in the accumulator
          when (tStateCount.value === 0.U) {
            // take accumulator as op1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // get value from memory
            bus := instruction.operands(1)
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // take value from memory as op2
            dataEn := true.B
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // send subSig
            divSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 4.U) {
            // store result in accumulator
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(DIVC) {
          // DIVC routine
          // subtract from the accumulator the selected value from memory and store 
          // the result in the accumulator
          when (tStateCount.value === 0.U) {
            // take accumulator as op1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // get value from memory
            bus := instruction.operands(1)
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // send subSig
            divSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // store result in accumulator
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(MOD) {
          // MOD routine
          // modulo the two regs and store the result in the first reg
          when (tStateCount.value === 0.U) {
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // take register as op2
            switch (instruction.operands(1)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // send modSig
            modSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // store result in first reg
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(MODI) {
          // SUBI routine
          // subtract from the accumulator the selected value from memory and store 
          // the result in the accumulator
          when (tStateCount.value === 0.U) {
            // take accumulator as op1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // get value from memory
            bus := instruction.operands(1)
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // take value from memory as op2
            dataEn := true.B
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // send subSig
            modSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 4.U) {
            // store result in accumulator
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(MODC) {
          // MODC routine
          // subtract from the accumulator the selected value from memory and store 
          // the result in the accumulator
          when (tStateCount.value === 0.U) {
            // take accumulator as op1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // get value from memory
            bus := instruction.operands(1)
            op2Load := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 2.U) {
            // send subSig
            modSig := true.B
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 3.U) {
            // store result in accumulator
            resultEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(JMP) {
          // JMP routine
          // change value of instruction pointer
          op1En := true.B
          instructionPointerReg := bus
          currentState := FETCH
        }
        is(JZ) {
          // JZ routine
          // check the zero flag; if it is set, jump to the specified label (address)
          when (zeroFlag) {
            op1En := true.B
            instructionPointerReg := bus
          }
          currentState := FETCH
        }
        is(JNZ) {
          // JNZ routine
          // check the zero flag; if it isn't set, jump to the specified label (address)
          when (!zeroFlag) {
            op1En := true.B
            instructionPointerReg := bus
          }
          currentState := FETCH
        }
        is(CMP) {
          // CMP routine
          // check if the two operands are equal; if yes, set the zero flag
          when (tStateCount.value === 0.U) {
            // load first register into operand 1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 1.U) {
            // load second register into operand 2
            switch (instruction.operands(1)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op2Load := true.B
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(PUSH) {
          // PUSH routine
          // push a new value to the stack, basically move the variable inside
          // the scope of the function
          when (tStateCount.value === 0.U) {
            // Step 1: Store op1 in MDR
            switch (instruction.operands(0)) {
              is (REG_A) {
                mdr := aReg
              }
              is (REG_B) {
                mdr := bReg
              }
              is (REG_C) {
                mdr := cReg
              }
            }
            tStateCount.inc()
          } . elsewhen (tStateCount.value === 1.U) {
            // Step 2: Write to address
            bus := stackPointerReg
            writeEn := true.B
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 2.U) {
            // Decrease stack pointer
            stackPointerReg := stackPointerReg - 1.U
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(POP) {
          // POP routine
          // remove top value of stack into the register
          when (tStateCount.value === 0.U) {
            // increase stack pointer (to point to the last value on the stack)
            stackPointerReg := stackPointerReg + 1.U
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 1.U) {
            // get value at stack pointer
            bus := stackPointerReg
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 2.U) {
            // put value into register
            dataEn := true.B
            switch (instruction.operands(0)) {
              is (REG_A) {
                aReg := bus
              }
              is (REG_B) {
                bReg := bus
              }
              is (REG_C) {
                cReg := bus
              }
            }
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(NOP) {
          // NOP routine (make it so that we can NOP n cycles?)
          currentState := FETCH
        }
        is(CALL) {
          // CALL routine
          // push the instruction pointer to the stack and jump to specified location
          when (tStateCount.value === 0.U) {
            // load ip into MDR
            mdr := instructionPointerReg
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 1.U) {
            // write ip to sp address
            bus := stackPointerReg
            writeEn := true.B
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 2.U) {
            // decrease sp
            stackPointerReg := stackPointerReg - 1.U
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 3.U) {
            // jump to specified location
            op1En := true.B
            instructionPointerReg := bus
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(RET) {
          // RET routine
          // pop the stack to the instruction pointer
          when (tStateCount.value === 0.U) {
            // increase stack pointer (to point to the last value on the stack)
            stackPointerReg := stackPointerReg + 1.U
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 1.U) {
            // get value at stack pointer
            bus := stackPointerReg
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 2.U) {
            // put value into ip
            dataEn := true.B
            instructionPointerReg := bus
            tStateCount.reset()
            currentState := FETCH
          }
        }
        is(HLT) {
          // HLT routine
          // stops the program
          currentState := HALT
        }
        is(CMPC) {
          // CMPC routine
          // check if the two operands are equal; if yes, set the zero flag
          when (tStateCount.value === 0.U) {
            // load first register into operand 1
            switch (instruction.operands(0)) {
              is (REG_A) {
                bus := aReg
              }
              is (REG_B) {
                bus := bReg
              }
              is (REG_C) {
                bus := cReg
              }
            }
            op1Load := true.B
            tStateCount.inc()
          } .elsewhen (tStateCount.value === 1.U) {
            // load constant into operand 2
            bus := instruction.operands(1)
            op2Load := true.B
            tStateCount.reset()
            currentState := FETCH
          }
        }
      }
    }
    is(HALT) {
      // radio silence
      // stop the clock?
      finishedReg := true.B
    }
  }

  io.finished := finishedReg

  // signals that are sent from the processor to the rest of the components
  // instructionPointer.io.ipLoad := ipLoad
  // instructionPointer.io.ipInc := ipInc
  ram.io.writeEn := writeEn
  ram.io.dataIn := mdr
  // accumulator.io.accLoad := accLoad
  // bRegister.io.bLoad := bLoad
  // cRegister.io.cLoad := cLoad
  alu.io.op1Load := op1Load
  alu.io.op2Load := op2Load
  alu.io.addSig := addSig
  alu.io.subSig := subSig
  alu.io.mulSig := mulSig
  alu.io.divSig := divSig
  alu.io.modSig := modSig
  alu.io.incSig := incSig
  alu.io.decSig := decSig
  // stackPointer.io.spDec := spDec
  // stackPointer.io.spInc := spInc

  // tie all component inputs to bus
  // instructionPointer.io.cntIn := bus // will take value ONLY when ipLoad is true
  // ram.io.dataIn := bus
  ram.io.addrIn := bus
  // accumulator.io.accIn := bus
  // bRegister.io.bIn := bus
  // cRegister.io.cIn := bus
  alu.io.op1In := bus
  alu.io.op2In := bus

  // tie flags directly to their module counterparts
  zeroFlag := alu.io.zeroFlag
  carryFlag := alu.io.carryFlag

  // ENABLE - read from component, write to bus
  // when (ipEn) {
  //   bus := instructionPointer.io.cntOut
  // } 
  when (dataEn) {
    bus := ram.io.dataOut
  }
  // when (accEn) {
  //   bus := accumulator.io.accOut
  // }
  when (op1En) {
    bus := instruction.operands(0)
  }
  when (op2En) {
    bus := instruction.operands(1)
  }
  // when (bEn) {
  //   bus := bRegister.io.bOut
  // }
  // when (cEn) {
  //   bus := cRegister.io.cOut
  // }
  when (resultEn) {
    bus := alu.io.resultOut
  }
  // when (spEn) {
  //   bus := stackPointer.io.spOut
  // }
}

/**
 * An object extending App to generate the Verilog code.
 */
object ProcessorMain extends App {
  println("generating Verilog file for Processor")
  emitVerilog(new Processor())
}
