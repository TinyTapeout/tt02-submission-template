package gcd

import chisel3._

class ScanIfc(val n : Int) extends Module {
  val io = IO(new Bundle {
    val ld = Input(Bool())
    val u_bit = Input(Bool())
    val v_bit = Input(Bool())
    val z_bit = Output(Bool())
    val done = Output(Bool())
  })
}

class Scan(n : Int) extends ScanIfc(n) {
  val u = RegInit(0.U(n.W))
  val v = RegInit(0.U(n.W))

  io.z_bit := u(n-1)
  when (io.ld) {
    u := (u << 1) | io.u_bit
    v := (v << 1) | io.v_bit
  } .elsewhen (u > v) {
    u := u - v
  } .otherwise {
    v := v - u
  }

  io.done := v === 0.U
}

object MainScan extends App {
  emitVerilog(new Scan(32))
}




class ScanBinary(n : Int) extends ScanIfc(n) {
  def isEven( u : UInt, m : UInt) : Bool = (u & m) === 0.U
  def shiftRight( u : UInt, m : UInt) : UInt = ( u >> 1) & ~( m - 1.U)

  val u = RegInit(0.U(n.W))
  val v = RegInit(0.U(n.W))
  val m = RegInit(1.U(n.W))

  when( io.ld) {
    u := (u << 1) | io.u_bit
    v := (v << 1) | io.v_bit
  } .elsewhen ( io.done) {
  } .elsewhen ( isEven( u, m) && isEven( v, m)) {
    m := m << 1
  } .otherwise {
    val u0 = WireInit( u)
    val v0 = WireInit( v)

    when ( !isEven( u, m) && ( isEven( v, m) || v > u)) {
      u0 := v
      v0 := u
    }

    v := v0
    when ( isEven( u0, m)) {
      u := shiftRight( u0, m)
    } .otherwise {
      u := shiftRight( u0-v0, m)
    }
  }

  io.z_bit := u(n-1)
  io.done := u === v || v === 0.U
}

object MainScanBinary extends App {
  emitVerilog(new ScanBinary(32))
}
