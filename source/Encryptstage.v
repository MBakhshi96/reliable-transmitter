module Encryptstage ( clk , resetn , start , InState , KEY , OutState );
	
	input clk , resetn , start;
	input [127:0] InState;
	input [127:0] KEY;

	output [127:0] OutState;

	reg [127:0] OutState;

	wire [127:0] ByteSubOut;
	wire [127:0] ShiftRowOut;
	wire [127:0] MixColumnOut;
	wire [127:0] AddRoundKeyOut;
	
	reg [127:0]KEY_D;
	
	ByteSub ByteSubInstance( clk , resetn , start , InState , ByteSubOut );
	ShiftRow ShiftRowInstance( ByteSubOut , ShiftRowOut );
	MixColumn MixColumnInstance( ShiftRowOut , MixColumnOut );
	
	assign AddRoundKeyOut = MixColumnOut ^ KEY_D ;
	
	always @( posedge clk , negedge resetn )
		begin
			if( resetn == 0 )
				begin
					OutState <= 128'h0;
					KEY_D <= 128'h0;
				end
			else
				if ( start == 1 )
					begin
						OutState <= AddRoundKeyOut ;
						KEY_D <= KEY ;
					end
		end
	
endmodule
