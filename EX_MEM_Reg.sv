// EX/MEM Register
module EX_MEM(
    input logic clk,
    input logic reset,
    input logic [2:0] func3_in,
    input logic [1:0] wb_sel_in,
    input logic [31:0] pc_in,
    input logic [31:0] alu_result_in,
    input logic [31:0] reg_data2_in,
    input logic [4:0] rd_in,
    input logic mem_read_in, mem_write_in, reg_write_in, mem_to_reg_in,
    output logic [31:0] alu_result_out,
    output logic [31:0] reg_data2_out,
    output logic [4:0] rd_out,
    output logic [2:0] func3_out,
    output logic [1:0] wb_sel_out,
    output logic [31:0] pc_out,
    output logic mem_read_out, mem_write_out, reg_write_out, mem_to_reg_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out <= 32'b0;
            reg_data2_out <= 32'b0;
            rd_out <= 5'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
        end else begin
            alu_result_out <= alu_result_in;
            reg_data2_out <= reg_data2_in;
            rd_out <= rd_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            pc_out<=pc_in;
            func3_out<=func3_in;
            wb_sel_out<=wb_sel_in;
        end
    end
endmodule