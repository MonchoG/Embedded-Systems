	component HostSystem is
		port (
			clk_clk                              : in  std_logic                    := 'X';             -- clk
			dipsw_pio_external_connection_export : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			key_pio_external_connection_export   : in  std_logic_vector(1 downto 0) := (others => 'X'); -- export
			led_pio_external_connection_export   : out std_logic_vector(7 downto 0);                    -- export
			led_pwm_conduit_export               : out std_logic;                                       -- export
			reset_reset_n                        : in  std_logic                    := 'X'              -- reset_n
		);
	end component HostSystem;

	u0 : component HostSystem
		port map (
			clk_clk                              => CONNECTED_TO_clk_clk,                              --                           clk.clk
			dipsw_pio_external_connection_export => CONNECTED_TO_dipsw_pio_external_connection_export, -- dipsw_pio_external_connection.export
			key_pio_external_connection_export   => CONNECTED_TO_key_pio_external_connection_export,   --   key_pio_external_connection.export
			led_pio_external_connection_export   => CONNECTED_TO_led_pio_external_connection_export,   --   led_pio_external_connection.export
			led_pwm_conduit_export               => CONNECTED_TO_led_pwm_conduit_export,               --               led_pwm_conduit.export
			reset_reset_n                        => CONNECTED_TO_reset_reset_n                         --                         reset.reset_n
		);

