module ByteSub( clk , resetn , start , InState , OutState );
	input clk , resetn , start;
	input [127:0] InState;

	output [127:0] OutState;
	
	wire [7:0]SBOX_out1;
	wire [7:0]SBOX_out2;
	
	reg [111:0] MidState;
	reg [127:0] OutState;	
	reg [2:0]counter;
	
	reg [7:0]SBOX_in1;
	reg [7:0]SBOX_in2;
	
	always @( posedge clk , negedge resetn )
		begin
			if( resetn == 0 ) 
				counter <= 3'b000;
			else if( start == 1 )
				counter <= 3'b000;
			else
				counter <= counter + 3'b001 ;
		end
		
	EncryptionSBOX SBOX1 ( SBOX_in1 , SBOX_out1 );	
	EncryptionSBOX SBOX2 ( SBOX_in2 , SBOX_out2 );
		
	always @(*)
		begin
			case ( counter )
				3'b000: begin
					SBOX_in1 = InState[7:0];
					SBOX_in2 = InState[15:8];
				end
				3'b001: begin
					SBOX_in1 = InState[23:16];
					SBOX_in2 = InState[31:24];
				end
				3'b010: begin
					SBOX_in1 = InState[39:32];
					SBOX_in2 = InState[47:40];
				end
				3'b011: begin
					SBOX_in1 = InState[55:48];
					SBOX_in2 = InState[63:56];
				end
				3'b100: begin
					SBOX_in1 = InState[71:64];
					SBOX_in2 = InState[79:72];
				end
				3'b101: begin
					SBOX_in1 = InState[87:80];
					SBOX_in2 = InState[95:88];
				end
				3'b110: begin
					SBOX_in1 = InState[103:96];
					SBOX_in2 = InState[111:104];
				end
				3'b111: begin
					SBOX_in1 = InState[119:112];
					SBOX_in2 = InState[127:120];
				end
			endcase
		end	
		
	always @( posedge clk , negedge resetn )
		begin
			if( resetn == 0)
				OutState <= 128'h0;
			else
				case( counter )
					3'b000: begin
						MidState[7:0]  <= SBOX_out1;
						MidState[15:8] <= SBOX_out2;
					end
					3'b001: begin
						MidState[23:16] <= SBOX_out1;
						MidState[31:24] <= SBOX_out2;
					end
					3'b010: begin
						MidState[39:32] <= SBOX_out1;
						MidState[47:40] <= SBOX_out2;
					end
					3'b011: begin
						MidState[55:48] <= SBOX_out1;
						MidState[63:56] <= SBOX_out2;
					end
					3'b100: begin
						MidState[71:64] <= SBOX_out1;
						MidState[79:72] <= SBOX_out2;
					end
					3'b101: begin
						MidState[87:80] <= SBOX_out1;
						MidState[95:88] <= SBOX_out2;
					end
					3'b110: begin
						MidState[103:96] <= SBOX_out1;
						MidState[111:104] <= SBOX_out2;
					end
					3'b111: begin
						OutState <= { SBOX_out2 , SBOX_out1 , MidState };
					end
				endcase
		end

endmodule

	