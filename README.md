# LO-RISC: Learning Optimized Reduced Instruction Set Computer

**LO-RISC** (Learning Optimized Reduced Instruction Set Computer) is a minimal Instruction Set Architecture (ISA) developed for speed, simplicity, and educational purposes. Designed as a COA Lab Final Project by Raaja Das and Priyanshu Gaurav, LO-RISC emphasizes a streamlined, efficient approach to basic computation.

## Project Overview

LO-RISC is a minimalistic Instruction Set Architecture (ISA) designed for simplicity and performance. Developed as part of a Computer Architecture Lab project, this ISA focuses on a streamlined instruction set to enable efficient processing within a small hardware footprint. The LO-RISC system incorporates a CPU built on the Von Neumann architecture, featuring 4 KB shared memory, essential arithmetic and logic operations, and a specialized UART module for input/output.

## Features

- **32-bit Instruction Format**: Each instruction consists of 8 hexadecimal, 4-bit chunks, totaling 32 bits. This compact format enhances processing speed.
- **Simplified Data Path**: Utilizes a 32-bit address and data bus with essential control signals, supporting memory and device interfacing.
- **UART I/O Module**: Designed for serial communication with configurable commands, supporting ASCII and decimal data exchange.
- **Basic Assembly Support**: Custom assembly language with data and instruction sections, compatible with various data types and operations.
- **System Monitor (Dasmon)**: Inspired by Wozmon, this monitor software allows program loading, memory inspection, and debugging.
- **Python-Based Assembler**: Converts assembly code into machine code, compatible with LO-RISC for program execution.

## Getting Started

### Prerequisites

1. **Vivado or other suitable Verilog Environment**: Required to simulate and generate bitstream for LO-RISC Verilog code.
2. **Nexys A7 or Nexys 4 DDR FPGA**: Required for deploying the LO-RISC CPU to actual hardware.
3. **Serial Terminal Software**: Tera Term or Minicom. Recommended settings for Tera Term is available in `Programs/system`.
4. **Python 3.x**: To run the assembler for converting LO-RISC assembly into machine code.

### Installation

1. Clone the repository.
   ```bash
   git clone https://github.com/username/LO-RISC.git
   cd LO-RISC
   ```
   
3. Upload the bitsteam in `Programs/system/dasmon.bit` OR flash the binary `Programs/system/dasmon.bit` to the FPGA through Vivado.

4. Set up a serial terminal software (e.g., Tera Term) and configure it to the recommended settings in `Programs/system`.

5. Dasmon welcome message shold be printed on the serial terminal after pressing the CPU reset button on the FPGA board.

### Usage

1. **Assembly Code Compilation**:
   - Write LO-RISC assembly code in a `.s` file.
   - Run the assembler to compile your assembly file:
     ```bash
     python Programs/source/asm.py program.s
     ```
   - The output machine code will be saved in `program.out`.

2. **Loading Programs on LO-RISC**:
   - Copy the machine code from `program.out` into the serial terminal to load it into the LO-RISC memory.
   - Press `Shift+R` in Dasmon to run the loaded program.

## Details

For a complete guide on the instruction set, data path, Assembly and Dasmon system monitor, please refer to the documentation provided in the LO-RISC.pdf file.
