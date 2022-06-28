/*
题目描述：    
设计一个自动贩售机，输入货币有两种，为0.5/1元，饮料价格是1.5/2.5元，要求进行找零，找零只会支付0.5元。
ps:
1、投入的货币会自动经过边沿检测并输出一个在时钟上升沿到1，在下降沿到0的脉冲信号
2、此题忽略出饮料后才能切换饮料的问题
注意rst为低电平复位
d1 0.5
d2 1
sel  选择饮料
out1 饮料1
out2 饮料2
out3 零钱
*/


`timescale 1ns/1ns

module seller2(
	input wire clk  ,
	input wire rst  ,
	input wire d1 , // 0.5
	input wire d2 , //1
	input wire sel , // sel=0:drink1,sel=1:drink2
	
	output reg out1, // drink1
	output reg out2, //drink2
	output reg out3 //change
);
//*************code***********//
  
  // 状态Sn，n*0.5表示现在已投币的金额
    parameter S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6; 
    reg [2:0] state,next;
    
    always@(posedge clk or negedge rst)
        begin
            if(~rst) state<=S0;
            else     state<=next;
        end
    
    always@(*)
        begin
            case(state)
                S0: begin
                    if({d1,d2}==2'b10) next=S1;
                    else if({d1,d2}==2'b01) next=S2;
                    else next=next; 
                  //testbench中d1，d2信号只有半个时钟周期有效，不写next就会卡在S0，但这样会生成锁存器，应该考虑更好的解决方案
                end
                S1: begin
                    if({d1,d2}==2'b10) next=S2;
                    else if({d1,d2}==2'b01) next=S3;
                    else next=next;
                end
                S2: begin
                    if({d1,d2}==2'b10) next=S3;
                    else if({d1,d2}==2'b01) next=S4;
                    else next=next;
                end
                S3: begin
                    if(sel)begin
                        if({d1,d2}==2'b10) next=S4;
                        else if({d1,d2}==2'b01) next=S5;
                        else next=next;
                    end
                    else next=S0;
                end
                S4: begin
                    if(sel) begin
                        if({d1,d2}==2'b10) next=S5;
                        else if({d1,d2}==2'b01) next=S6;
                        else next=next;
                    end
                    else next=S0;
                end
                default: next=S0;
            endcase
        end
    
    always@(*)
        begin
            case(state)
                S3:begin
                    if(sel)  {out1,out2,out3}=3'b000;
                    else     {out1,out2,out3}=3'b100;
                end
                S4:begin
                    if(sel)  {out1,out2,out3}=3'b000;
                    else     {out1,out2,out3}=3'b101;
                end
                S5: {out1,out2,out3}=3'b010;
                S6: {out1,out2,out3}=3'b011;            
                default: {out1,out2,out3}=3'b000;
            endcase
        end


//*************code***********//
endmodule
