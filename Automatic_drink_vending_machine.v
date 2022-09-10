`timescale 1ns/1ns

module sale(
   input                clk   ,
   input                rst_n ,
   input                sel   ,//sel=0,5$dranks,sel=1,10&=$drinks
   input          [1:0] din   ,//din=1,input 5$,din=2,input 10$
 
   output   reg  [1:0] drinks_out,//drinks_out=1,output 5$ drinks,drinks_out=2,output 10$ drinks
   output reg        change_out   
);
    //使用米利状态机， 只有两个状态， idle以及买10块钱饮料只付了五块钱的s_m5状态
    //买五块钱饮料付五块钱，买五块钱饮料付十块钱，买十块钱饮料付十块钱都可以在idle状态完成
    //剩下的情况是买十块钱饮料付五块钱，再付五块或者再付十块时，使用s_m5状态完成
    parameter idle=0, s_m5=1;
    reg state,next;
    
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n) state<= idle;
            else       state<= next;
        end
    
    always@(*)
        begin
            case(state)
                idle: next=sel?((din==1)?s_m5:idle):idle;
                s_m5: next=(din==0)?s_m5:idle;
            endcase
        end
    
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n) drinks_out<=0;
            else if(state == idle) drinks_out<=sel?((din==2)?2'b10:2'b00):((din!=0)?2'b01:2'b00);
            else  drinks_out <= (sel && (din!=0))?2'b10:2'b00;
        end
    
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n) change_out<=0;
            else if(state == idle) change_out<=(!sel && (din==2));
            else change_out<= (sel && (din==2));
        end
    
endmodule
