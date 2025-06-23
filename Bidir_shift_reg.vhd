-- Import standard logic and numeric libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Entity for an 8-bit bidirectional shift register
-- Supports left and right shifting based on control input
Entity Bidir_shift_reg is 
	port (
		CLK				: in std_logic := '0';
		RESET			: in std_logic := '0';
		CLK_EN			: in std_logic := '0';
		LEFT0_RIGHT1	: in std_logic := '0';
		REG_BITS		: out std_logic_vector(7 downto 0)
	);
end Entity;

-- Architecture implements the shift register behavior	
ARCHITECTURE one OF Bidir_shift_reg IS
	-- Internal shift register storage
	SIGNAL sreg	: std_logic_vector(7 downto 0);
BEGIN
	-- Process triggered on rising edge of the clock
	process (CLK) is
	begin
		if(rising_edge(CLK)) then
			if(RESET = '1') then
				sreg <= "00000000";									-- Reset register to all zeros
			elsif(CLK_EN = '1') then
				if(LEFT0_RIGHT1 = '1') then
					sreg (7 downto 0) <= '1' & sreg(7 downto 1);	-- Shift right, insert '1' on MSB
				else
					sreg (7 downto 0) <= sreg(6 downto 0) & '0';	-- Shift left, insert '0' on LSB
				end if;
			end if;
		end if;
		REG_BITS <= sreg;											-- Output current register contents
	end process;
END one;