module UART_tx ( start , clk , resetn , data_in , data_out , ready );
	
	parameter BAUDRATE_GEN = 10'd433; 		//suppose clk is 100 MHz => 100MHz/868 = 115207 (error = 0.006% )
	
	parameter idle_state = 2'b00 ,
			  start_state = 2'b01 ,
			  transmit_state = 2'b10 ,
			  stop_state = 2'b11 ;
	
	input start, clk , resetn;
	input [7:0]data_in;
	output reg data_out, ready ;
	
	
	reg [9:0]counter;
	reg [2:0]bit_counter;
	reg [7:0]data_in_d;
	reg [2:0]CS;

	wire send;

	always @(posedge clk , negedge resetn )
		begin
			if( resetn == 0 )
				begin
					counter <= 10'h0;
				end
			else if( start == 1 )
					counter <= 10'h0;
			else if( counter != BAUDRATE_GEN )
					counter <= counter + 10'h1;
				else
					counter <= 10'h0;
		end
	
	assign send = ( counter == BAUDRATE_GEN );
		
	always @( posedge clk , negedge resetn )
		begin
			if( resetn == 0 )
				CS <= idle_state;
			else
				case( CS )
					idle_state : 
						begin	
							data_out <= 1'b1;
							ready <= 1'b1;
							if( start == 1 )
								CS <= start_state;
						end
					start_state :
						begin	
							data_out <= 1'b0 ;
							ready <= 1'b0;
							data_in_d <= data_in;
							if( send == 1 )
								begin
									CS <= transmit_state;
									bit_counter <= 3'b000;
								end
						end
					transmit_state :
						begin	
							data_out <= data_in_d[0];
							if( send == 1 )
								begin
									if( bit_counter == 3'd7 )
										begin
											CS <= stop_state;
											bit_counter <= 3'b0;
										end
									else
										begin	
											bit_counter <= bit_counter + 3'b001;
											data_in_d <= {1'b0,data_in_d[7:1]};
										end
								end
							
						end
					stop_state :
						begin
							data_out <= 1'b1;
							if( send == 1 )
									CS <= idle_state;
						
						end	
				endcase
							
		end
		
	
	
	
endmodule
	
	
