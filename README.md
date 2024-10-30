# LO-RISC: Learning Optimized Reduced Instruction Set Computer

LO-RISC (Learning Optimized Reduced Instruction Set Computer) is a minimal Instruction Set Architecture (ISA) designed for speed, simplicity, and educational use. LO-RISC offers a reduced set of instructions, focusing on fast execution and ease of understanding, making it ideal for learning about computer architecture, assembly programming, and systems software development.

This repository contains:
1. The full implementation of the LO-RISC architecture.
2. Supporting system software, including an assembler, linker, and basic runtime.

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Architecture Details](#architecture-details)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Usage](#usage)
- [Assembler and System Software](#assembler-and-system-software)
- [Contributing](#contributing)
- [License](#license)

## Project Overview
LO-RISC is designed as a lightweight ISA for students, educators, and enthusiasts exploring the fundamentals of computer architecture. It focuses on providing a minimal yet functional set of instructions to carry out basic computational tasks with high efficiency. This project is suitable for exploring:
- Low-level programming concepts
- The workings of a CPU
- Assembly language and instruction set design

## Features
- **Minimal Instruction Set**: LO-RISC is built with simplicity in mind, with only essential instructions for arithmetic, logical operations, branching, and data manipulation.
- **Lightweight Implementation**: The project includes a Verilog implementation of LO-RISC, designed for ease of understanding and modification.
- **System Software**: Includes an assembler, linker, and basic runtime environment to support code generation and execution.
- **Educational Focus**: The project is designed to illustrate fundamental concepts in CPU design and low-level programming.

## Architecture Details
LO-RISC follows a basic, efficient structure:
- **Register File**: A small set of general-purpose registers for quick access.
- **Instruction Types**: Arithmetic, logical, branch, load/store, and move instructions.
- **Fixed Instruction Size**: Each instruction is a fixed 32-bit word, simplifying decoding and pipeline implementation.

## Getting Started
To get started with LO-RISC, you can either run the provided simulation environment (using Verilog simulators like ModelSim or Vivado) or deploy the design on an FPGA. 

### Prerequisites
- **Verilog Simulator** (ModelSim, Vivado, or similar) for testing the Verilog code.
- **Python 3.x** for running system software tools.
- **Git** for cloning the repository.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/lo-risc.git
   cd lo-risc
