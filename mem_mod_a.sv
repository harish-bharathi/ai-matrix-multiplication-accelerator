`include "config.vh"

module mem_mod_a(
    input clk,
    input write_en,
    input reset,
    input  signed [`size-1:0] a_in[`TOTAL2-1:0], 
    output reg signed [`size-1:0] a_out[`matrix_size-1:0]
);

    reg signed [`size-1:0] matrix_mem[`TOTAL2-1:0];
    // Dynamic counter width based on the number of rows
    reg [$clog2(`matrix_row)-1:0] row_ptr;

    always @(posedge clk) begin
        if (reset) begin
            for (int i = 0; i < `TOTAL2; i++) matrix_mem[i] <= 0;
            for (int j = 0; j < `matrix_size; j++) a_out[j] <= 0;
            row_ptr <= 0;
        end 
        else if (write_en) begin
            matrix_mem <= a_in;
            row_ptr <= 0;
        end 
        else begin
            // Fetch row based on current pointer
            for (int k = 0; k < `matrix_size; k++) begin
                a_out[k] <= matrix_mem[row_ptr * `matrix_size + k];
            end

            // Wrap around based on matrix_row macro
            if (row_ptr == `matrix_row - 1)
                row_ptr <= 0;
            else
                row_ptr <= row_ptr + 1;
        end
    end
endmodule