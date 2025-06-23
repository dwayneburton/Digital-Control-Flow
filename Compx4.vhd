-- Import standard logic library
library ieee;
use ieee.std_logic_1164.all;

-- Entity for a 4-bit magnitude comparator
-- Compares two 4-bit binary numbers and outputs Less, Equal, or Greater
entity Compx4 is
	port (
		A_Input	: in std_logic_vector(3 downto 0);	-- First 4-bit input
		B_Input	: in std_logic_vector(3 downto 0);	-- Second 4-bit input
		led	: out std_logic_vector(2 downto 0)		-- Output LEDs for Less, Equal, Greater
	);
end entity Compx4;

-- Architecture using four 1-bit comparators to evaluate each bit from MSB to LSB
architecture logic_compare of Compx4 is
	-- 1-bit comparator component
	component Compx1
		port (
			A_In		: in std_logic;
			B_In		: in std_logic;
			Less_Out	: out std_logic;
			Equal_Out	: out std_logic;
			Greater_Out	: out std_logic
		); 
	end component Compx1;

	-- Signals for intermediate comparator outputs
	signal Less		: std_logic_vector(3 downto 0);
	signal Equal	: std_logic_vector(3 downto 0);
	signal Greater	: std_logic_vector(3 downto 0);
	
begin
	-- Instantiate four 1-bit comparators for bitwise comparison
	INST1: Compx1 port map (A_Input(3), B_Input(3), Less(3), Equal(3), Greater(3));
	INST2: Compx1 port map (A_Input(2), B_Input(2), Less(2), Equal(2), Greater(2));
	INST3: Compx1 port map (A_Input(1), B_Input(1), Less(1), Equal(1), Greater(1));
	INST4: Compx1 port map (A_Input(0), B_Input(0), Less(0), Equal(0), Greater(0));

	-- Determine final comparison result by evaluating MSB-first priority
	led(0) <= Less(3) or (Equal(3) and Less(2)) or (Equal(3) and Equal(2) and Less(1)) or (Equal(3) and Equal(2) and Equal(1) and Less(0));
	led(1) <= (Equal(3) and Equal(2) and Equal(1) and Equal(0));
	led(2) <= Greater(3) or (Equal(3) and Greater(2)) or (Equal(3) and Equal(2) and Greater(1)) or (Equal(3) and Equal(2) and Equal(1) and Greater(0));
end logic_compare;