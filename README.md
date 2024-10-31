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

1. **Verilog Environment**: Required to simulate or deploy LO-RISC Verilog code.
2. **Serial Terminal Software**: Tera Term or Minicom with configurations available in `Programs/system`.
3. **Python 3.x**: To run the assembler for converting LO-RISC assembly into machine code.

### Installation

1. Clone the repository.
   ```bash
   git clone https://github.com/username/LO-RISC.git
   cd LO-RISC
   ```

2. Set up a serial terminal software (e.g., Tera Term) and configure it to the recommended settings in `Programs/system`.

### Usage

1. **Assembly Code Compilation**:
   - Write LO-RISC assembly code in a `.s` file.
   - Run the assembler to compile your assembly file:
     ```bash
     ./asm program.s
     ```
     or
     ```bash
     python Programs/source/asm.py program.s
     ```
   - The output machine code will be saved in `program.out`.

2. **Loading Programs on LO-RISC**:
   - Copy the machine code from `program.out` into the serial terminal to load it into the LO-RISC memory.
   - Press `Shift+R` in Dasmon to run the loaded program.

3. **System Monitor (Dasmon)**:
   - Run programs, inspect memory, and manage system state.
   - Dasmon provides various subroutine calls for operations like character/decimal printing, integer multiplication, and I/O.

## Details

### Instruction Set

LO-RISC supports a concise set of instructions divided into the following categories:

- **Arithmetic & Logic**: Basic operations like ADD, SUB, AND, OR, etc., with immediate addressing variations.
- **Load & Store**: Supports register-indexed 32-bit load and store operations.
- **Branching**: Branch instructions with conditional and unconditional jumps.
- **Register Transfer**: MOVE and conditional move (CMOV) instructions for register-to-register transfers.
- **Pseudo Instructions**: Includes pseudo instructions like `LA`, `LI`, and `JAL` for loading addresses, immediate values, and handling function calls.

### Data Path

The LO-RISC CPU uses a Von Neumann architecture with a shared memory model for instructions and data, supported by a 32-bit address/data bus and control signals for efficient component interconnect. A UART I/O module enables serial communication through reserved memory addresses, supporting ASCII and integer data exchange.

### Dasmon System Monitor

Dasmon, inspired by Wozmon, is a custom monitor software for the LO-RISC CPU, facilitating program loading and memory management. It supports subroutines for input and output operations, including ASCII character transmission, string handling, and integer operations.
