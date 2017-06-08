module decoder(
			input  in,
			input clk,
			input reset,
			output  out
			);
			
			reg  Tb [1:6];
			
			always @(posedge clk) begin
			
				if (~reset)begin
					Tb [1] <= 0;
					Tb [2] <= 0;
					Tb [3] <= 0;
					Tb [4] <= 0;
					Tb [5] <= 0;
					Tb [6] <= 0;
				end
				else begin
					Tb [1] <= in;
					Tb [2] <= Tb [1];
					Tb [3] <= Tb [2];
					Tb [4] <= Tb [3];
					Tb [5] <= Tb [4];
					Tb [6] <= Tb [5];
				end                
				
			end	
							
			assign out = in ^Tb [1] ^Tb [2] ^Tb [3] ^Tb [6];
			
endmodule
