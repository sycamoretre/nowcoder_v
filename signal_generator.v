`timescale 1ns/1ns
module signal_generator(
	input clk,
	input rst_n,
	input [1:0] wave_choise,
	output reg [4:0]wave
	);

  reg [4:0]cnt;  // 方波计数器；计数0-19；0-9 wave=0;10-19 wave=20
  reg flag;  //三角波flag信号；flag=0递减，flag=1递增
  
//     方波 T=20
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) cnt<=0; 
        else       cnt<=(wave_choise==0)?((cnt==19)?0:cnt+1):0;
//       else begin
//           if(wave_choise==0) begin
//               if(cnt==19) cnt<=0;
//               else        cnt<=cnt+1;
//           end
//           else          cnt<=0;
//       end
    end    
       
//     锯齿波 T=21
       
//     三角波 T=40
//     flag = 0 ↓
//     flag = 1 ↑
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) flag<=0;
        else begin
            if(wave_choise==2)begin
                if(flag==0&&wave==1) flag<=1;
                else if(flag==1&&wave==19) flag<=0;
                else flag<=flag;
            end
            else flag<=0;
        end
    end
    
//     wave 信号
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) wave<=0;
        else begin
            case(wave_choise)
                0: begin  //0-9 wave=0;10-19 wave=20
                  if(cnt==9)         wave<=20;
                    else if(cnt==19) wave<=0;
                    else             wave<=wave;
                end
                1: begin
                  if(wave==20)   wave<=0;  //T=21
                    else         wave<=wave+1;
                end
                2: begin
                    if(flag==0) wave<=wave-1;
                    else        wave<=wave+1;
                end
                default: wave<=wave;
            endcase                    
        end
    end
            
            
        
        
    
endmodule
