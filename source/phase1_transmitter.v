module phase1_transmitter( clock , resetn , input_valid , enable , input_num , output_num , output_valid);
parameter n = 16;
parameter npipe = 13;
input clock , resetn , input_valid , enable;
input [32:1] input_num;
output output_valid;
output [n:1] output_num;
wire [n:1] fixed_num;  //number in fixed point representation
wire valid;

frac #(n)frac1( clock , resetn , input_valid , enable , input_num , fixed_num , valid ); 
CORDIC_transmit #( n , npipe )CORDIC_transmit1( clock , resetn , valid , enable , fixed_num , output_num , output_valid );
 
endmodule
