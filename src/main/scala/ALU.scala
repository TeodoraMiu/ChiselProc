import chisel3._

class ALU extends Module {
    val io = IO(new Bundle {
        val op1Load = Input(Bool())
        val op2Load = Input(Bool())
        val addSig = Input(Bool())
        val subSig = Input(Bool())
        val divSig = Input(Bool())
        val mulSig = Input(Bool())
        val modSig = Input(Bool())
        val incSig = Input(Bool())
        val decSig = Input(Bool())
        val op1In = Input(UInt(8.W))
        val op2In = Input(UInt(8.W))
        val resultOut = Output(UInt(8.W))
        val zeroFlag = Output(Bool())
        val carryFlag = Output(Bool())
    })
    val op1Reg = RegInit(0.U(8.W))
    val op2Reg = RegInit(0.U(8.W))
    val resultReg = RegInit(1.U(8.W)) // in case of a compare, I don't want the resultReg to be 0.
    val zeroFlagReg = RegInit(false.B)
    val carryFlagReg = RegInit(false.B)

    when (io.op1Load) {
        op1Reg := io.op1In
    }

    when (io.op2Load) {
        op2Reg := io.op2In
    }

    when (io.addSig) {
        resultReg := op1Reg + op2Reg
    }

    when (io.subSig) {
        resultReg := op1Reg - op2Reg
    }

    when (io.mulSig) {
        resultReg := op1Reg * op2Reg
    }

    when (io.divSig) {
        resultReg := op1Reg / op2Reg
    }

    when (io.modSig) {
        resultReg := op1Reg % op2Reg
    }

    when (io.incSig) {
        resultReg := op1Reg + 1.U
    }

    when (io.decSig) {
        resultReg := op1Reg - 1.U
    }

    when (resultReg === 0.U || op1Reg === op2Reg) {
        zeroFlagReg := true.B
    } .otherwise {
        zeroFlagReg := false.B
    }

    io.resultOut := resultReg
    io.zeroFlag := zeroFlagReg
    io.carryFlag := carryFlagReg
}

/**
 * An object extending App to generate the Verilog code.
 */
object ALUMain extends App {
  println("Generating Verilog file for ALU")
  emitVerilog(new ALU())
}