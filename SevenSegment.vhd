-- Import standard logic and numeric libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity declaration for a 7-segment display driver
-- Converts a 4-bit binary input into the corresponding 7-segment display pattern
entity SevenSegment is
	port (
		hex      : in  std_logic_vector(3 downto 0);   -- 4-bit input to be displayed
		sevenseg : out std_logic_vector(6 downto 0)    -- 7-segment display output (active high)
	); 
end SevenSegment;

-- Architecture implements combinational logic to drive 7-segment display
architecture Behavioral of SevenSegment is
begin
	-- Output segment pattern determined by 4-bit input
	with hex select 
		sevenseg <=
			"0111111" when "0000",  -- 0
			"0000110" when "0001",  -- 1
			"1011011" when "0010",  -- 2
			"1001111" when "0011",  -- 3
			"1100110" when "0100",  -- 4
			"1101101" when "0101",  -- 5
			"1111101" when "0110",  -- 6
			"0000111" when "0111",  -- 7
			"1111111" when "1000",  -- 8
			"1101111" when "1001",  -- 9
			"1110111" when "1010",  -- A
			"1111100" when "1011",  -- b
			"1011000" when "1100",  -- c
			"1011110" when "1101",  -- d
			"1111001" when "1110",  -- E
			"1110001" when "1111",  -- F
			"0000000" when others;  -- Blank/default
end architecture Behavioral;