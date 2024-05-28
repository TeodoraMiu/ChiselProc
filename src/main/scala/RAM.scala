import chisel3._
import chisel3.util.experimental.loadMemoryFromFileInline
import firrtl.annotations.MemoryLoadFileType

class RAM() extends Module {
  val io = IO(new Bundle {
    val writeEn = Input(Bool())
    val addrIn = Input(UInt(8.W))
    val dataIn = Input(UInt(8.W))
    val dataOut = Output(UInt(8.W))
  })

  val mem = SyncReadMem(256, UInt(8.W))

  val mdr = RegInit(0.U(8.W))

  loadMemoryFromFileInline(mem, "program.bin", MemoryLoadFileType.Binary)

  when (io.writeEn) {
    mem.write(io.addrIn, io.dataIn)
  }

  io.dataOut := mem.read(io.addrIn)
}

/**
 * An object extending App to generate the Verilog code.
 */
object RAMMain extends App {
  println("Generating Verilog file for RAM")
  emitVerilog(new RAM())
}
