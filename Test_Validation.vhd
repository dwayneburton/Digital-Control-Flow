-- Import IEEE standard logic library
library ieee;
use ieee.std_logic_1164.all;

-- Entity for validating output logic of a comparator
-- Checks if comparator outputs match the actual input comparisons
entity Test_Validation is
	port (
		MC_TESTMODE				: in std_logic;						-- Test enable signal
		I1EQI2, I1GTI2, I1LTI2	: in std_logic;						-- Comparator outputs (equal, greater than, less than)
		input1, input2			: in std_logic_vector(3 downto 0);	-- 4-bit inputs to be compared
		TEST_PASS  				: out std_logic						-- Pass signal if comparison is correct						 
	);
end Test_Validation;

-- Architecture checks correctness of comparator outputs during test mode
architecture Test_ckt of Test_Validation is
	-- Internal flags for each type of pass condition
	signal EQ_PASS, GT_PASS, LT_PASS : std_logic;

begin
	Test_Validation1: 
	PROCESS (MC_TESTMODE, input1, input2, I1EQI2, I1GTI2, I1LTI2) is
	begin
		-- Compare inputs and validate corresponding comparator output
		IF ((input1 = input2) AND (I1EQI2 = '1')) THEN 
			EQ_PASS <= '1';
			GT_PASS <= '0'; 
			LT_PASS <= '0';
		
		ELSIF ((input1 > input2) AND (I1GTI2 = '1')) THEN  
			GT_PASS <= '1';
			EQ_PASS <= '0'; 
			LT_PASS <= '0';
		
		ELSIF ((input1 < input2) AND (I1LTI2 = '1')) THEN  
			LT_PASS <= '1';
			EQ_PASS <= '0'; 
			GT_PASS <= '0'; 
		
		ELSE
			EQ_PASS <= '0'; 
			GT_PASS <= '0'; 
			LT_PASS <= '0';
		END IF;

		-- Test passes only if test mode is active and one valid comparison matches
		TEST_PASS <= MC_TESTMODE AND (EQ_PASS OR GT_PASS OR LT_PASS);
	end process;
end;