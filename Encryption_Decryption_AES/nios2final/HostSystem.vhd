-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

library ieee;
use ieee.std_logic_1164.all;
library altera;
use altera.altera_syn_attributes.all;

entity HostSystem is
	port
	(
-- {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!

		altera_reserved_tck : in std_logic;
		altera_reserved_tdi : in std_logic;
		altera_reserved_tdo : out std_logic;
		altera_reserved_tms : in std_logic;
		clk_clk : in std_logic;
		hex_0_external_connection_export : out std_logic_vector(7 downto 0);
		hex_1_external_connection_export : out std_logic_vector(7 downto 0);
		hex_2_external_connection_export : out std_logic_vector(7 downto 0);
		hex_3_external_connection_export : out std_logic_vector(7 downto 0);
		hex_4_external_connection_export : out std_logic_vector(7 downto 0);
		hex_5_external_connection_export : out std_logic_vector(7 downto 0);
		hex_6_external_connection_export : out std_logic_vector(7 downto 0);
		hex_7_external_connection_export : out std_logic_vector(7 downto 0);
		keys_external_connection_export : in std_logic_vector(3 downto 0);
		lcd_external_data : inout std_logic_vector(7 downto 0);
		lcd_external_E : out std_logic;
		lcd_external_RS : out std_logic;
		lcd_external_RW : out std_logic;
		switch_external_connection_export : in std_logic_vector(17 downto 0)
-- {ALTERA_IO_END} DO NOT REMOVE THIS LINE!

	);

-- {ALTERA_ATTRIBUTE_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_ATTRIBUTE_END} DO NOT REMOVE THIS LINE!
end HostSystem;

architecture ppl_type of HostSystem is

-- {ALTERA_COMPONENTS_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_COMPONENTS_END} DO NOT REMOVE THIS LINE!
begin
-- {ALTERA_INSTANTIATION_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_INSTANTIATION_END} DO NOT REMOVE THIS LINE!

end;
