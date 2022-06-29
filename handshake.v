/*
分别编写一个数据发送模块和一个数据接收模块，模块的时钟信号分别为clk_a，clk_b。两个时钟的频率不相同。
数据发送模块循环发送0-7，在每个数据传输完成之后，间隔5个时钟，发送下一个数据。
在两个模块之间添加必要的握手信号，保证数据传输不丢失。
data_req和data_ack的作用说明：
data_req表示数据请求接受信号。
当data_out发出时，该信号拉高，在确认数据被成功接收之前，保持为高，期间data应该保持不变，等待接收端接收数据。
当数据接收端检测到data_req为高，表示该时刻的信号data有效，保存数据，并拉高data_ack。
当数据发送端检测到data_ack，表示上一个发送的数据已经被接收。
撤销data_req，然后可以改变数据data。等到下次发送时，再一次拉高data_req。
*/

`timescale 1ns/1ns
module data_driver( //数据发送端
	input clk_a,
	input rst_n,
	input data_ack,
	output reg [3:0]data,
	output reg data_req
	);
    
    reg data_ack_reg1,data_ack_reg2;
    reg [2:0]cnt;
    always@(posedge clk_a or negedge rst_n)
        begin
            if(!rst_n) cnt<=0;
            else if(data_ack_reg1 & !data_ack_reg2) cnt<=0;
            // ack信号上升表示传输正常，结束后开始计数五个周期
            else if(data_req) cnt<=cnt;
            else cnt<=cnt+1;
        end
    
    always@(posedge clk_a or negedge rst_n)
        begin
            if(!rst_n) {data_ack_reg1,data_ack_reg2}=2'b00;
            else {data_ack_reg1,data_ack_reg2} = {data_ack,data_ack_reg1};
        end
    
     always@(posedge clk_a or negedge rst_n)
        begin
            if(!rst_n) data<=0;
            else if(data_ack_reg1 & !data_ack_reg2) data <= data+1;
            else data<=data;
        end
    
    always@(posedge clk_a or negedge rst_n)
        begin
            if(!rst_n) data_req<=0;
            else if(cnt==3'd4) data_req<=1;
            else if(data_ack_reg1 & !data_ack_reg2) data_req <= 0;
            else data_req<=data_req;
        end
    
                                            
endmodule


module data_receiver( //数据接受端
    input clk_b,
    input rst_n,
    input [3:0]data,
    input data_req,
    output reg data_ack
);
    reg data_req_reg1,data_req_reg2;
    reg [3:0]data_reg;
    
    always@(posedge clk_b or negedge rst_n)
        begin
            if(!rst_n) {data_req_reg1,data_req_reg2}=2'b00;
            else {data_req_reg1,data_req_reg2} = {data_req,data_req_reg1};
        end
    
    always@(posedge clk_b or negedge rst_n)
        begin
            if(!rst_n) data_ack<=0;
            else if (data_req_reg1 & !data_req_reg2) data_ack<=1;
            // data_req信号上升沿表示数据传输请求发出
        end
    
    always@(posedge clk_b or negedge rst_n)
        begin
            if(!rst_n) data_reg<=0;
            else if (data_req_reg1 & !data_req_reg2) data_reg<=data;
            // data_req信号上升沿表示数据传输请求发出
        end
    
endmodule
