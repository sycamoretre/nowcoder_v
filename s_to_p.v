`timescale 1ns/1ns

module s_to_p(
	input 				clk 		,   
	input 				rst_n		,
	input				valid_a		,
	input	 			data_a		,
 
 	output	reg 		ready_a		,
 	output	reg			valid_b		,
	output  reg [5:0] 	data_b
);
    
    reg [2:0] cnt; // 0-5计数
    reg [5:0] data_tmp;
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  ready_a<=0;
        else        ready_a<=1;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) cnt<=0;
        else if(valid_a && ready_a)
            cnt<=(cnt==3'd5)?0:(cnt+1'd1);
      // else cnt<=0; ////////////////////////////////删掉这行，cnt不要清零
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  data_tmp<=0;
        else if(valid_a && ready_a) 
            data_tmp<={data_a, data_tmp[5:1]};
        else data_tmp<=data_tmp;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  begin
            valid_b<=0;
            data_b<=0;
        end
        else if(cnt==3'd5)begin
            valid_b<=1;
            data_b<={data_a, data_tmp[5:1]};
        end
        else begin
            valid_b<=0;
            data_b<=data_b;
        end
    end
    
endmodule
