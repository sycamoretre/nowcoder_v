`timescale 1ns/1ns
module sequence_detect(
	input clk,
	input rst_n,
	input data,
	output reg match,
	output reg not_match
	);
     
	
//      状态说明：IDLE起始状态，除了最开始后面不会用到，怀疑可以合并
// 	S0-S5为正确序列检测状态，S(i)表示第i位
// 	F0-F5为错误序列检测状态，一旦不符合指定序列即进入F状态
// 	使用状态机，无需使用计数器计数
    parameter S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,F0=6,F1=7,F2=8,F3=9,F4=10,F5=11,IDLE=12;
    reg [3:0] state,next;
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) state<=IDLE;
        else       state<=next;
    end
    
    
    // 检测序列 011100
    
    always@(*)begin
        case(state)
            IDLE:   next = data?F0:S0;
            S0:     next = data?S1:F1;
            S1:     next = data?S2:F2;
            S2:     next = data?S3:F3;
            S3:     next = data?F4:S4;
            S4:     next = data?F5:S5;
            S5:     next = data?F0:S0;
            F0:     next = F1;
            F1:     next = F2;
            F2:     next = F3;
            F3:     next = F4;
            F4:     next = F5;
            F5:     next = data?F0:S0;
            default:next = IDLE;
        endcase
    end
    
    always@(*)begin
        if(!rst_n) begin
            match     <=0;
            not_match <=0;
        end
        else begin
            match     <=(state==S5);
            not_match <=(state==F5);
                         
        end
    end
    
endmodule
