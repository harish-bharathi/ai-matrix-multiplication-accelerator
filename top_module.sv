`include "config.vh"

module top_module(
    input clk, reset, write_en,
    input  signed [`size-1:0] a_in[`TOTAL2-1:0], 
    input  signed [`size-1:0] b_in[`TOTAL1-1:0],
    output reg signed [`p_width+3:0] c_out[`TOTAL-1:0]
);

    // Adjust this to match the cycles it takes for data to go 
    // from mem_a -> mac -> out_row (typically 4 or 5)
    localparam LATENCY = 9; 

    wire signed [`size-1:0] a_row_bus[`matrix_size-1:0];
    wire signed [`size-1:0] b_full_bus[`TOTAL1-1:0];
    wire signed [`p_width+3:0] row_res[`matrix_col-1:0];
    
    reg [7:0] count;

    // 1. Memory A: Delivers Row 0, then Row 1, Row 2... every cycle
    mem_mod_a aa (
        .clk(clk), .reset(reset), .write_en(write_en),
        .a_in(a_in), .a_out(a_row_bus)
    );

    // 2. Memory B: Holds the entire matrix for reuse
    mem_mod_b bb (
        .clk(clk), .reset(reset), .write_en(write_en),
        .b_in(b_in), .b_out(b_full_bus)
    );

    // 3. Sequential MAC: Processes one row against all columns
    mac mac_unit (
        .clk(clk), .reset(reset),
        .a_row(a_row_bus),
        .b_all(b_full_bus),
        .out_row(row_res)
    );

    // 4. Result Storage Logic
    always @(posedge clk) begin
        if (reset || write_en) begin
            count <= 0;
            for (int i = 0; i < `TOTAL; i++) c_out[i] <= 0;
        end else begin
            count <= count + 1;
            
            // Map the current row results into the 1D c_out array
            if (count >= LATENCY && count < (LATENCY + `matrix_row)) begin
                for (int m = 0; m < `matrix_col; m++) begin
                    c_out[(count - LATENCY) * `matrix_col + m] <= row_res[m];
                end
            end
        end
    end
endmodule