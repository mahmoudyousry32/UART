module 	UART_TX(clk,
				rst,
				tx,
				tx_start,
				tx_done,
				din,
				s_tick,
				tx_idle);
				
parameter DBITS = 8;
parameter SBITS = 1;

input clk;
input rst;
input s_tick;
input tx_start;
input [DBITS - 1:0] din;




output  tx;
output reg tx_done;
output tx_idle;

localparam	IDLE 	= 3'b000;
localparam	START	= 3'b001;
localparam	DATA	= 3'b010;
localparam	STOP	= 3'b011;
localparam  DONE	= 3'b100;


reg [3:0] s_tick_count;
reg [2:0] dbits_count;
reg [2:0] state_reg;
reg [DBITS - 1 : 0] din_reg;
reg  tx_reg;
reg tx_idle;

always@(posedge clk,negedge rst)
if(!rst)begin 
	state_reg <= IDLE ; 
	dbits_count <= 0 ;
	s_tick_count <= 0;
	tx_reg <= 1;
	din_reg <= 0;
	tx_done <= 0;
	tx_idle <= 1;
	end
else
	case(state_reg)
	
	IDLE			:			begin
									
									if(tx_start) begin 
										state_reg <= START;
										s_tick_count <= 0;
										din_reg <= din;
										tx_reg <= 0;
										tx_idle <= 0;
									end
								end
	
	START			:			begin
									if(s_tick)
										if(s_tick_count == 15)begin
											s_tick_count <= 0;
											state_reg <= DATA;
											din_reg <= {1'b1 , din_reg[7:1]};
											tx_reg <= din_reg[0];
										end
										else
											s_tick_count <= s_tick_count + 1; 
								end
	
	DATA			:			begin
									if(s_tick)
										if(s_tick_count == 15)begin
											s_tick_count <= 0;
											din_reg <= {1'b1 , din_reg[7:1]};
											tx_reg <= din_reg[0];
											if(dbits_count == DBITS - 1)begin 
												state_reg <= STOP;
												dbits_count <= 0;
												tx_reg <= 1;
											end
											else
												dbits_count <= dbits_count + 1;
										end
										else
											s_tick_count <= s_tick_count + 1; 										
								end
								
	STOP			:			begin
									if(s_tick)
										if(s_tick_count == 15)begin
											s_tick_count <= 0;
											if(dbits_count == SBITS - 1)begin 
												state_reg <= DONE;
												tx_done <= 1;
												dbits_count <= 0 ;
											end
											else 
												dbits_count <= dbits_count + 1; 
										end
										else
											s_tick_count <= s_tick_count + 1; 
								end
								
	DONE			:			begin
								tx_done <= 0 ;
								state_reg <= IDLE;
								tx_idle <= 1 ;
								end
	
	default			:			state_reg <= IDLE;
	
	endcase

assign tx = tx_reg;
endmodule