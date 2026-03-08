`include "config.vh"

module mem_mod_b(
    input clk,
    input write_en,
    input reset,
    // Using the same array structure as the MAC input
    input  signed [`size-1:0] b_in[`TOTAL1-1:0], 
    output reg signed [`size-1:0] b_out[`TOTAL1-1:0]
);

    always @(posedge clk) begin
        if (reset) begin
            // Efficiently clear the entire array at once
            for (int i = 0; i < `TOTAL1; i++) begin
                b_out[i] <= 0;
            end
        end else if (write_en) begin
            // Load all elements in one clock cycle
            b_out <= b_in;
        end
    end

endmodule