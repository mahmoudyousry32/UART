`timescale 1ns/1ns
module UART_TX_tb;

//***********************************************************PARAMETERS***********************************************************
parameter DATA_BITS = 8;
parameter STOP_BITS = 1;
parameter SYSTEM_CLK_f = 100000000;
parameter SYSTEM_CLK_T = 5;


//***********************************************************INPUT AND OUTPUT SIGNAL DECLARTIONS ***********************************************************
reg clk;
reg rst;

reg wr_uart;
reg [1:0] B_rate;
reg [7:0] fifo_data;

wire tx_done;
wire tx;
wire s_tick;
wire tx_idle;
wire tx_full;
wire [DATA_BITS - 1 :0] tx_din;
reg [DATA_BITS - 1 :0] wr_data;
wire tx_start;

//***********************************************************TASK DEFINTIONS***********************************************************
task RESET;
begin
rst = 0 ;
#10;
rst = 1;
end
endtask

task WRITE_FIFO;
input [DATA_BITS - 1:0] data_in;
begin
if(tx_full);
else begin 
@(posedge clk)
wr_uart <= 1;
wr_data <= data_in;
@(posedge clk)
wr_uart <= 0;
end
end
endtask

task SET_BAUD;
input integer baudrate;
begin
case(baudrate)
4800		:		B_rate = 2'b00;
9600		:		B_rate = 2'b01;
19200		:		B_rate = 2'b10;
38400		:		B_rate = 2'b11;
default B_rate = 2'b00;
endcase
end
endtask


//****************************************************MODULE INSTANTIATION****************************************************
UART_TX  #(.DBITS(8),.SBITS(1))   DUT(.clk(clk),
													  .rst(rst),
													  .tx(tx),
													  .tx_start(~tx_start),
													  .tx_done(tx_done),
													  .din(tx_din),
													  .s_tick(s_tick),
													  .tx_idle(tx_idle));
				

baud_gen  #(.SYS_CLK(100000000)) 	DUT_2 (.clk(clk),
												.rst(rst),
												.B_rate(B_rate),
												.s_tick(s_tick));


fifo  fifo_tx(.clk(clk),
			 .rst(rst),
			 .wr_data(wr_data),
			 .rd_data(tx_din),
			 .wr(wr_uart),
			 .rd(tx_done),
			 .full(tx_full),
			 .empty(tx_start));
//*************************************************** initiate CLK signal 100MHz***********************************************
always begin 
clk = 0;
#SYSTEM_CLK_T ;
clk = 1;
#SYSTEM_CLK_T ;
end

//***********************************************MAIN TESTBENCH********************************************
initial begin
RESET();
#10;
SET_BAUD(9600);
#20;
repeat(32) begin
fifo_data = $random;
WRITE_FIFO(fifo_data[7:0]);
end

wait(tx_start);
#100
$stop;

end


endmodule 







