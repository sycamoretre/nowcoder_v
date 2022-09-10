`timescale 1ns/1ns

module huawei7(
	input wire clk  ,
	input wire rst  ,
	output reg clk_out
);

//*************code***********//
parameter s0=0, s1=1,s2=2,s3=3;
    reg [1:0] state, next;
    
    always@(posedge clk or negedge rst)
        begin
            if(!rst) state<=s0;
            else     state<=next;
        end
                             
    always@(*)
        begin
            case(state)
                s0: next=s1;
                s1: next=s2;
                s2: next=s3;
                s3: next=s0;
            endcase
        end
    
    always@(posedge clk or negedge rst)
        begin
            if(!rst) clk_out<=0;
            else clk_out<=(state==s0);
        end

//*************code***********//
endmodule
