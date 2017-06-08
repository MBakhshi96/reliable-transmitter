//****changes made related to previous submit will be mentioned in comments
//**** 3 outputs added for observing signals
module Transmitter( clock , resetn , input_valid , input_num , Tx_out , ready_for_input , cordic_out , AES_out , interleaver_out );
	input clock , resetn , input_valid ;
	input [32:1] input_num;
	
	//****Rx_out changed to Tx out
	output Tx_out;
	output ready_for_input;
	output [15:0]cordic_out;
	output [127:0]AES_out;
	output [127:0]interleaver_out;
	
	
	
	wire cordic_AES_full;
	wire UART_ready;
	wire UART_start;
	wire interleaver_valid;
	wire [127:0]interleaver_out;
	wire encoder_out;
	wire AES_valid;
	wire [127:0]AES_out;
	wire [127:0]KEY;
	wire AES_start;
	wire AES_input_valid;
	wire cordic_valid;
	wire [15:0]cordic_out;
	wire enable_cordic;
	
	
	
	reg [127:0] cordic_AES_reg;
	reg [3:0] cordic_AES_counter;
	reg [6:0]encoder_counter;
	reg [2:0]AES_start_counter;
	reg [127:0] encoder_in;
	reg [3:0] UART_counter;
	reg [127:0] UART_buffer;
	
	
	reg enable_AES;
	reg encoder_start;
	reg interleaver_start;
	reg UART_busy;
	reg valid_buffer;
	reg encoder_enable;
	
	
	//KEY
	assign KEY = 128'h00112233445566778899aabbccddeeff;


	phase1_transmitter phase1_transmitter_instance( clock , resetn , input_valid , enable_cordic , input_num , cordic_out , cordic_valid);
	
	
	always @(posedge clock , negedge resetn )
		begin	
			if( resetn == 0 )
				begin	
					cordic_AES_reg <= 128'h0;
					cordic_AES_counter <= 4'h0;
				end	
			else
				begin
					if( ( cordic_AES_counter == 4'h8 ) && AES_start )
						begin
							cordic_AES_counter <= 4'h0;
						end
				
  					if( cordic_valid &&  ( cordic_AES_counter < 4'h8 ) && enable_cordic )
						begin
							cordic_AES_reg <= {cordic_out , cordic_AES_reg[127:16]};
							cordic_AES_counter <= cordic_AES_counter + 4'h1;
						end
				end
		end

	assign cordic_AES_full = ( cordic_AES_counter == 4'h8 ) ;
	assign AES_input_valid = ( cordic_AES_counter == 4'h8 ) ;
	//*** changed next assign ( ! added )
	assign enable_cordic = ( !cordic_AES_full ) && enable_AES 
	assign ready_for_input = enable_cordic; 
	
	always @(posedge clock, negedge resetn )
		begin	
			if(resetn ==  0 )
				AES_start_counter <= 3'b000;
			else
				AES_start_counter <= AES_start_counter + 3'b001;
		end
	
	assign AES_start = ( AES_start_counter == 3'b111 ) & enable_AES ;

	Encryption Encryption_instance( clock , resetn , AES_start , AES_input_valid , cordic_AES_reg , KEY , AES_out , AES_valid );
	
	always @(posedge clock , negedge resetn)
		begin
			if( resetn == 0)
				begin	
					encoder_in <= 128'h0;
					encoder_counter <= 7'h0;
					enable_AES <= 1'b1;
					encoder_start <= 1'b0;
					interleaver_start <= 1'b0;
				end
			else
				if( encoder_enable )
					begin
						interleaver_start <= encoder_start;
						if( AES_valid && AES_start )
							begin	
								encoder_in <= AES_out;
								encoder_counter <= 7'h0;
								enable_AES <= 1'b0;
								encoder_start <= 1'b1;
							end
						else
							begin
								if( encoder_counter < 7'd127)
									begin
										encoder_in <= encoder_in >> 1;
										encoder_counter <= encoder_counter + 7'h01;
									end
								else
									//*** one line added to else
									begin
										enable_AES <= 1'b1;
										encoder_start <= 1'b0;
									end
							end
					end
				else
					enable_AES <= 1'b0;
		end
	
	
	encoder encoder_instance( encoder_in[0] , clock & encoder_enable, resetn , encoder_out  );
	//*** interleavers inside a little modified 
	interleaver interleaver_instance( encoder_out , clock & encoder_enable, resetn , interleaver_start , interleaver_out , interleaver_valid );
	
	always @(posedge clock , negedge resetn )
		begin
			if( resetn == 0 )
				begin
					UART_counter <= 3'h0;
					UART_buffer <= 128'h0;
					valid_buffer <= 0;
					UART_busy <= 0;
					//*** next line is new 
					encoder_enable <= 1;
				end
			else
				begin
					if( interleaver_valid == 1 ) 
						begin
							if ( UART_busy == 0 )
								begin
									UART_counter <= 3'h0;
									UART_buffer <= interleaver_out;
									valid_buffer <= 1;
									UART_busy <= 1;
								end
							else
								begin
									encoder_enable <= 0;	
								end
						end
					else
						if( UART_ready )
							//*** inside of if's parantheses has been changed
							if( UART_counter < 4'd15 )
								begin
									UART_counter <= UART_counter + 4'h1;
									UART_buffer <= UART_buffer >> 8;  
								end
							else
								//*** one line added to else
								begin
									valid_buffer <= 0;
									UART_busy <= 0;
								end
				end
		end
	
	assign UART_start = valid_buffer && UART_ready;
	
	UART_tx UART_tx_instance( UART_start , clock , resetn , UART_buffer[7:0] , Tx_out , UART_ready);

endmodule


