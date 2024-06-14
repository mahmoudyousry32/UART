`timescale 1ns/1ns
module UART_tb;

//***********************************************************PARAMETERS***********************************************************
parameter DATA_BITS = 8;
parameter STOP_BITS = 1;
parameter SYSTEM_CLK_f = 100000000;
parameter SYSTEM_CLK_T = 5;


//***********************************************************INPUT AND OUTPUT SIGNAL DECLARTIONS ***********************************************************
reg clk;
reg rst;

reg wr_uart;
reg rd_uart;
reg [1:0] B_rate;
reg [DATA_BITS - 1:0] data_read;
reg [DATA_BITS - 1 :0] wr_data;
integer tx_din;

wire tx_out;
wire rx_in;
wire tx_idle;
wire tx_full;
wire rx_empty;
wire [DATA_BITS - 1 :0] rd_data;
wire rx_full;


assign rx_in = tx_out ;

//***********************************************************TASK DEFINTIONS***********************************************************
task RESET;
begin
rst = 0 ;
#10;
rst = 1;
end
endtask

task WRITE_TX;
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

task READ_RX;
begin
if(rx_empty);
else begin 
@(posedge clk)
rd_uart <= 1;
data_read <= rd_data;
@(posedge clk)
rd_uart <= 0;
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

UART		DUT(.clk(clk),
			 .rst(rst),
			 .tx(tx_out),
			 .rx(rx_in),
			 .rd_uart(rd_uart),
			 .wr_uart(wr_uart),
			 .rx_empty(rx_empty),
			 .rd_data(rd_data),
			 .wr_data(wr_data),
			 .tx_full(tx_full),
			  .B_rate(B_rate),
			  .tx_idle(tx_idle),
			  .rx_full(rx_full));

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
rd_uart = 0;
SET_BAUD(38400);
#20;
repeat(32) begin
tx_din = $random;
WRITE_TX(tx_din[7:0]);
end


wait(rx_full);
#100
$stop;
repeat(32) begin
READ_RX();
end
#100;
$stop;


end


endmodule 







