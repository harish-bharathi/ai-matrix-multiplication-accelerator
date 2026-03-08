`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2026 21:28:28
// Design Name: 
// Module Name: tb_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "config.vh"

module tb_top();
    // Signals matching top_module ports
    logic clk, reset, write_en;
    logic signed [`size-1:0] a_in[`TOTAL2-1:0];
    logic signed [`size-1:0] b_in[`TOTAL1-1:0];
    logic signed [`p_width+3:0] c_out[`TOTAL-1:0];

    // Clock Generation (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // DUT Instance
    top_module dut (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .a_in(a_in),
        .b_in(b_in),
        .c_out(c_out)
    );

    initial begin
        // 1. Initialize and Reset
        reset = 1;
        write_en = 0;
        // Initialize arrays to zero
        for(int i=0; i<`TOTAL2; i++) a_in[i] = 0;
        for(int i=0; i<`TOTAL1; i++) b_in[i] = 0;
        
        repeat(5) @(posedge clk);
        reset = 0;

        // 2. Load Data (Write Enable High)
        @(negedge clk);
        write_en = 1;
        // Fill Matrix A and B with small random numbers for easy checking
        for(int i=0; i<`TOTAL2; i++) a_in[i] = $random % 10;
        for(int i=0; i<`TOTAL1; i++) b_in[i] = $random % 10;

        // 3. Hold Data (Write Enable Low)
        @(negedge clk);
        write_en = 0;

        // 4. Wait for Pipeline
        // The result will propagate through memory -> MAC -> Output Reg
        repeat(20) @(posedge clk);

        // 5. Display Results
        $display("Matrix A: %p", a_in);
        $display("Matrix B: %p", b_in);
        $display("Result C: %p", c_out);

        #100 $finish;
    end
endmodule
