import chisel3._

class InstructionPointer extends Module {
  val io = IO(new Bundle {
    val ipLoad = Input(Bool())
    val ipInc = Input(Bool())
    val cntIn = Input(UInt(8.W))
    val cntOut = Output(UInt(8.W))
  })
  val cntReg = RegInit(0.U(8.W))

  when (io.ipInc) {
    cntReg := cntReg + 1.U
  }

  when (io.ipLoad) {
    cntReg := io.cntIn
  }

  io.cntOut := cntReg
}

/**
 * An object extending App to generate the Verilog code.
 */
object InstructionPointerMain extends App {
  println("Generating Verilog file for InstructionPointer")
  emitVerilog(new InstructionPointer())
}
