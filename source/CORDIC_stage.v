module CORDIC_stage( clock , x_in , z_in , atanh  , x_out , z_out);
//parameters

parameter n = 16;
parameter shift = 1;

//inputs

input clock;
input [n:1] x_in , z_in;
input [n:1] atanh;

//outputs

output reg [n:1] x_out , z_out;

//

wire d;
reg [n:1] x2 , z2;
wire [n:1]x_shifted;


assign d = z_in[n];		//sign bit

generate
if(shift<1)
	begin
		assign x_shifted = x_in - ( x_in >>> (shift + 3 ) );  //first two stages
	end
else
	begin
		assign x_shifted = x_in >>> shift ;					  //remaining stages
	end
endgenerate


always @(x_in , x_shifted , d , z_in , atanh)
	begin	
		if( d == 1'b0 )
			begin
				x2 = x_in + x_shifted;
				z2 = z_in - atanh ;
			end
		else 
			begin
				x2 = x_in - x_shifted;
				z2 = z_in + atanh;
			end
	end
	
	
always @( posedge clock )
	begin
		x_out <= x2;
		z_out <= z2;
	end







endmodule
