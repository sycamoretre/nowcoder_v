`timescale 1ns/1ns
module ram_mod(
	input clk,
	input rst_n,
	
	input write_en,
	input [7:0]write_addr,
	input [3:0]write_data,
	
	input read_en,
	input [7:0]read_addr,
	output reg [3:0]read_data
);
    reg [3:0]myRAM[0:7];
    integer i;
    
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n) begin
                for (i=0;i<7;i=i+1) begin
                    myRAM[i]<=4'b0; 
                end
            end
            else if(write_en) myRAM[write_addr]<=write_data;
        end
    
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n) read_data<=0;
            else  if(read_en)  read_data<=myRAM[read_addr];
        end
	
endmodule
