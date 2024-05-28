import chisel3._

class BRegister extends Module {
    val io = IO(new Bundle {
        val bLoad = Input(Bool())
        val bIn = Input(UInt(8.W))
        val bOut = Output(UInt(8.W))
    })
    val bReg = RegInit(0.U(8.W))

    when (io.bLoad) {
        bReg := io.bIn
    }

    io.bOut := bReg
}

/**
 * An object extending App to generate the Verilog code.
 */
object BRegisterMain extends App {
  println("Generating Verilog file for BRegister")
  emitVerilog(new BRegister())
}