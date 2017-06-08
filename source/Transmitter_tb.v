`timescale 1ns / 1ps

module Transmitter_tb;

	// Inputs
	reg clock;
	reg resetn;
	reg input_valid;
	reg [31:0] input_num;
	// Outputs
	wire Tx_out;
	wire ready_for_input;
	wire [15:0]cordic_out;
	wire [127:0]AES_out;
	wire [127:0]interleaver_out;
	
	
	
	//
	integer file_input , file_output , result , a , b , file_output_Tx , file_output_cordic , file_output_AES , file_output_interleaver ;
	
	integer i=0;
	// Instantiate the Unit Under Test (UUT)
	Transmitter uut( clock , resetn , input_valid , input_num , Tx_out , ready_for_input , cordic_out , AES_out , interleaver_out );
	
	
	always 
		#10 clock = ~clock;
		
	initial begin
		// Initialize Inputs
		clock = 0;
		resetn = 1;
		input_valid = 0;
		input_num = 32'h0;
		
		

		file_input = $fopen( "input.txt" , "r" );
		file_output_Tx = $fopen( "output_Tx.txt" , "w" );
		file_output_cordic = $fopen( "output_cordic.txt" , "w" );
		file_output_AES = $fopen( "output_AES.txt" , "w" );
		file_output_interleaver = $fopen( "output_interleaver.txt" , "w" );
		
		
	
		// Wait 100 ns for global reset to finish
		#20 resetn = 0 ;
		#10 resetn = 1 ;
      		
		
		// Add stimulus here

	end
    
	always @(posedge clock)
		begin	
			#0.01
			if ( ready_for_input == 1 )
				begin
					input_valid = 1;	
					a = $fscanf(file_input , "%h\n", input_num );
				end
			else
				begin
					input_valid = 0;
				end
		end
	
	always @(posedge clock)
		begin
			#0.01 
			
			$fwrite(file_output_Tx,"%h\n",Tx_out);
			$fwrite(file_output_cordic,"%h\n",cordic_out);
			$fwrite(file_output_AES,"%h\n",AES_out);
			$fwrite(file_output_interleaver,"%h\n",interleaver_out);
		end
			
endmodule

