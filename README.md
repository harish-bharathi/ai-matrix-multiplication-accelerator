# 🚀 AI Matrix Multiplication Accelerator (SystemVerilog)

A high-performance hardware accelerator designed to perform 4x4 signed matrix multiplication, optimized for Artificial Intelligence and Deep Learning workloads. This design leverages advanced digital logic techniques to maximize throughput and minimize area.



## 🛠️ Architectural Features

### 1. Radix-4 Booth Multiplier
The core multiplication engine uses **Radix-4 Booth Encoding**. 
- **Efficiency:** Reduces the number of partial products by 50% compared to standard multipliers.
- **Performance:** Significantly lowers the total gate count and propagation delay, making it ideal for high-speed AI inference hardware.

### 2. Pipelined MAC (Multiply-Accumulate) Unit
The Processing Elements (PEs) are structured in a parallel architecture:
- **Streaming Logic:** Data flows from memory into a pipelined MAC unit.
- **Latency Management:** Implements a 9-cycle pipeline to stabilize and register outputs before final storage.

### 3. Modular Memory Subsystem
- **Memory A:** Optimized for row-wise data delivery.
- **Memory B:** Specialized module to hold the full weight matrix for reuse, reducing unnecessary data movement.

## 📊 Simulation & Verification
The design was fully verified using a SystemVerilog testbench in **Xilinx Vivado**.

### Waveform Analysis
The simulation confirms the 9-cycle latency and the functional accuracy of the Booth-encoded multiplication.

![Simulation Waveform](simulation_waveform.png)

## 📁 Repository Structure
- `booth.sv`: Implementation of Radix-4 Booth Encoding.
- `mul.sv`: Intermediate multiplier module.
- `pe.sv`: Processing Element for dot-product calculation.
- `mac.sv`: Row-wise MAC controller.
- `top_module.sv`: Top-level integration and control logic.
- `tb_top.sv`: Complete verification testbench.

## 🔬 Tech Stack
- **HDL:** SystemVerilog / Verilog
- **Tools:** Xilinx Vivado (Synthesis & Simulation)
- **Target:** FPGA/ASIC Synthesizable RTL
