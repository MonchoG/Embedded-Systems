
module HostSystem (
	clk_clk,
	dipsw_pio_external_connection_export,
	key_pio_external_connection_export,
	led_pio_external_connection_export,
	led_pwm_conduit_export,
	reset_reset_n);	

	input		clk_clk;
	input	[3:0]	dipsw_pio_external_connection_export;
	input	[1:0]	key_pio_external_connection_export;
	output	[7:0]	led_pio_external_connection_export;
	output		led_pwm_conduit_export;
	input		reset_reset_n;
endmodule
