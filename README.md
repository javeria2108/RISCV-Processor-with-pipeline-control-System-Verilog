# RISC-V Pipelined Processor Implementation

Welcome to the repository for my **RISC-V Processor** implemented in **SystemVerilog**. 
## 📜 Features
- **Instruction Set Support**: Implements all RISC-V base instruction types:
  - **R**, **I**, **S**, **B**, **U**, and **J**
  - Includes support for **CSR (Control and Status Registers)**
- **Pipelined Architecture**: 
  - Adds pipelining registers for all five stages (Fetch, Decode, Execute, Memory, Writeback)
  - Optimized for improved performance and instruction throughput
- Modular Design:
  - Code is divided into separate modules for ease of readability and scalability.

## 🖼️ Datapath
The processor follows the standard 5-stage pipelined datapath:
1. **Fetch**: Fetches the instruction from memory.
2. **Decode**: Decodes the instruction and reads operands from the register file.
3. **Execute**: Executes the ALU operation or determines the branch condition.
4. **Memory**: Accesses the memory for load/store operations.
5. **Writeback**: Writes the results back to the register file.

## 🛠️ Files and Structure
The repository contains the following files:
- **`processor.sv`**: Top-level module that wires all the components together.

- **Pipelining Registers**:
  - `if_id_register.sv`
  - `id_ex_register.sv`
  - `ex_mem_register.sv`
  - `mem_wb_register.sv`
- **Control and Datapath Components**:
  - `alu.sv`
  - `controller.sv`
  - `immediate_generator.sv`
  - `reg_file.sv`
  - `data_mem.sv`

- **Testbenches**:
  - `processor_tb.sv`: Testbench for validating the functionality of the processor.

## 📚 How to Use
1. Clone the repository:
   ```bash
   git clone https://github.com/javeria2108/RISCV-Processor-with-pipeline-control-System-Verilog.git
   ```
2. Run the simulation using your preferred SystemVerilog simulator (e.g., ModelSim, VCS, or Verilator).
3. Load the testbench (processor_tb.sv) to verify functionality.
4. Modify or extend the modules to suit your requirements.
## 🚀 Future Improvements
Implement hazard detection and forwarding to handle pipeline hazards.
Add support for floating-point and additional RISC-V extensions.
Integrate more comprehensive test cases.
## 🏆 Acknowledgments
This project was developed as part of the Computer Architecture Lab course, instructed by Sir Afeef Obaid, whose guidance was invaluable throughout the journey.

## 🤝 Connect
Feel free to reach out for feedback or collaboration ideas! 😊



