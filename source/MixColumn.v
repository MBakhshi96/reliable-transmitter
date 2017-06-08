module MixColumn( InState , OutState );
	
	input [127:0] InState;
	output [127:0] OutState;

	wire [127:0] InState;
	wire [127:0] OutState;
	
	
	
	//Galois Multiplication functions ( just mult. by 2 and 3 is implemented )
	
	function [7:0] Gmult2;
		input [7:0] In1;
		begin
			Gmult2 = {In1[6 : 0], 1'b0} ^ (8'b00011011 & {8{In1[7]}});
		end
	endfunction
	
	function [7:0] Gmult3;
		input [7:0] In1;
		begin
			Gmult3 = Gmult2( In1 ) ^ In1 ;
		end
	endfunction
	
	//---------------------------------------------------------------------
	
	assign OutState[127:120] = Gmult2( InState[127:120] ) ^ Gmult3( InState[119:112] ) ^ InState[111:104] ^ InState[103:96] ;
	assign OutState[119:112] = InState[127:120] ^ Gmult2( InState[119:112] ) ^ Gmult3( InState[111:104] ) ^ InState[103:96] ;
	assign OutState[111:104] = InState[127:120] ^ InState[119:112] ^ Gmult2( InState[111:104] ) ^ Gmult3( InState[103:96] ) ;
	assign OutState[103:96] = Gmult3( InState[127:120] ) ^ InState[119:112] ^ InState[111:104] ^ Gmult2( InState[103:96] ) ;
	assign OutState[95:88] = Gmult2( InState[95:88] ) ^ Gmult3( InState[87:80] ) ^ InState[79:72] ^ InState[71:64] ;
	assign OutState[87:80] = InState[95:88] ^ Gmult2( InState[87:80] ) ^ Gmult3( InState[79:72] ) ^ InState[71:64] ;
	assign OutState[79:72] = InState[95:88] ^ InState[87:80] ^ Gmult2( InState[79:72] ) ^ Gmult3( InState[71:64] ) ;
	assign OutState[71:64] = Gmult3( InState[95:88] ) ^ InState[87:80] ^ InState[79:72] ^ Gmult2( InState[71:64] ) ;
	assign OutState[63:56] = Gmult2( InState[63:56] ) ^ Gmult3( InState[55:48] ) ^ InState[47:40] ^ InState[39:32] ;
	assign OutState[55:48] = InState[63:56] ^ Gmult2( InState[55:48] ) ^ Gmult3( InState[47:40] ) ^ InState[39:32] ;
	assign OutState[47:40] = InState[63:56] ^ InState[55:48] ^ Gmult2( InState[47:40] ) ^ Gmult3( InState[39:32] ) ;
	assign OutState[39:32] = Gmult3( InState[63:56] ) ^ InState[55:48] ^ InState[47:40] ^ Gmult2( InState[39:32] ) ;
	assign OutState[31:24] = Gmult2( InState[31:24] ) ^ Gmult3( InState[23:16] ) ^ InState[15:8] ^ InState[7:0] ;
	assign OutState[23:16] = InState[31:24] ^ Gmult2( InState[23:16] ) ^ Gmult3( InState[15:8] ) ^ InState[7:0] ;
	assign OutState[15:8] = InState[31:24] ^ InState[23:16] ^ Gmult2( InState[15:8] ) ^ Gmult3( InState[7:0] ) ;
	assign OutState[7:0] = Gmult3( InState[31:24] ) ^ InState[23:16] ^ InState[15:8] ^ Gmult2( InState[7:0] ) ;
	
	
	
endmodule
		