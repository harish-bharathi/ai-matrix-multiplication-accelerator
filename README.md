# 🚀 AI Matrix Multiplication Accelerator (SystemVerilog)

This repository contains a fully synthesizable hardware accelerator designed to perform high-speed matrix multiplication, optimized for AI and Deep Learning workloads.

## 🏗️ Architecture Overview
The design utilizes a hierarchical approach to manage complexity and maximize throughput:
- **Math Engine:** Implements a Radix-4 Booth Multiplier to reduce partial products by 50%, saving area and power.
- **Computation:** Uses a parallel MAC (Multiply-Accumulate) structure for simultaneous dot-product calculations.
- **Memory Management:** Features dual memory modules (`mem_mod_a` and `mem_mod_b`) to provide a constant stream of data to the processing elements.

## 🛠️ Technical Specifications
- **Hardware Language:** SystemVerilog
- **Multiplication Logic:** Radix-4 Booth Encoding
- **Pipeline Latency:** 9-cycle stabilized output
- **Design Tool:** Xilinx Vivado

## 📁 Key Modules
- `top_module.sv`: Top-level integration and data routing.
- `booth.sv`: Core Radix-4 logic for optimized multiplication.
- `pe.sv`: Individual processing element for dot-product arithmetic.
