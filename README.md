# LO-RISC: Learning Optimized Reduced Instruction Set Computer

**LO-RISC** (Learning Optimized Reduced Instruction Set Computer) is a minimal Instruction Set Architecture (ISA) developed for speed, simplicity, and educational purposes. Designed as a COA Lab Final Project by Raaja Das and Priyanshu Gaurav, LO-RISC emphasizes a streamlined, efficient approach to basic computation.

## Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Architecture Details](#architecture-details)
- [Software Components](#software-components)
- [Dasmon System Monitor](#dasmon-system-monitor)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)

## Project Overview
LO-RISC is designed to be a simple and optimized architecture that can be used for educational and learning purposes. It includes the following:
- A complete Verilog-based implementation of the CPU architecture
- System software, including an assembler, linker, and runtime monitor
- A minimal instruction set, facilitating a smooth learning curve for low-level computing concepts

## Features
- **Minimalistic ISA**: A reduced instruction set, focusing on essential operations for arithmetic, logic, memory access, and branching.
- **System Software**: Assembler and linker tools, enabling development in LO-RISC assembly.
- **Dasmon System Monitor**: A custom runtime monitor inspired by Wozmon, supporting memory inspection, program loading, and execution.
- **UART I/O Module**: Enables serial communication with external devices.

## Architecture Details
LO-RISC uses a Von Neumann architecture with shared instruction and data memory:
- **Memory**: 4 KB of system memory accessible over a 32-bit address/data bus.
- **Instruction Format**: Fixed 32-bit instructions, structured into 8, 4-bit hexadecimal fields, with various formats for immediate, branch, and register-based operations.
- **Registers**: General-purpose registers, including `$a` for arguments and `$fo` for function output.
- **Input/Output**: Serial communication is managed by a UART module at memory addresses 4096 and 4097.

### Sample Instructions
- **Arithmetic**: `ADD $1 $2 $3` (add registers `$2` and `$3`, store result in `$1`)
- **Shift**: `SLAI $5 $7 1` (left shift `$7` by 1, store in `$5`)
- **Load**: `LD $3 8($6)` (load from memory address `$6 + 8` into `$3`)
- **Branch**: `BR #10` (jump by offset 10 from the current PC)

For a full list, refer to the [Instruction Set](#) section of the project documentation.

## Software Components
The project includes an assembler and linker written in Python:
- **Assembler**: Converts LO-RISC assembly code into machine-readable binary.
- **Linker**: Links multiple object files and resolves labels for branches and jumps.
- **Executable Format**: The output is a hexadecimal file that can be directly loaded into a memory buffer for execution by Dasmon.

### For more information see LO-RISC Documentation
