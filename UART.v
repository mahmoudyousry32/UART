module 	UART(clk,
			 rst,
			 tx,
			 rx,
			 rd_uart,
			 wr_uart,
			 rx_empty,
			 rd_data,
			 wr_data,
			 tx_full,
			  B_rate,
			  tx_idle,
			  rx_full);
			 



parameter DATA_BITS = 8 ;

input clk;
input rst;
input rx;
input [DATA_BITS - 1 :0] wr_data;
input rd_uart;
input wr_uart;
input [1:0] B_rate;

output [DATA_BITS - 1 :0] rd_data;
output rx_empty;
output tx_full;
output tx;
output tx_idle;
output rx_full;


wire s_tick;


wire tx_full;
wire tx_empty;
wire tx_rd;
wire tx_wr;
wire [DATA_BITS - 1 :0]  tx_din;
wire tx_idle;
wire rx_full;
wire rx_empty;
wire rx_rd;
wire rx_wr;
wire [DATA_BITS - 1 :0]  rx_dout;


UART_TX	tx_core(.clk(clk),
				.rst(rst),
				.tx(tx),
				.tx_start(~tx_empty),
				.tx_done(tx_rd),
				.din(tx_din),
				.s_tick(s_tick),
				.tx_idle(tx_idle));
				
UART_RX	rx_core(.clk(clk),
				.rst(rst),
				.rx(rx),
				.rx_done(rx_wr),
				.dout(rx_dout),
				.s_tick(s_tick));
				
baud_gen baud_gen(.clk(clk),
				 .rst(rst),
				 .B_rate(B_rate),
				 .s_tick(s_tick));

fifo  fifo_tx(.clk(clk),
			 .rst(rst),
			 .wr_data(wr_data),
			 .rd_data(tx_din),
			 .wr(wr_uart),
			 .rd(tx_rd),
			 .full(tx_full),
			 .empty(tx_empty));

fifo  fifo_rx(.clk(clk),
			 .rst(rst),
			 .wr_data(rx_dout),
			 .rd_data(rd_data),
			 .wr(rx_wr),
			 .rd(rd_uart),
			 .full(rx_full),
			 .empty(rx_empty));
			 
endmodule 