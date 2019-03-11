
module HostSystem (
	clk_clk,
	hex_0_external_connection_export,
	hex_1_external_connection_export,
	hex_2_external_connection_export,
	hex_3_external_connection_export,
	hex_4_external_connection_export,
	hex_5_external_connection_export,
	hex_6_external_connection_export,
	hex_7_external_connection_export,
	keys_external_connection_export,
	lcd_external_RS,
	lcd_external_RW,
	lcd_external_data,
	lcd_external_E,
	switch_external_connection_export);	

	input		clk_clk;
	output	[7:0]	hex_0_external_connection_export;
	output	[7:0]	hex_1_external_connection_export;
	output	[7:0]	hex_2_external_connection_export;
	output	[7:0]	hex_3_external_connection_export;
	output	[7:0]	hex_4_external_connection_export;
	output	[7:0]	hex_5_external_connection_export;
	output	[7:0]	hex_6_external_connection_export;
	output	[7:0]	hex_7_external_connection_export;
	input	[3:0]	keys_external_connection_export;
	output		lcd_external_RS;
	output		lcd_external_RW;
	inout	[7:0]	lcd_external_data;
	output		lcd_external_E;
	input	[17:0]	switch_external_connection_export;
endmodule
