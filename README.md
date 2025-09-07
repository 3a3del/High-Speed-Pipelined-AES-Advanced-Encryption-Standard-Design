# High-Speed-Pipelined-AES-Advanced-Encryption-Standard-Design

High Speed Pipelined AES (Advanced Encryption Standard) Design featuring a 40-stage pipelined architecture.

## Project Overview

This repository contains the design, verification, FPGA implementation, and ASIC synthesis files for a high-speed pipelined Advanced Encryption Standard (AES) encryption core. The design features a 40-stage pipelined architecture, optimized for high throughput and operating frequency.

## Key Features

*   **High-Speed Pipelined Architecture**: 40-stage pipeline enabling high throughput.
*   **Modular RTL Design**: Implemented in Verilog with well-defined submodules for AES operations (SubBytes, ShiftRows, MixColumns, AddRoundKey) and Key Expansion.
*   **Comprehensive Verification**: Submodule and top-level testbenches ensuring functional correctness.
*   **Static Verification (Linting)**: Passed Synopsys SpyGlass linting without violations, ensuring clean and synthesis-friendly RTL.
*   **FPGA Implementation**: Successfully implemented on Xilinx Virtex-7 FPGA (xc7vx485tffg1157-2L) at 100 MHz.
*   **ASIC Synthesis**: Synthesized with Synopsys Design Compiler 2018, targeting 1 GHz operation.

## Design Flow

### 1. RTL Design

The AES encryption core is designed in Verilog, following a 40-stage pipelined architecture. Key modules include:

*   `AES_Encryption.v`: Top-level module.
*   `DFF_128.v`: 128-bit D-flip-flop for pipelining.
*   `KeyExpansion.v`: Generates round keys.
*   `Sbox.v`: Implements the AES S-box.
*   `shiftrows.v`: Performs ShiftRows transformation.
*   `mixcolumns.v`: Performs MixColumns transformation.
*   `roundkey.v`: Performs AddRoundKey transformation.
*   `subbytes.v`: Applies S-box to each byte.

### 2. Verification

Verification was performed at two levels:

*   **Submodule Verification**: Dedicated testbenches for `KeyExpansion`, `mixcolumns`, `roundkey`, `shiftrows`, and `subbytes`.
*   **Top-Level Verification**: Comprehensive testbench (`AES_Encryption_tb.sv`) for the integrated `AES_Encryption` module.

Static verification (linting) using Synopsys SpyGlass confirmed the RTL design's adherence to coding standards and synthesis guidelines.

### 3. FPGA Implementation

The design was implemented on a Xilinx Virtex-7 FPGA (xc7vx485tffg1157-2L) using `cons.xdc` constraints. Key results:

*   **Achieved Frequency**: 100 MHz
*   **Timing**: All user-specified timing constraints met (WNS = 0.557 ns).
*   **Utilization**: Low resource usage (3.27% LUTs, 1.05% FFs).
*   **Power**: Total On-Chip Power of 0.779 W.

### 4. ASIC Synthesis

The design was synthesized using Synopsys Design Compiler 2018 with `cons_v2.tcl` constraints, targeting 1 GHz operation. Key results:

*   **Target Frequency**: 1 GHz
*   **Timing**: Setup constraints met (WNS = 0.00 ns). Note: Hold violations were observed and would require further physical design steps to resolve.
*   **Area**: Total Cell Area of 39,514.40 µm².
*   **Power**: Total Power of 46.45 mW.

## Performance Summary

### FPGA Implementation Performance

| Metric          | Value        |
| :-------------- | :----------- |
| **Clock Frequency** | 100 MHz      |
| **Latency**     | 400 ns       |
| **Throughput**  | 12.8 Gbps    |
| **LUTs**        | 9913         |
| **FFs**         | 6400         |
| **Total Power** | 0.779 W      |

### ASIC Synthesis Performance

| Metric          | Value        |
| :-------------- | :----------- |
| **Clock Frequency** | 1 GHz        |
| **Latency**     | 40 ns        |
| **Throughput**  | 128 Gbps     |
| **Area**        | 39,514.40 µm²|
| **Power**       | 46.45 mW     |

