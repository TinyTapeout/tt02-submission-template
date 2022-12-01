// See README.md for license details.

package gcd

import chisel3._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec
import chisel3.experimental.BundleLiterals._

class ScanTester(factory : () => Scan) extends AnyFreeSpec with ChiselScalatestTester {

  "Gcd should calculate proper greatest common denominator" in {
    test(new Scan(8)) { dut =>
      dut.reset.poke(true.B)
      dut.io.ld.poke(false.B)
      dut.clock.step()

      dut.io.done.expect(true.B)

      dut.reset.poke(false.B)
      dut.io.ld.poke(true.B)

      val n = dut.n

      val u = BigInt(10)
      val v = BigInt( 5)

      for {k <- 0 until n} {
        val u_bit = (u & (BigInt(1)<<(n-1-k))) != 0
        val v_bit = (v & (BigInt(1)<<(n-1-k))) != 0
        println(s"scanin $k ${u_bit} ${v_bit}")

        dut.io.u_bit.poke(u_bit.B)
        dut.io.v_bit.poke(v_bit.B)
        dut.clock.step()
        println(s"scanin $k ${dut.io.u.peek()} ${dut.io.v.peek()}")
      }

      dut.io.ld.poke(false.B)

      while (!dut.io.done.peek().litToBoolean) {
        dut.clock.step()
      }

      dut.io.ld.poke(true.B)

      for {k <- 0 until n} {
        println(s"$k ${dut.io.z_bit.peek().litToBoolean}")
        dut.clock.step()
      }

    }
  }
}

class ScanTest8 extends ScanTester(() => new Scan(8))
