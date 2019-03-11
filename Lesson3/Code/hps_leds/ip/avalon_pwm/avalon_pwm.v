/*******************************************************************************
 *                                                                             *
 *                  Copyright (C) 2009 Altera Corporation                      *
 *                                                                             *
 * ALTERA, ARRIA, CYCLONE, HARDCOPY, MAX, MEGACORE, NIOS, QUARTUS & STRATIX    *
 * are Reg. U.S. Pat. & Tm. Off. and Altera marks in and outside the U.S.      *
 *                                                                             *
 * All information provided herein is provided on an "as is" basis,            *
 * without warranty of any kind.                                               *
 *                                                                             *
 * Module Name: avalon_pwm                     File Name: avalon_pwm.v         *
 *                                                                             *
 * Module Function: This file implements the custom peripheral for nios labs.  *
 *                                                                             *
 ******************************************************************************/

module avalon_pwm
(
	clk,
	reset,
	address,
	write,
	writedata,
	read,
	readdata,
	pwm_out
);

  //
	input  wire         clk;
	input  wire         reset;
	input  wire [ 9:0]  address;
  input  wire         write;
	input  wire [31:0]  writedata;
	input  wire         read;
	output reg  [31:0]  readdata;
	output wire         pwm_out;

	//
	parameter           duty_default    = 0 ;
	parameter           modulus_default = 0 ;
	parameter           debug           = 0 ;

	//
	reg [31:0]	        modulus;
	reg [31:0]	        duty;
	reg [31:0]          counter;
	reg                 pwm;
	//
	wire                modulus_en;
	wire                duty_en;



	//
	assign modulus_en   = !address[0] ;
	assign duty_en      =  address[0] ;
	assign pwm_out      = pwm;


	//
	always @(read or modulus_en or modulus or duty)
	if      (!read)
	  readdata = 'bx;
	else if (modulus_en)
		readdata = modulus;
	else
		readdata = duty;

	//
	always @(posedge clk or posedge reset)
	begin
		if (reset == 1)
		begin
			modulus <= modulus_default;
			duty    <= duty_default;
		end else begin
			if (modulus_en & write)
				modulus <= writedata;

			if (duty_en & & write)
				duty    <= writedata;
		end
	end

	always @(posedge clk or posedge reset)
	begin
		if (reset == 1) begin
			counter  <= 0;
			pwm      <= 0;
		end else begin
		  //
		  if (counter < duty) begin
		    pwm      <= 1;
		  end else begin
		    pwm      <= 0;
		  end

		  //
			if (counter < modulus) begin
				counter  <= counter + 1;
			end else begin
				counter  <= 0;
		  end
		end
	end


endmodule
