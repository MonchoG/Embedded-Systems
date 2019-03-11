library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nios2leds is
	port (
			CLK_50                              : in  std_logic                    := '0';             --                           clk.clk
			SW : in  std_logic_vector(3 downto 0) := (others => '0'); -- dipsw_pio_external_connection.export
			KEY   : in  std_logic_vector(1 downto 0) := (others => '0'); --   key_pio_external_connection.export
			LED   : out std_logic_vector(7 downto 0)                    --   led_pio_external_connection.export
		);
end entity nios2leds;

architecture structure of nios2leds is

	signal debounced_key: std_logic_vector(1 downto 0);
	signal por_reset : std_logic;
	signal por_reset_n : std_logic;
	signal led_internal :std_logic_vector (7downto 0);
	signal pwm_internal : std_logic;
	
	component HostSystem is
		port (
			clk_clk                              : in  std_logic                    := '0';             -- clk
			reset_reset_n                        : in  std_logic                    := '0';             -- reset_n
			dipsw_pio_external_connection_export : in  std_logic_vector(3 downto 0) := (others => '0'); -- export
			key_pio_external_connection_export   : in  std_logic_vector(1 downto 0) := (others => '0');  -- export
		   led_pio_external_connection_export   : out std_logic_vector(7 downto 0);                    -- export
			led_pwm_conduit_export					 : out std_logic -- PWM Conduit

		);
	end component HostSystem;
	
	component debounce is
		GENERIC ( WIDTH : INTEGER :=2;
					 POLARITY : STRING := "LOW";
					 TIMEOUT : INTEGER := 50000;
					 TIMEOUT_WIDTH : INTEGER := 16
					 );
					 
		PORT(
			clk : in std_logic;
			reset_n : in std_logic;
			data_in : in std_logic_vector(WIDTH-1 DOWNTO 0);
			data_out : out std_logic_vector(WIDTH-1 DOWNTO 0)
			);
	end component debounce;
		
		
	component POR
			PORT(
					clk : in std_logic;
					por_out : out std_logic
					);
		end component POR;
		
begin
	por_reset_n <= not por_reset;
	u0 : HostSystem port map (CLK_50, por_reset_n, SW, debounced_key, led_internal, pwm_internal);
	u1 : debounce port map (CLK_50, por_reset_n, KEY, debounced_key);
	u2 : POR port map (CLK_50, por_reset);
	LED(6 downto 0) <= led_internal (6 downto 0);
	LED(7) <= pwm_internal;
	
end architecture structure;
