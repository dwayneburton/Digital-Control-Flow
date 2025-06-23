-- Import standard logic library
library ieee;
use ieee.std_logic_1164.all;

-- Entity for a 1-bit magnitude comparator
-- Compares two 1-bit inputs and outputs whether A < B, A = B, or A > B
entity Compx1 is
	port (
		A_In		: in std_logic;		-- First 1-bit input
		B_In		: in std_logic;		-- Second 1-bit input
		Less_Out	: out std_logic;	-- High if A < B
		Equal_Out	: out std_logic;	-- High if A = B
		Greater_Out	: out std_logic		-- High if A > B
	);
end entity Compx1;

-- Architecture implements basic 1-bit comparator logic using Boolean expressions
architecture magnitude_comparator of Compx1 is
begin
	Less_Out <= not(A_In) and B_In;
	Equal_Out <= A_In xnor B_In;
	Greater_Out <= A_In and not(B_In);
end magnitude_comparator;