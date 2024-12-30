module processor(
     input logic clk,
     input logic rst
);

    logic [31:0] pc_out;
    logic [31:0] inst;
    logic [6:0] opcode;
    logic [2:0] func3;
    logic [6:0] func7;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;
    logic [31:0] rdata1;
    logic [31:0] rdata2;
    logic [31:0] wdata;
    logic        rf_en;
    logic [3:0] aluop;
    logic imm_en;
 //   logic shift_en;
    logic [11:0] imm;
   // logic [4:0] shamt;
    logic [31:0] sign_extended_imm;
    logic [31:0] opr_a;
    logic [31:0] opr_b;
    logic [31:0] opr_res;
    logic [31:0] rdata;  //data read from data mem
    logic dm_rd;
    logic dm_wr;
    logic [1:0] wb_sel;
    logic sel_a;

    logic br_taken;
    logic j_en;
    logic [31:0] next_pc;
    logic [31:0] rdata_from_csr_file;
    logic csr_rd;
    logic csr_wr;
    logic is_mret;
    logic trap;
    logic [31:0] epc;
    logic epc_taken;

    // Wires for IF/ID Pipeline Register
logic [31:0] instr_if_id;
logic [31:0] pc_if_id, pc_ex_mem, pc_mem_wb;

// Wires for ID/EX Pipeline Register
logic [31:0] reg_data1_id_ex;
logic [31:0] reg_data2_id_ex;
logic [31:0] sign_ext_id_ex;
logic [31:0] pc_id_ex;
logic [4:0] rs_id_ex;
logic [4:0] rt_id_ex;
logic [4:0] rd_id_ex;
logic [3:0] alu_ctrl_id_ex;
logic [2:0] func3_out_id_ex, func3_out_ex_mem;
logic mem_read_id_ex;
logic mem_write_id_ex;
logic reg_write_id_ex;
logic mem_to_reg_id_ex;
logic [1:0] wb_sel_out_id_ex;
logic [1:0] wb_sel_out_ex_mem;
logic [1:0] wb_sel_out_mem_wb;
// Wires for EX/MEM Pipeline Register
logic [31:0] alu_result_ex_mem;
logic [31:0] reg_data2_ex_mem;
logic [4:0] rd_ex_mem;
logic mem_read_ex_mem, mem_write_ex_mem, reg_write_ex_mem, mem_to_reg_ex_mem;


// Wires for MEM/WB Pipeline Register
logic [31:0] mem_data_mem_wb;
logic [31:0] alu_result_mem_wb;
logic [4:0] rd_mem_wb;
logic reg_write_mem_wb;
logic mem_to_reg_mem_wb;

    //Program Counter instance
    pc pc_inst(
        .clk (clk),
        .rst (rst),
        .pc_in(next_pc),
        .pc_out(pc_out)
    );

    inst_mem imem(
        .addr(pc_out),
        .data(inst)
    );

    inst_dec inst_instance 
    (
        .inst (instr_if_id),
        .rs1 (rs1),
        .rs2 (rs2),
        .rd  (rd),
        .opcode (opcode),
        .func3 (func3),
        .func7 (func7)
    );

    reg_file reg_file_inst
    (
        .rs1 (rs1),
        .rs2 (rs2),
        .rd (rd_mem_wb),
        .rf_en (rf_en),
        .clk (clk),
        .rdata1 (rdata1),
        .rdata2 (rdata2),
        .wdata (wdata)

    );

    controller contr_inst
    (
        .opcode (opcode),
        .func3 (func3),
        .func7 (func7),
        .aluop (aluop),
        .rf_en (rf_en),
        .imm_en(imm_en),
        .dm_rd(dm_rd),
        .dm_wr(dm_wr),
        .sel_a(sel_a),
        .wb_sel(wb_sel),
        .j_en(j_en),
        .csr_rd(csr_rd),
        .csr_wr(csr_wr),
        .is_mret(is_mret),
        .trap(trap)
       // .shift_en(shift_en)
    );

    alu alu_inst 
    (
        .opr_a (opr_a),
        .opr_b (opr_b),
        .aluop (alu_ctrl_id_ex),
        .opr_res (opr_res)
    );

    immediate_generator immediate_generator_inst
    (
        .inst(inst),
        .sign_extended_imm(sign_extended_imm),
        .func3(func3),
        .opcode(opcode)
       // .shamt(shamt)
    );

    //not using sign extend anymore, extension done directly in imm generator
    // sign_extend sign_extend_inst(
    //     .imm(imm),
    //     .sign_extended_imm(sign_extended_imm)
    // );

    multiplexer_b multiplexer_b_inst(
        .sign_extended_imm(sign_ext_id_ex),
        .imm_en(imm_en),
        .rdata2(reg_data2_id_ex),
     //   .shamt(shamt),
     //   .shift_en(shift_en),
        .opr_b(opr_b)
    );

    data_mem data_mem_inst (
        .addr(alu_result_ex_mem),
        .wdata(reg_data2_ex_mem),
        .rdata(rdata),
        .clk(clk),
        .func3(func3_out_ex_mem),
        .dm_rd(mem_read_ex_mem),
        .dm_wr(mem_read_ex_mem)
    );

    multiplexer_writeback multiplexer_writeback_inst (
        .rdata_from_datamem(mem_data_mem_wb),
        .wdata_from_alu(alu_result_mem_wb),
        .wdata(wdata),
        .wb_sel(wb_sel_out_mem_wb),
        .pc(pc_mem_wb),
        .rdata_from_csr_file(rdata_from_csr_file)
    );

    multiplexer_a multiplexer_a_inst(
        .rdata1(reg_data1_id_ex),
        .pc_out(pc_id_ex),
        .sel_a(sel_a),
        .opr_a(opr_a)
    );

    multiplexer_pc multiplexer_pc_inst(
        .pc_out(pc_out),
        .addr_from_alu(alu_result_ex_mem),
        .br_taken(br_taken),
        .j_en(j_en),
        .next_pc(next_pc),
        .epc(epc),
        .epc_taken(epc_taken)
    );

    branch_cond branch_cond_inst(
        .rdata1(reg_data1_id_ex),
        .rdata2(reg_data2_id_ex),
        .func3(func3),
        .br_taken(br_taken)
    );

    CSR_register CSR_register_file_inst(
        .wdata(rdata1),
        .pc(pc_out),
        .inst(inst),
        .clk(clk),
        .rst(rst),
        .rdata(rdata_from_csr_file),
        .csr_rd(csr_rd),
        .csr_wr(csr_wr),
        .addr(pc_out),
        .is_mret(is_mret),
        .trap(trap),
        .epc(epc),
        .epc_taken(epc_taken)
    );
