import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class InstructionPointerSpec extends AnyFlatSpec with ChiselScalatestTester {

  "InstructionPointer" should "pass" in {
    test(new InstructionPointer()).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // TEST CASE 1: Initial counter should be 0
      dut.io.cntOut.expect(0)

      // TEST CASE 2: Counter should be incremented
      dut.io.ipInc.poke(true)
      dut.clock.step()
      dut.io.cntOut.expect(1)

      // TEST CASE 3: Counter should not be incremented
      dut.io.ipInc.poke(false)
      dut.clock.step()
      dut.io.cntOut.expect(1)

      // TEST CASE 4: Counter should be incremented
      dut.io.ipInc.poke(true)
      dut.clock.step()
      dut.io.cntOut.expect(2)

      // TEST CASE 5: Counter should not be modified
      dut.io.ipInc.poke(false)
      dut.io.cntIn.poke(5)
      dut.clock.step()
      dut.io.cntOut.expect(2)
      
      // TEST CASE 6: Counter should be modified
      dut.io.ipLoad.poke(true)
      dut.clock.step()
      dut.io.cntOut.expect(5)
    }
  }
}

