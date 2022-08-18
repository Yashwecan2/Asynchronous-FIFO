// Asynchronous FIFO Verilog Code
//Auther:- Yashawant Kumar Singh(213070099)

module Async_Fifo(Wr_clk,Rd_clk,reset,Data_in,Data_out,Rd_Empty,Wr_Full);
parameter Depth = 16;
parameter Width = 4;
input Wr_clk,Rd_clk,reset;
input [Width-1:0] Data_in;
output [Width-1:0] Data_out;
output Rd_Empty,Wr_Full;

reg [Width-1:0] Fifo [Depth-1:0];

reg [Width-1:0] Data_out_reg;
reg [Width:0] Wr_ptr_binary,Wr_sync_1,Wr_ptr_sync_2;
reg [Width:0] Rd_ptr_binary,Rd_sync_1,Rd_ptr_sync_2;
wire [Width:0] Rd_ptr_gray,Wr_ptr_gray;
wire [Width:0] Rd_ptr_binary_sync,Wr_ptr_binary_sync;

//--Write_data_into_Fifo--//

assign Rd_Empty = (Wr_ptr_binary_sync == Rd_ptr_binary) ? 1 : 0;
assign Wr_Full = ({~Wr_ptr_binary[Width],Wr_ptr_binary[Width-1:0]} == Rd_ptr_binary_sync) ? 1:0;

assign Data_out = Data_out_reg;
always @(posedge Wr_clk)
begin
	if(reset)
			Wr_ptr_binary <= 4'd0;
	else if(Wr_Full == 0 ) begin
			Wr_ptr_binary <= Wr_ptr_binary + 1;
			Fifo[Wr_ptr_binary[Width-1:0]] <= Data_in;
			end
end


//--Read_data_out_of_Fifo--//

always @(posedge Rd_clk)
begin
	if(reset)
		Rd_ptr_binary <= 4'd0;
		else if(Rd_Empty == 0) begin
	
		Rd_ptr_binary <= Rd_ptr_binary + 1;
		Data_out_reg <= Fifo[Rd_ptr_binary[Width-1:0]];
		end
end			

//--Read_and_Write_synchronizers--//
always @(posedge Rd_clk)
begin
Wr_sync_1 <= Wr_ptr_gray;
Wr_ptr_sync_2 <= Wr_sync_1;
end

always @(posedge Wr_clk)
begin
Rd_sync_1 <= Rd_ptr_gray;
Rd_ptr_sync_2 <= Rd_sync_1;
end

//-- Binary_to_gray_and_gray_to_binary--//

assign Wr_ptr_gray = Wr_ptr_binary ^ (Wr_ptr_binary >> 1);
assign Rd_ptr_gray = Rd_ptr_binary ^ (Rd_ptr_binary >> 1);

assign Rd_ptr_binary_sync[4] = Rd_ptr_sync_2[4];
assign Rd_ptr_binary_sync[3] = Rd_ptr_binary_sync[4]^Rd_ptr_sync_2[3];
assign Rd_ptr_binary_sync[2] = Rd_ptr_binary_sync[3]^Rd_ptr_sync_2[2];
assign Rd_ptr_binary_sync[1] = Rd_ptr_binary_sync[2]^Rd_ptr_sync_2[1];
assign Rd_ptr_binary_sync[0] = Rd_ptr_binary_sync[1]^Rd_ptr_sync_2[0];

assign Wr_ptr_binary_sync[4] = Wr_ptr_sync_2[4];
assign Wr_ptr_binary_sync[3] = Wr_ptr_binary_sync[4]^Wr_ptr_sync_2[3];
assign Wr_ptr_binary_sync[2] = Wr_ptr_binary_sync[3]^Wr_ptr_sync_2[2];
assign Wr_ptr_binary_sync[1] = Wr_ptr_binary_sync[2]^Wr_ptr_sync_2[1];
assign Wr_ptr_binary_sync[0] = Wr_ptr_binary_sync[1]^Wr_ptr_sync_2[0];



endmodule
