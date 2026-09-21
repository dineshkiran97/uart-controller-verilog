# UART Controller in Verilog

A modular Universal Asynchronous Receiver-Transmitter (UART) design.

## Day 1: Baud Rate Generator
- **Module:** `rtl/uart_baud_gen.v`
- **Function:** Generates tick pulses for clock division to set standard baud rates.

## Day 2: UART Transmitter
- **Module:** `rtl/uart_tx.v`
- **Function:** Implements the FSM (IDLE, START, DATA, STOP) and shift register to transmit 8-bit serial data.

## Day 3: UART Receiver
- **Module:** `rtl/uart_rx.v`
- **Function:** Implements 16x oversampling for start-bit detection, mid-bit sampling, and serial-to-parallel conversion.
