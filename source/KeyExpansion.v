module KeyExpansion ( clk , resetn , start , KEY , Rcon , ExpandedKey_D );
	
	input clk , resetn , start ;
	input [127:0]KEY;
	input [7:0]Rcon;

	output [127:0]ExpandedKey_D;

	reg [127:0]ExpandedKey_D;

	wire [127:0]ExpandedKey;
	wire [31:0]SubWordIn;
	wire [31:0]SubWordOut;

	reg [7:0] Rcon_D;
	reg [127:0] KEY_D; 
	
	function [31:0] RotWord;
		input [31:0] In1;
		begin
			RotWord = { In1[23:0] , In1[31:24] };
		end
	endfunction

	assign SubWordIn = RotWord( KEY[31:0] );

	SubWord SubWordInstance( clk , resetn , start , SubWordIn , SubWordOut );

	assign ExpandedKey[127:96] = SubWordOut ^ ( { Rcon_D , 24'h0 } ) ^ KEY_D[127:96];
	assign ExpandedKey[95:64] = ExpandedKey[127:96] ^ KEY_D[95:64];
	assign ExpandedKey[63:32] = ExpandedKey[95:64] ^ KEY_D[63:32];
	assign ExpandedKey[31:0] = ExpandedKey[63:32] ^ KEY_D[31:0];

	always @( posedge clk , negedge resetn )
		begin
			if( resetn == 0 )
				begin
					ExpandedKey_D  <= 128'h0;
					Rcon_D <= 8'h0;
					KEY_D <= 128'h0;
				end
			else
				if( start == 1)	
					begin
						ExpandedKey_D <= ExpandedKey ;
						Rcon_D <= Rcon;
						KEY_D <= KEY;
					end
		end

endmodule
