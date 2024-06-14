# UART
Implementation of UART using Verilog HDL .
## Specifications
Data packets are 8 bits long , no parity bit included , 1 start bit , 1 or 2 stop bits deteremined by the parameter "SBIT" , able to operate on 4 baudrates (4800,9600,19200,38400) determined using the "B_rate" signal.
## Construction
The top level is shown in the figure below , it consist of 5 modules , UART_TX , UART_RX , FIFO_RX , FIFO_TX , BAUD_GEN 
![Presentation1](https://github.com/mahmoudyousry32/UART/assets/123260720/6bd5e53a-b464-451a-880f-6d7bda836d1e) 
### Baud_gen 
this is the baud generator it generates the sampling signal whose frequency is 16 time the UART's designated baud rate for the recieving module UART_RX , The sampling tick is also used to drive the transmitter module where a bit is shifted out every 16 ticks (the sampling signal acts as an enable signal rather than a clock signal that is to avoid creating multiple clock domains and violating synchronous design ).

the sampling tick is generated every $M = {f\over 16*b}$ where f is the systems's clock frequency and b is the designated baudrate 
so for a system clock of 100Mhz and for baudrates (4800,9600,19200,38400) we would have M equals to (1302,651,325,162) clock cycles
all of M's values are rounded off to the nearest integer which would introduce some error or a discrepency between the desired baudrate and the acutal generated baudrate.

### UART_TX
this is the transmitter module it basically performs a parallel to serial conversion where the parallel data is loaded in from the fifo register , the tx module begins transmission as soon as data is loaded in the tx fifo register 
we observe that the empty signal is connected through an inverter to the tx_start port in the UART_TX module , so as soon as a byte of data is loaded in the fifo register the UART begins transmission , the tx_done signal is used to 
tell the fifo register to load the next byte to be transmitted , the UART_TX module keeps transmitting until the tx fifo is empty and the empty signal is asserted . 
### UART_RX
 .
## Transmission example
Here is an example for transmitting a byter at 38400 baudrate , the "rx_reg" is the register responsible for sampling data at the recieiving end 
![image](https://github.com/mahmoudyousry32/UART/assets/123260720/b7024aa1-a085-4660-883b-7357be03033e)
oversampling is used the sampling rate is 16 times the baud rate, which means that
each serial bit is sampled 16 times. Assume that the communication uses N data bits
and M stop bits. The oversampling scheme works as follows:
1) Wait until the incoming signal becomes 0, the beginning of the start bit, and
then start the sampling tick counter.
2) When the counter reaches 7, the incoming signal reaches the middle point of the
start bit. Clear the counter to 0 and restart.
3) When the counter reaches 15, the incoming signal progresses for one bit and
reaches the middle of the first data bit. Retrieve its value, shift it into a register,
and restart the counter.
4) Repeat step 3 n-1 more times to retrieve the remaining data bits.
5) If the optional parity bit is used, repeat step 3 one time to obtain the parity bit.
6) Repeat step 3 n more times to obtain the stop bits.
