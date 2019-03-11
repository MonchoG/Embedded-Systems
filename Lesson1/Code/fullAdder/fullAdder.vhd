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

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.0.0 Build 614 04/24/2018 SJ Lite Edition"
-- CREATED		"Sun Sep 09 15:07:04 2018"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY fullAdder IS 
	PORT
	(
		A2 :  IN  STD_LOGIC;
		B2 :  IN  STD_LOGIC;
		A1 :  IN  STD_LOGIC;
		B1 :  IN  STD_LOGIC;
		Sum1 :  OUT  STD_LOGIC;
		Sum2 :  OUT  STD_LOGIC;
		Carry1 :  OUT  STD_LOGIC
	);
END fullAdder;

ARCHITECTURE bdf_type OF fullAdder IS 

SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;


BEGIN 



Sum1 <= A2 XOR B2;


SYNTHESIZED_WIRE_6 <= SYNTHESIZED_WIRE_8 AND A1;


SYNTHESIZED_WIRE_4 <= B1 AND SYNTHESIZED_WIRE_8;


Sum2 <= SYNTHESIZED_WIRE_2 XOR SYNTHESIZED_WIRE_8;


SYNTHESIZED_WIRE_7 <= SYNTHESIZED_WIRE_4 OR SYNTHESIZED_WIRE_5;


Carry1 <= SYNTHESIZED_WIRE_6 OR SYNTHESIZED_WIRE_7;


SYNTHESIZED_WIRE_8 <= A2 AND B2;


SYNTHESIZED_WIRE_2 <= A1 XOR B1;


SYNTHESIZED_WIRE_5 <= A1 AND B1;


END bdf_type;