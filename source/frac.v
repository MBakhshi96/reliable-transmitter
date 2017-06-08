module	frac( clk , resetn , input_valid , enable , num , fixed_num_d , output_valid);
	//parameter
	
	parameter n=16;
	
	//inputs

	input clk , resetn ,input_valid , enable ;
	input	[31:0] num;

	//output
	output output_valid;
	output reg [n-1:0]fixed_num_d;
	

	//
	wire [n-1:0]fixed_num;
	wire [28:0]	magn;
	wire [28:0]	magn1;
	reg [n-1:0]	absVal;
	reg [7:0]	shiftVal;
	reg [31:0] num_d;
	reg [22:0] num_d_d;
	reg sign_d;
	reg sign_d_d;
	reg exp_d;
	reg [3:0]valid;
	//   		   
	
	//gated clock
	assign clock = clk & enable;
	//
	assign magn1 = ( exp_d )	?	( { 6'h01,num_d_d[22:0] } <<	shiftVal ):
					 ( { 6'h01,num_d_d[22:0] } >> shiftVal );
	
	assign fixed_num = ( sign_d_d ) ?	-absVal	:	absVal;
	assign output_valid = valid[0];

	
	always @(posedge clock , negedge resetn )
		begin
			if( resetn == 0 )
				begin
					fixed_num_d <= {{n{1'h0}}} ;
					num_d <= 32'h0 ;
					absVal <= {{n{1'h0}}};
					sign_d <= 1'b0;
					shiftVal <= 8'h0 ;
					exp_d <= 1'b0;
					num_d_d <= 23'h0;
					sign_d_d <= 1'b0;
					valid <= 4'h0;
				end
			else
				begin
					fixed_num_d <= fixed_num ;
					num_d <= num ;
					absVal <= magn1[28:29-n];
					sign_d <= num_d[31];
					shiftVal <= ( num_d[30] ) ? ( 8'h01 ) : ( 8'd127 - num_d[30:23] ) ;
					exp_d <= num_d[30];
					num_d_d <= num_d;
					sign_d_d <= sign_d;
					valid <= {input_valid ,valid[3:1]};
				end
		end
		
endmodule
