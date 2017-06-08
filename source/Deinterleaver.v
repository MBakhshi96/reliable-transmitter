module Deinterleaver (
				input in,
				input clk,
				input reset,//active low
				output reg data_valid,
				output reg [10:0]counter,//index of serial output
				output reg [127:0] ParOutput,//paralel output
				output SerialOutput//serial output
				);
				reg [127:0] mem;
				integer i,j,k,j1,k1;
				always @(posedge clk) begin
					if (~reset)begin
						ParOutput <= 0;
						counter <= 0;
						data_valid <= 0;
					end
					else begin
						if (counter == 127) begin
							data_valid <= 1;
							mem <= ParOutput;
						end
						else mem <= {1'b0,mem[127:1]};
						
							counter <= counter + 1;
							
						for( i = 0; i < 127 ; i=i+1)
						begin
							j=i>>4;
							k=(i-(j<<4))<<3;
							j1 = (i+1)>>4;
							k1 =(i+1-(j1<<4))<<3;
							ParOutput [j+k] <= ParOutput [j1+k1];
						end
						ParOutput [127] <= in;   
					end
				end
				
				assign SerialOutput = mem[0];
				
endmodule
