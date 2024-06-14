# UART
Implementation of UART using Verilog HDL
## Specifications
Data packets are 8 bits long , no parity bit included , 1 start bit , 1 or 2 stop bits deteremined by the parameter "SBIT" , able to operate on 4 baudrates (4800,9600,19200,38400) determined using the "B_rate" signal

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
