// ID/EX Register
module ID_EX(
    input logic clk,
    input logic reset,
    input logic [31:0] reg_data1_in,
    input logic [31:0] reg_data2_in,
    input logic [31:0] sign_ext_in,
    input logic [31:0] pc_in,
    input logic [2:0] func3_in,
    input logic [1:0] wb_sel_in,
    input logic [4:0] rs_in, rt_in, rd_in,
    input logic [3:0] alu_ctrl_in,
    input logic mem_read_in, mem_write_in, reg_write_in, mem_to_reg_in,
    output logic [31:0] reg_data1_out,
    output logic [31:0] reg_data2_out,
    output logic [31:0] sign_ext_out,
    output logic [31:0] pc_out,
    output logic [4:0] rs_out, rt_out, rd_out,
    output logic [3:0] alu_ctrl_out,
    output logic [2:0] func3_out,
    output logic [1:0 ]wb_sel_out,
    output logic mem_read_out, mem_write_out, reg_write_out, mem_to_reg_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_data1_out <= 32'b0;
            reg_data2_out <= 32'b0;
            sign_ext_out <= 32'b0;
            pc_out <= 32'b0;
            rs_out <= 5'b0;
            rt_out <= 5'b0;
            rd_out <= 5'b0;
            alu_ctrl_out <= 5'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
        end else begin
            reg_data1_out <= reg_data1_in;
            reg_data2_out <= reg_data2_in;
            sign_ext_out <= sign_ext_in;
            pc_out <= pc_in;
            rs_out <= rs_in;
            rt_out <= rt_in;
            rd_out <= rd_in;
            alu_ctrl_out <= alu_ctrl_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            func3_out<=func3_in;
            wb_sel_out<=wb_sel_in;
        end
    end
endmodule