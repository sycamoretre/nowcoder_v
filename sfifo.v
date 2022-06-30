// 利用双端口RAM实现同步FIFO

`timescale 1ns/1ns

/**********************************RAM************************************/
module dual_port_RAM #(parameter DEPTH = 16,
					   parameter WIDTH = 8)(
	 input wclk
	,input wenc
	,input [$clog2(DEPTH)-1:0] waddr  
	,input [WIDTH-1:0] wdata      	
	,input rclk
	,input renc
	,input [$clog2(DEPTH)-1:0] raddr  
	,output reg [WIDTH-1:0] rdata 		
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
	if(wenc)
		RAM_MEM[waddr] <= wdata;
end 

always @(posedge rclk) begin
	if(renc)
		rdata <= RAM_MEM[raddr];
end 

endmodule  

/**********************************SFIFO************************************/
module sfifo#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					clk		, 
	input 					rst_n	,
	input 					winc	,
	input 			 		rinc	,
	input 		[WIDTH-1:0]	wdata	,

	output reg				wfull	,
	output reg				rempty	,
	output wire [WIDTH-1:0]	rdata
);
    reg [$clog2(DEPTH):0] waddr,raddr;
  // 定义fifo中的读写地址要比ram中多一位
    reg [$clog2(DEPTH):0] cnt;
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n) waddr<=0;
            else if(winc & !wfull) waddr<=waddr+1;
        end
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n) raddr<=0;
            else if(rinc & !rempty) raddr<=raddr+1;
        end
    always@(*)
        begin
            if(waddr[$clog2(DEPTH)] == raddr[$clog2(DEPTH)])
              // 根据读写地址的最高位判断是否套圈
                cnt = waddr - raddr;
            else
                cnt = DEPTH - raddr[$clog2(DEPTH)-1:0] + waddr[$clog2(DEPTH)-1:0];
        end
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n) wfull<=0;
            else if(cnt==DEPTH) wfull<=1;
            else wfull<=0;
        end
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n) rempty<=0;
            else if(cnt==0) rempty<=1;
            else rempty<=0;
        end
    
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH) )
    dual_port_RAM_1(
        .wclk (clk),  
        .wenc (winc & !wfull),  
        .waddr(waddr),  
        .wdata(wdata[$clog2(DEPTH)-1:0]),          
        .rclk (clk), 
        .renc (rinc & !rempty), 
        .raddr(raddr[$clog2(DEPTH)-1:0]),  
        .rdata(rdata)   
    );
    
endmodule
