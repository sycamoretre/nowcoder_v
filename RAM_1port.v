`timescale 1ns/1ns

module RAM_1port(
    input clk,
    input rst,
    input enb,  // write enable enb=1:wirte;enb=0:read
    input [6:0]addr,
    input [3:0]w_data,
    output wire [3:0]r_data
);
//*************code***********//
    reg [3:0]myRAM[0:127];
    integer i; //可综合
    
    always@(posedge clk or negedge rst)
        begin
            if(~rst) begin
              for(i=0;i<127;i=i+1) begin  //可综合，初始化
                    myRAM[i]<=0; 
                end
            end
          else if(enb) myRAM[addr]<=w_data;  // 写
        end
    
  assign r_data = (~enb)?myRAM[addr]:4'd0;   //读


//*************code***********//
endmodule
