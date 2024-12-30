module IF_ID(
    input logic clk,
    input logic reset,
    input logic [31:0] instr_in,
    input logic [31:0] pc_in,
    output logic [31:0] instr_out,
    output logic [31:0] pc_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instr_out <= 32'b0;
            pc_out <= 32'b0;
        end else begin
            instr_out <= instr_in;
            pc_out <= pc_in;
        end
    end
endmodule