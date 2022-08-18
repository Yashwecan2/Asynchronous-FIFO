// Auther:- Yashawant Kumar Singh(213070099)
module test_Async_Fifo;
reg Wr_clk,Rd_clk,reset;
reg [3:0] Data_in;
wire [3:0]Data_out;
wire Wr_Full,Rd_Empty;
integer i;
Async_Fifo dut(.Rd_clk(Rd_clk),.Wr_clk(Wr_clk),.reset(reset),.Data_in(Data_in),.Data_out(Data_out),.Wr_Full(Wr_Full),.Rd_Empty(Rd_Empty));

initial 
begin
Wr_clk=0;
Rd_clk=0;
reset=1;
#15 reset=0;
end


always
#5 Wr_clk=~Wr_clk;

always
#10 Rd_clk=~Rd_clk;



initial
#1000 $finish;


initial begin
Data_in<=4'd0;

for(i=0;i<30;i=i+1)
#10 Data_in <= i;
end

initial
#350 Data_in <= 4'd0;

endmodule
