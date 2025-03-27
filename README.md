# Verilog Traffic Light Controller

A Finite State Machine (FSM) implementation of a traffic light controller for a highway and farm road intersection, designed for FPGA (Zybo Z7-10). This project includes sensor-based state transitions, synchronized resets, and timing control using Verilog.

## Overview
The traffic light controller manages signals for a highway and a farm road. The system:
- Prioritizes highway traffic by default.
- Activates farm road signals when a vehicle is detected (`farmSensor` input).
- Uses timed states for green, yellow, and red lights.
- Implements metastability prevention for asynchronous inputs.
- Simulated and tested on Vivado 2023.1.

## Project Structure
- **`tlc_controller.v`**: Top-level module integrating FSM, counter, and synchronizer.
- **`traffic_light_fsm.v`**: Finite State Machine (FSM) with 6 states and sensor-driven transitions.
- **`synchronizer.v`**: Metastability prevention for reset signal synchronization.
- **`tlc_fsm_tb.v`**: Testbench for simulating FSM behavior.
## Key Features
- **States**:
  - `S0`, `S3`: All red (1-second delay).
  - `S1`: Highway green (30 seconds), holds if no farm sensor activation.
  - `S2`, `S5`: Highway/Farm yellow (3 seconds).
  - `S4`: Farm green (3 seconds), extends if sensor remains active.
- **Clock**: 50 MHz (1 clock cycle = 20 ns).
- **Input Handling**: Synchronized reset and sensor input to prevent instability.

## Requirements
- **Hardware**: Zybo Z7-10 FPGA board.
- **Software**: Vivado 2023.1 (or compatible).
- **Constraints File**: `tlc_controller.xdc` (pin mappings for LEDs and sensors).

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/quickfire9/VerilogTrafficLight.git
