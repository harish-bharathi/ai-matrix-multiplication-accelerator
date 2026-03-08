`include "config.vh"

module pe(
  input signed [`size-1:0] a[`matrix_size-1:0],
  input signed [`size-1:0] b[`matrix_size-1:0],
    input clk,input reset,
  output signed [`p_width+3:0] out 
);
  reg signed [`p_width+2:0] r[`matrix_size-1:0];
  wire signed [`p_width+1:0] m_out[`matrix_size-1:0];
  reg signed [`p_width+2:0] sum_wire[(`matrix_size/2)-1:0];
  reg signed [`p_width+3:0] sum;
  reg signed [`p_width+3:0] out_f;
  reg signed [`p_width+2:0] out_reg[(`matrix_size/2)-1:0];
   generate
  genvar k;
  for (k = 0; k < `matrix_size; k = k + 1) begin : MUL_ARRAY
    mul u_m1 (
      .clk(clk),
      .reset(reset),
      .a(a[k]),
      .b(b[k]),
      .out(m_out[k])
    );
  end
endgenerate
  
  
    always @(posedge clk) begin
        if (reset) begin
          for(int i=0;i<`matrix_size;i++)begin
            r[i] <= '0;
        end
    end 
      else begin
        for(int i=0;i<`matrix_size;i++)begin
          r[i] <= m_out[i];
          
        end
 //   $display("m_out[i] is %p",m_out);
      end
    end
  
  always@(*)begin
    for(int l=0;l<`matrix_size/2;l++)begin
       sum_wire[l]=r[2*l]+r[2*l+1];
    end
  end
    always @(posedge clk) begin
       if (reset) begin
         for(int i=0;i<`matrix_size/2;i++)begin
            out_reg[i] <= '0;
        end
    end 
      else begin
        for(int i=0;i<`matrix_size/2;i++)begin
        out_reg[i] <= sum_wire[i];
         end
        end
    end
  always @(*) begin
   sum = 0;
    for(int i=0;i<`matrix_size/2;i++)begin
    sum = sum + out_reg[i];
  end
  end
  always@(posedge clk)begin
    if(reset)begin
      out_f<=0;
    end
    else begin
      out_f<=sum;
  end
  end
assign out = out_f;
endmodule
