module CORDIC_transmit( clk , resetn , input_valid , enable , input_num , output_num , output_valid );
//parameters

parameter n = 16;
parameter npipe = 13;

//inputs

input clk , resetn , input_valid , enable ;
input [n:1] input_num;

//outputs
output output_valid;
output [n:1] output_num;

//wires
wire [n:1] ROM [1:npipe-1]; 
wire [n:1] X [1:npipe+1];
wire [n:1] Z [1:npipe+1];
reg [npipe:1] valid;
//gated clock
assign clock = clk & enable;
//

//ROM initialization
assign ROM[1] =16'b0000010101101011;						//atanh(7/8)
assign ROM[2] =16'b0000001111100100;						//atanh(3/4)
assign ROM[3] =16'b0000001000110010;						//atanh(1/2)
assign ROM[4] =16'b0000000100000110;						//atanh(1/4)						
assign ROM[5] =16'b0000000010000001;						//atanh(1/8)
assign ROM[6] =16'b0000000001000000;						//atanh(1/16)
assign ROM[7] =16'b0000000000100000;						//atanh(1/32)
assign ROM[8] =16'b0000000000010000;						//atanh(1/64)
assign ROM[9] =16'b0000000000001000;						//atanh(1/128)
assign ROM[10] =16'b0000000000000100;						//atanh(1/256)
assign ROM[11] =16'b0000000000000010;						//atanh(1/512)
assign ROM[12] =16'b0000000000000001;						//atanh(1/1024)

//

CORDIC_stage #( .n(n) , .shift(0) ) stage1( clock , X[1] , Z[1] , ROM[1] , X[2] , Z[2] );				
CORDIC_stage #( .n(n) , .shift(-1) ) stage2( clock , X[2] , Z[2] , ROM[2] , X[3] , Z[3] );

genvar i; 			
generate 
		for( i = 3 ; i <= npipe ; i = i+1 )			
			begin : generate_pipelines
				if( i >= 7 )
					CORDIC_stage #( n , i-3 ) stagei( clock , X[i] , Z[i] , ROM[i-1] , X[i+1] , Z[i+1] );
				else
					CORDIC_stage #( n , i-2 ) stagei( clock , X[i] , Z[i] , ROM[i] , X[i+1] , Z[i+1] );
			end
endgenerate

always @(posedge clock)
	begin
		valid <= {input_valid , valid[npipe:2]};
	end
	
assign X[1] = 16'h0F15;			//3.7709
assign Z[1] = input_num;
assign output_num = X[npipe+1];
assign output_valid = valid[1];

endmodule
