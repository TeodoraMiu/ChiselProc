import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest.simulator.WriteVcdAnnotation

class RAMSpec extends AnyFlatSpec with ChiselScalatestTester {

  "RAM" should "pass" in {
    test(new RAM()).withAnnotations(Seq(WriteVcdAnnotation)){ dut =>
        // RAM initialization test
        // dut.io.addrLoad.poke(true)
        // dut.io.addrIn.poke(0)
        // dut.clock.step()
        // dut.io.dataOut.expect(0) // data at addr 0 is 0
        // // RAM write enable test
        // dut.io.addrLoad.poke(false)
        // dut.io.dataIn.poke(5)
        // dut.io.dataLoad.poke(true) // dataReg will have value 5
        // dut.clock.step()
        // dut.io.dataOut.expect(5) // data at addr 0 is now 5 (written)
        // RAM write disable test
        // dut.io.dataIn.poke(10)
        // dut.io.dataLoad.poke(false)
        // dut.clock.step()
        // dut.io.dataOut.expect(5)
        // RAM read test
        // dut.io.addrLoad.poke(true)
        // dut.io.addrIn.poke(254)
        // dut.clock.step()
        // dut.io.dataOut.expect(0)
        // // RAM read test with written value
        // dut.io.addrIn.poke(0)
        // dut.clock.step()
        // dut.io.dataOut.expect(5)
    }
  }
}

