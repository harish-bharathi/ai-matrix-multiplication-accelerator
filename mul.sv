`include "config.vh"

module mul(
  clk,
  reset,
  a,
  b,
  out
);

  `define size 8
  `define p_width (`size*2)
  `define p_no (`size/2)
  `define reg_wire (`p_no/2)

  input clk;
  input reset;
  input signed [`size-1:0] a;
  input signed [`size-1:0] b;
  output signed [`p_width+1:0] out;

  wire signed [`p_width-1:0] w[`p_no-1:0];

  reg signed [`p_width:0] temp_sum[`reg_wire-1:0];
  reg signed [`p_width:0] out_sum[`reg_wire-1:0];
  reg signed [`p_width+1:0] sum;
  reg signed [`p_width+1:0] out_reg;

  integer i;

  booth m(a, b, w, clk, reset);

  always @(*) begin
    for (i = 0; i < `reg_wire; i = i + 1)
      temp_sum[i] = w[2*i] + w[2*i+1];
  end

  always @(posedge clk) begin
    if (reset) begin
      for (i = 0; i < `reg_wire; i = i + 1)
        out_sum[i] <= 0;
    end
    else begin
      for (i = 0; i < `reg_wire; i = i + 1)
        out_sum[i] <= temp_sum[i];
    end
  end

  always @(*) begin
    sum = 0;   
    for (i = 0; i < `reg_wire; i = i + 1)
      sum = sum + out_sum[i];
  end

  always @(posedge clk) begin
    if (reset)
      out_reg <= 0;
    else
      out_reg <= sum;
  end

  assign out = out_reg;

endmodule

