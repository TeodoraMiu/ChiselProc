import chisel3._

class CRegister extends Module {
    val io = IO(new Bundle {
        val cLoad = Input(Bool())
        val cIn = Input(UInt(8.W))
        val cOut = Output(UInt(8.W))
    })
    val cReg = RegInit(0.U(8.W))

    when (io.cLoad) {
        cReg := io.cIn
    }

    io.cOut := cReg
}

/**
 * An object extending App to generate the Verilog code.
 */
object CRegisterMain extends App {
  println("Generating Verilog file for CRegister")
  emitVerilog(new CRegister())
}