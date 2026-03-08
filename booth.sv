`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2026 21:00:45
// Design Name: 
// Module Name: booth
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

module booth (a,b,pp_out,clk,reset);
  input signed[`size-1:0]a,b;
  input clk,reset;
  output reg signed  [`p_width-1:0]pp_out[`p_no-1:0];
  reg[2:0]e[`p_no-1:0];
  reg signed [`size:0]c;
  reg signed [`p_width-1:0]pp[`p_no-1:0];
  reg signed [`p_width-1:0] r[`p_no-1:0];
reg signed [`p_width-1:0]p;
integer j,i;
  always@(*)begin
c={a,1'b0};
  for(j=1;j<`size;j=j+2)begin
 case({c[j+1],c[j],c[j-1]})
 3'b000,3'b111:e[(j-1)/2]=3'b000;
 3'b001,3'b010:e[(j-1)/2]=3'b001;
 3'b110,3'b101:e[(j-1)/2]=3'b101;
 3'b011:e[(j-1)/2]=3'b010;
 3'b100:e[(j-1)/2]=3'b110;
 default:e[(j-1)/2]=3'b000;
 endcase
 end
//$display("%b",e[0]);
//$display("%b",e[1]);
//$display("%b",e[2]);
//$display("%b",e[3]);
  for(int i=0;i<`p_no;i=i+1)begin
 case(e[i])
   3'b000:pp[i]='0;
 3'b001:pp[i]=b;
 3'b101:pp[i]=-b;
 3'b010:pp[i]=b<<1;
 3'b110:pp[i]=-(b<<1);
 endcase
 pp[i]=$signed(pp[i])<<(2*i);
  //  $display("pp%d is %d",i,pp[i]);
  end
  end
  always @(posedge clk) begin
    if(reset) begin
      for(int i=0;i<`p_no;i++) r[i] <= 0;
    end else begin
      for(int i=0;i<`p_no;i++) r[i] <= pp[i];
    end
  end

  always@(posedge clk)begin
    for(int i=0;i<`p_no;i++)begin
      pp_out[i]<=r[i];
   // $display("pp_out%d is %d",i,pp_out[i]);
  end
  end
endmodule

