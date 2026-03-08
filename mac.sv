`include "config.vh"

module mac(
    // Input is now a single row of A from mem_mod_a
    input signed [`size-1:0] a_row[`matrix_size-1:0],
    // Input is the full Matrix B from mem_mod_b
    input signed [`size-1:0] b_all[`TOTAL1-1:0],
    input clk, reset,
    // Output is one row of results (e.g., 2 or 64 dot products)
    output reg signed [`p_width+3:0] out_row[`matrix_col-1:0]
);

    wire signed [`p_width+3:0] q[`matrix_col-1:0];

    // Build one row of PEs (one PE for every column in B)
    generate
        genvar j;
        for (j = 0; j < `matrix_col; j = j + 1) begin : COL_GEN
            pe u_pe (
                .a(a_row),
                // Slices the specific column from the full Matrix B
                .b(b_all[j * `matrix_size +: `matrix_size]),
                .clk(clk),
                .reset(reset),
                .out(q[j])
            );
        end
    endgenerate

    // Pipeline register to stabilize the current row of results
    always @(posedge clk) begin
        if (reset) begin
            for (int i = 0; i < `matrix_col; i++) out_row[i] <= 0;
        end else begin
            out_row <= q;
        end
    end

endmodule