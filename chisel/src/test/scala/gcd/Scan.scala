// See README.md for license details.

package gcd

import chisel3._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec
import chisel3.experimental.BundleLiterals._

class ScanTester(factory : () => ScanIfc) extends AnyFreeSpec with ChiselScalatestTester {

  "Gcd should calculate proper greatest common denominator" in {
    test(factory()) { dut =>
      dut.reset.poke(true.B)
      dut.io.ld.poke(false.B)
      dut.clock.step()

      dut.io.done.expect(true.B)

      dut.reset.poke(false.B)
      dut.io.ld.poke(true.B)

      val n = dut.n

      def example(u : BigInt, v : BigInt): BigInt = {

        for {k <- 0 until n} {
          val u_bit = (u & (BigInt(1)<<(n-1-k))) != 0
          val v_bit = (v & (BigInt(1)<<(n-1-k))) != 0
          // println(s"scanin $k ${u_bit} ${v_bit}")

          dut.io.u_bit.poke(u_bit.B)
          dut.io.v_bit.poke(v_bit.B)
          dut.clock.step()
          // println(s"scanin $k ${dut.io.u.peek()} ${dut.io.v.peek()}")
        }

        dut.io.ld.poke(false.B)

        while (!dut.io.done.peek().litToBoolean) {
          dut.clock.step()
        }

        dut.io.ld.poke(true.B)

        var result = 0
        for {k <- 0 until n} {
          // println(s"$k ${dut.io.z_bit.peek().litToBoolean}")
          result = result << 1 | (if (dut.io.z_bit.peek().litToBoolean) 1 else 0)
          dut.clock.step()
        }

        println(s"u = $u v = $v result = $result")
        result

      }
      assert( example(10, 5) == 5)

      assert( example(3*4*5, 2*5) == 2*5)

      assert( example(3*7*11*64, 13*3*7*128) == 3*7*64)


    }
  }
}

class ScanTest32 extends ScanTester(() => new Scan(32))
class ScanBinaryTest32 extends ScanTester(() => new ScanBinary(32))