IF_ID if_id_inst(
    .clk(clk),
    .reset(rst),
    .instr_in(inst),
    .pc_in(pc_out),
    .instr_out(instr_if_id),
    .pc_out(pc_if_id)
);
ID_EX id_ex_inst(
    .clk(clk),
    .reset(rst),
    .reg_data1_in(rdata1),
    .reg_data2_in(rdata2),
    .sign_ext_in(sign_extended_imm),
    .pc_in(pc_if_id),
    .rs_in(rs1),
    .rt_in(rs2),
    .rd_in(rd),
    .func3_in(func3),
    .wb_sel_in(wb_sel),
    .alu_ctrl_in(aluop),
    .mem_read_in(dm_rd),
    .mem_write_in(dm_wr),
    .reg_write_in(rf_en),
    .mem_to_reg_in(wb_sel[0]),  // Assuming wb_sel[1] is for mem_to_reg
    .reg_data1_out(reg_data1_id_ex),
    .reg_data2_out(reg_data2_id_ex),
    .sign_ext_out(sign_ext_id_ex),
    .pc_out(pc_id_ex),
    .rs_out(rs_id_ex),
    .rt_out(rt_id_ex),
    .rd_out(rd_id_ex),
    .alu_ctrl_out(alu_ctrl_id_ex),
    .mem_read_out(mem_read_id_ex),
    .mem_write_out(mem_write_id_ex),
    .reg_write_out(reg_write_id_ex),
    .mem_to_reg_out(mem_to_reg_id_ex),
    .func3_out(func3_out_id_ex),
    .wb_sel_out(wb_sel_out_id_ex)
);

EX_MEM ex_mem_inst(
    .clk(clk),
    .reset(rst),
    .alu_result_in(opr_res),           // Output of ALU
    .reg_data2_in(reg_data2_id_ex),   // Second source operand from ID/EX
    .rd_in(rd_id_ex),       
    .func3_in(func3_out_id_ex),   
    .wb_sel_in(wb_sel_out_id_ex),       // Destination register from ID/EX
    .mem_read_in(mem_read_id_ex),     // Memory read control signal
    .mem_write_in(mem_write_id_ex),   // Memory write control signal
    .reg_write_in(reg_write_id_ex),   // Register write control signal
    .mem_to_reg_in(mem_to_reg_id_ex),
    .alu_result_out(alu_result_ex_mem),
    .reg_data2_out(reg_data2_ex_mem),
    .rd_out(rd_ex_mem),
    .mem_read_out(mem_read_ex_mem),
    .mem_write_out(mem_write_ex_mem),
    .reg_write_out(reg_write_ex_mem),
    .mem_to_reg_out(mem_to_reg_ex_mem),
    .pc_in(pc_id_ex),
     .pc_out(pc_ex_mem),
     .func3_out(func3_out_ex_mem),
     .wb_sel_out(wb_sel_out_ex_mem)
);

MEM_WB mem_wb_inst(
    .clk(clk),
    .reset(rst),
    .mem_data_in(rdata),
    .wb_sel_in(wb_sel_out_ex_mem),
    .alu_result_in(alu_result_ex_mem),
    .rd_in(rd_ex_mem),
    .reg_write_in(reg_write_ex_mem),
    .mem_to_reg_in(mem_to_reg_ex_mem),
    .mem_data_out(mem_data_mem_wb),
    .alu_result_out(alu_result_mem_wb),
    .rd_out(rd_mem_wb),
    .reg_write_out(reg_write_mem_wb),
    .mem_to_reg_out(mem_to_reg_mem_wb),
     .pc_in(pc_ex_mem),
     .pc_out(pc_mem_wb),
     .wb_sel_out(wb_sel_out_mem_wb)
);



endmodule
// pc in out
// func3
//wb_sel