# UART Controller in Verilog

A modular Universal Asynchronous Receiver-Transmitter (UART) design.

## Project Structure
- **rtl/**: Core design modules (Baud rate generator, TX, RX, FIFO buffer)
- **tb/**: Testbenches and simulation verification

## Modules Overview
1. **Baud Rate Generator** (`uart_baud_gen.v`): Generates configurable tick pulses.
2. **UART Transmitter** (`uart_tx.v`): Implements FSM and shift register for serial data transmission.
3. **UART Receiver** (`uart_rx.v`): Features 16x oversampling and start-bit detection.
4. **FIFO Buffer** (`uart_fifo.v`): Manages data flow smoothly between clock domains/interfaces.
5. **Testbench** (`tb/uart_tb.v`): Validates end-to-end loopback and functionality.
