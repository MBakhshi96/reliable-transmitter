module ShiftRow( InState , OutState );
	
	input [127:0] InState ;
	output [127:0] OutState ;

	wire [127:0] InState ;
	wire [127:0] OutState ;

	assign OutState[127:120] = InState[127:120];
	assign OutState[119:112] = InState[87:80];
	assign OutState[111:104] = InState[47:40];
	assign OutState[103:96] = InState[7:0];
	assign OutState[95:88] = InState[95:88];
	assign OutState[87:80] = InState[55:48];
	assign OutState[79:72] = InState[15:8];
	assign OutState[71:64] = InState[103:96];
	assign OutState[63:56] = InState[63:56];
	assign OutState[55:48] = InState[23:16];
	assign OutState[47:40] = InState[111:104];
	assign OutState[39:32] = InState[71:64];
	assign OutState[31:24] = InState[31:24];
	assign OutState[23:16] = InState[119:112];
	assign OutState[15:8] = InState[79:72];
	assign OutState[7:0] = InState[39:32];

endmodule
