import chisel3._

class Accumulator extends Module {
    val io = IO(new Bundle {
        val accLoad = Input(Bool())
        val accIn = Input(UInt(8.W))
        val accOut = Output(UInt(8.W))
    })
    val accReg = RegInit(0.U(8.W))

    when (io.accLoad) {
        accReg := io.accIn
    }

    io.accOut := accReg
}

/**
 * An object extending App to generate the Verilog code.
 */
object AccumulatorMain extends App {
  println("Generating Verilog file for Accumulator")
  emitVerilog(new Accumulator())
}