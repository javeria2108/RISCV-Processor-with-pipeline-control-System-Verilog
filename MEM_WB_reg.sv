// MEM/WB Register
module MEM_WB(
    input logic clk,
    input logic reset,
    input logic [31:0] mem_data_in,
    input logic [31:0] alu_result_in,
    input logic [4:0] rd_in,
    input logic [1:0] wb_sel_in,
    input logic [31:0] pc_in,
    input logic reg_write_in, mem_to_reg_in,
    output logic [31:0] mem_data_out,
    output logic [31:0] alu_result_out,
    output logic [4:0] rd_out,
    output logic [1:0] wb_sel_out,
    output logic [31:0] pc_out,
    output logic reg_write_out, mem_to_reg_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_data_out <= 32'b0;
            alu_result_out <= 32'b0;
            rd_out <= 5'b0;
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
        end else begin
            mem_data_out <= mem_data_in;
            alu_result_out <= alu_result_in;
            rd_out <= rd_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            wb_sel_out<=wb_sel_in;
            pc_out=pc_in;
        end
    end
endmodule