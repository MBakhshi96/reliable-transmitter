module interleaver (
				input in,
				input clk,
				input reset,//active low
				input start,
				//output reg [10:0]IndexSerial,//index of serial output
				output reg [127:0] ParOut,//paralel output
				output reg data_valid
				//output SerialOut//serial output
				);
				//reg [127:0] mem;
				reg [10:0] IndexSerial;
				integer i,j,k,j1,k1;
				
				always @(posedge clk , negedge reset ) begin
					if (reset == 0)begin
						ParOut <= 0;
						IndexSerial <= 0;
						data_valid <= 0;
					end
					else if( start == 0 && ( IndexSerial != 128 ) ) begin
						ParOut <= 0;
						IndexSerial <= 0;
						data_valid <= 0;
					end
					else begin
						if (IndexSerial == 128) begin
							data_valid <= 1;
							//mem <= ParOut;
						end else	
								data_valid <= 0;
						//else mem <= {1'b0,mem[127:1]};
						IndexSerial <= IndexSerial + 1;
						for( i = 0; i < 127 ; i=i+1)
						begin
							j=i>>3;
							k=(i-(j<<3))<<4;
							j1 = (i+1)>>3;
							k1 =(i+1-(j1<<3))<<4;
							ParOut [j+k] <= ParOut [j1+k1];
						end
						ParOut[127] <= in;
					end
				end
				
				//assign SerialOut = mem[0];
	
endmodule
