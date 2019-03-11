	HostSystem u0 (
		.clk_clk                              (<connected-to-clk_clk>),                              //                           clk.clk
		.dipsw_pio_external_connection_export (<connected-to-dipsw_pio_external_connection_export>), // dipsw_pio_external_connection.export
		.key_pio_external_connection_export   (<connected-to-key_pio_external_connection_export>),   //   key_pio_external_connection.export
		.led_pio_external_connection_export   (<connected-to-led_pio_external_connection_export>),   //   led_pio_external_connection.export
		.led_pwm_conduit_export               (<connected-to-led_pwm_conduit_export>),               //               led_pwm_conduit.export
		.reset_reset_n                        (<connected-to-reset_reset_n>)                         //                         reset.reset_n
	);

