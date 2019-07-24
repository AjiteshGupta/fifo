//******** Documentation Section ***************
//Byte wide FIFO Buffer
// Author : Ajitesh Gupta
// Date : 13th July 2019


module fifo_2(data_out,data_in,full,empty,rd_en,wr_en,clk1,clk2,reset);
output reg [7:0] data_out;
input [7:0] data_in;
input rd_en,wr_en,reset;
input clk1;//read for this clock
input clk2;//write for this clock
output full,empty;
integer wr=0,rd=0;
reg [3:0]count=0;
reg[7:0] mem[7:0];

assign empty=(count==0)?1:0;
assign full=(count==8)?1:0;

always @(posedge clk1)
	begin
	if(rd_en==1 && wr_en==0 && empty==0)
	begin
		data_out=mem[rd];
		rd=rd+1;
		count=count-1;
	end
	end

always @(posedge clk2)
	begin
	if(rd_en==0 && wr_en==1 && full==0)
	begin
		mem[wr]=data_in;
		wr=wr+1;
		count=count+1;
		data_out=8'bz;
	end
	end
endmodule

module fifo_tb_2;
reg [7:0]data_in;
reg rd_en,wr_en;
reg clk1,clk2,reset;
wire [7:0]data_out;
wire empty,full;

fifo_2 f2(data_out,data_in,full,empty,rd_en,wr_en,clk1,clk2,reset);

initial begin
clk1=0;clk2=0;reset=1;data_in=8'hef;wr_en=0;rd_en=1;
#70 wr_en=1;rd_en=0;
#60 data_in=8'h5e;
#60 data_in=8'h20;
#60 data_in=8'h12;
#60 data_in=8'h34;
#60 data_in=8'h98;
#60 data_in=8'h65;
#60 data_in=8'hb3;
#60 data_in=8'h24;
#60 data_in=8'ha1;
#60 data_in=8'h3f;

#30 rd_en=1;wr_en=0;
end
initial
begin
$monitor($time,"data_out=%h data_in=%d clk1=%b clk2=%b reset=%b rd_en=%b wr_en=%b full=%b empty=%b memorylist=%p",data_out,data_in,clk1,clk2,reset,
											   rd_en,wr_en,full,empty,f2.mem);
 
end
always #50 clk1=~clk1;
always #30 clk2=~clk2;
endmodule

