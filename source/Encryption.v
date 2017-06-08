module Encryption( clk , resetn , start , input_valid , CodeIn , KEY, CipherOut , output_valid );

	input clk , resetn , start , input_valid;
	input [127:0]CodeIn;
	input [127:0]KEY;
	
	output output_valid;
	output [127:0]CipherOut;

	wire [127:0]State[0:10];
	wire [127:0]KEYRound[0:9];
	
	reg [127:0]CodeIn_D;
	reg [127:0]KEY_D;
	reg [127:0]AddRoundKey;
	reg [127:0]InitState;
	
	reg [22:0] valid; 
	// Rcon LUT
	wire [7:0]Rcon[0:9];
	
	//Rcon LUT contents
	//-----------------------------------------------------
	assign Rcon[0] = 8'h01;
	assign Rcon[1] = 8'h02;
	assign Rcon[2] = 8'h04;
	assign Rcon[3] = 8'h08;
	assign Rcon[4] = 8'h10;
	assign Rcon[5] = 8'h20;
	assign Rcon[6] = 8'h40;
	assign Rcon[7] = 8'h80;
	assign Rcon[8] = 8'h1B;
	assign Rcon[9] = 8'h36;
	
	//-----------------------------------------------------
	
	always @( posedge clk , negedge resetn )
		begin
			if( resetn == 0)
				valid <= 23'h0;
			else
				if( start == 1 )
					valid <= { input_valid , valid[22:1]};				
		end
		
	assign output_valid = valid[0];
	
	//------------------------------------------------------
	always @( posedge clk , negedge resetn )
		begin
			if( resetn == 0 )
				begin
					CodeIn_D <= 128'h0;
					KEY_D <= 128'h0;
				end
			else
				begin
					if( start == 1 )
						begin
							CodeIn_D <= CodeIn;
							KEY_D <= KEY;
						end
				end
		end
	
	//inital round 
	//-----------------------------------------------------
	
	always@( posedge clk , negedge resetn )
		begin
			if( resetn == 0 )
				begin
					AddRoundKey <= 128'h0;
					InitState <= 128'h0;
				end
			else
				if( start == 1 )
					begin
						AddRoundKey <= CodeIn_D ^ KEY_D;
						InitState <= AddRoundKey ;
					end
		end
		
	assign State[0] = InitState ;
	
	KeyExpansion KeyExpansionInit( clk , resetn , start , KEY_D , Rcon[0] , KEYRound[0] );
	
	//-----------------------------------------------------
	
	//round 0 - 8
	//-----------------------------------------------------
	
	genvar i;
	generate
		for ( i=0 ; i<=8 ; i = i+1 )
			begin: generating_pipelines
				Encryptstage Encryptstage_i( clk , resetn , start , State[i] , KEYRound[i] , State[i+1] );
				KeyExpansion KeyExpansion_i( clk , resetn , start , KEYRound[i] , Rcon[i+1] , KEYRound[i+1] );
			end
	endgenerate
	
	//-----------------------------------------------------

	//last round ( round 9 )
	//-----------------------------------------------------
	Encryptlaststage LastStageInstance( clk , resetn , start ,State[9] , KEYRound[9] , State[10] );
	//-----------------------------------------------------
	assign CipherOut = State[10];
	
endmodule
