module SubWord( clk , resetn , start , InKey , OutKey );
	input clk , resetn , start;
	input [31:0] InKey;

	output [31:0] OutKey;
	
	wire [7:0]SBOX_out;

	reg [23:0]MidKey;
	reg [31:0]OutKey;	
	reg [2:0]counter;
	
	reg [7:0]SBOX_in;
	
	always @( posedge clk , negedge resetn )
		begin
			if( resetn == 0 ) 
				counter <= 3'b000;
			else if( start == 1 )
				counter <= 3'b000;
			else
				counter <= counter + 3'b001 ;
		end
		
	EncryptionSBOX SBOX1 ( SBOX_in , SBOX_out );	
		
	always @(*)
		begin
			case ( counter )
				3'b000: 
					SBOX_in = InKey[7:0];
				3'b001: 
					SBOX_in = InKey[15:8];
				3'b010: 
					SBOX_in = InKey[23:16];
				3'b011:
					SBOX_in = InKey[31:24];
				default: SBOX_in = InKey[31:24];
			endcase
		end	
		
	always @( posedge clk , negedge resetn )
		begin
			if( resetn == 0 )
				OutKey <= 32'h0;
			else
				case( counter )
					3'b000: 
						MidKey[7:0]  <= SBOX_out;
					3'b001:
						MidKey[15:8] <= SBOX_out;
					3'b010: 
						MidKey[23:16] <= SBOX_out;
					3'b111:	
						OutKey <= { SBOX_out , MidKey };
				endcase
		end

endmodule

	