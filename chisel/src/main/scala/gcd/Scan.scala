package gcd

import chisel3._

class Scan(val n : Int) extends Module {
  val io = IO(new Bundle {
    val ld = Input(Bool())
    val u_bit = Input(Bool())
    val v_bit = Input(Bool())
    val z_bit = Output(Bool())
    val done = Output(Bool())
 
    val u = Output(UInt(n.W))
    val v = Output(UInt(n.W))

  })

  val u = RegInit(0.U(n.W))
  val v = RegInit(0.U(n.W))

  io.u := u
  io.v := v

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
  printf("u=%x v=%x\n", u, v)
}

object MainScan extends App {
  emitVerilog(new Scan(32))
}
