import chisel3._

class StackPointer extends Module {
  val io = IO(new Bundle {
    val spDec = Input(Bool())
    val spInc = Input(Bool())
    val spOut = Output(UInt(8.W))
  })
  val spReg = RegInit(255.U(8.W))

  when (io.spDec) {
    spReg := spReg - 1.U
  }

  when (io.spInc) {
    when (spReg < 255.U) {
      spReg := spReg + 1.U
    } .otherwise {
      // throw an error here, need to see how; errorflags?
      // and HALT the program
      printf("Stack underflow!\n");
    }
  }

  io.spOut := spReg

  // need to check for stack overflow and underflow
}

/**
 * An object extending App to generate the Verilog code.
 */
object StackPointerMain extends App {
  println("Generating Verilog file for StackPointer")
  emitVerilog(new StackPointer())
}
