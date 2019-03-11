	component HostSystem is
		port (
			clk_clk                           : in    std_logic                     := 'X';             -- clk
			hex_0_external_connection_export  : out   std_logic_vector(7 downto 0);                     -- export
			hex_1_external_connection_export  : out   std_logic_vector(7 downto 0);                     -- export
			hex_2_external_connection_export  : out   std_logic_vector(7 downto 0);                     -- export
			hex_3_external_connection_export  : out   std_logic_vector(7 downto 0);                     -- export
			hex_4_external_connection_export  : out   std_logic_vector(7 downto 0);                     -- export
			hex_5_external_connection_export  : out   std_logic_vector(7 downto 0);                     -- export
			hex_6_external_connection_export  : out   std_logic_vector(7 downto 0);                     -- export
			hex_7_external_connection_export  : out   std_logic_vector(7 downto 0);                     -- export
			keys_external_connection_export   : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			lcd_external_RS                   : out   std_logic;                                        -- RS
			lcd_external_RW                   : out   std_logic;                                        -- RW
			lcd_external_data                 : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- data
			lcd_external_E                    : out   std_logic;                                        -- E
			switch_external_connection_export : in    std_logic_vector(17 downto 0) := (others => 'X')  -- export
		);
	end component HostSystem;

	u0 : component HostSystem
		port map (
			clk_clk                           => CONNECTED_TO_clk_clk,                           --                        clk.clk
			hex_0_external_connection_export  => CONNECTED_TO_hex_0_external_connection_export,  --  hex_0_external_connection.export
			hex_1_external_connection_export  => CONNECTED_TO_hex_1_external_connection_export,  --  hex_1_external_connection.export
			hex_2_external_connection_export  => CONNECTED_TO_hex_2_external_connection_export,  --  hex_2_external_connection.export
			hex_3_external_connection_export  => CONNECTED_TO_hex_3_external_connection_export,  --  hex_3_external_connection.export
			hex_4_external_connection_export  => CONNECTED_TO_hex_4_external_connection_export,  --  hex_4_external_connection.export
			hex_5_external_connection_export  => CONNECTED_TO_hex_5_external_connection_export,  --  hex_5_external_connection.export
			hex_6_external_connection_export  => CONNECTED_TO_hex_6_external_connection_export,  --  hex_6_external_connection.export
			hex_7_external_connection_export  => CONNECTED_TO_hex_7_external_connection_export,  --  hex_7_external_connection.export
			keys_external_connection_export   => CONNECTED_TO_keys_external_connection_export,   --   keys_external_connection.export
			lcd_external_RS                   => CONNECTED_TO_lcd_external_RS,                   --               lcd_external.RS
			lcd_external_RW                   => CONNECTED_TO_lcd_external_RW,                   --                           .RW
			lcd_external_data                 => CONNECTED_TO_lcd_external_data,                 --                           .data
			lcd_external_E                    => CONNECTED_TO_lcd_external_E,                    --                           .E
			switch_external_connection_export => CONNECTED_TO_switch_external_connection_export  -- switch_external_connection.export
		);

