import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


lights_left = [0b000000, 0b001000, 0b011000, 0b111000, 0b000000]
lights_right = [0b000000, 0b000100, 0b000110, 0b000111, 0b000000]
lights_haz = [0b000000, 0b111111, 0b000000, 0b111111]

@cocotb.test()
async def thunderbird_taillight_tb(dut):
    HZ = 8
    SYSTEM_FREQ = 12500
    cycles = int(SYSTEM_FREQ / HZ)
    dut._log.info("cycles {}", cycles)

    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.right.value = 0
    dut.haz.value = 0
    dut.left.value = 0

    dut._log.info("reset")
    dut.rst.value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0

    dut._log.info("check all left sequence")
    for i in range(5):
        dut._log.info("check left light {}".format(i))
        await ClockCycles(dut.clk, cycles)
        assert int(dut.lights.value) == lights_left[i]
        dut.left.value = 1

    dut.left.value = 0

    dut._log.info("check all right sequence")
    for i in range(5):
        dut._log.info("check right light {}".format(i))
        await ClockCycles(dut.clk, cycles)
        assert int(dut.lights.value) == lights_right[i]
        dut.right.value = 1

    dut.right.value = 0
    dut._log.info("check all hazard sequence")
    for i in range(4):
        dut._log.info("check hazard light {}".format(i))
        await ClockCycles(dut.clk, cycles)
        assert int(dut.lights.value) == lights_haz[i]
        dut.haz.value = 1

    dut.haz.value = 0
