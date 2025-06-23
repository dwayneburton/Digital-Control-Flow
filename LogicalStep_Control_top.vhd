-- Import standard logic libraries
library ieee;
use ieee.std_logic_1164.all;

-- Connects display, shift register, and I/O components
entity LogicalStep_Control_top is
	port (
		clkin_50		: in std_logic;						-- 50 MHz onboard clock input
		pb_n			: in std_logic_vector(3 downto 0);	-- Active-low push buttons
 		sw				: in std_logic_vector(7 downto 0);	-- 8-bit slide switch input
		-- HVAC_temp	: out std_logic_vector(3 downto 0);	-- Optional: Uncomment for simulation only
		leds			: out std_logic_vector(7 downto 0);	-- 8-bit LED output
		seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
		seg7_char1  	: out std_logic;					-- Digit select for first 7-segment
		seg7_char2  	: out std_logic				    	-- Digit select for second 7-segment
	
	); 
end LogicalStep_Control_top;

-- Architecture instantiates display and logic components
architecture design of LogicalStep_Control_top is
	-- 7-segment display decoder
	component SevenSegment 
		port (
			hex			: in std_logic_vector(3 downto 0);	-- 4-bit binary input
			sevenseg	: out std_logic_vector(6 downto 0)	-- 7-segment display output
		); 
	end component SevenSegment;

	-- 2-digit 7-segment multiplexer
	component segment7_mux
		port (
			clk		: in std_logic := '0';				-- Clock input
			DIN2	: in std_logic_vector(6 downto 0);	-- Second digit input
			DIN1	: in std_logic_vector(6 downto 0);	-- First digit input
			DOUT	: out std_logic_vector(6 downto 0);	-- Combined output
			DIG2	: out std_logic;					-- Enable signal for digit 2
			DIG1	: out std_logic						-- Enable signal for digit 1
		);
	end component segment7_mux;

	-- Optional components for simulation:
	-- component Test_Validation
		-- port (
			-- MC_TESTMODE			: in std_logic;
			-- I1EQI2,I1GTI2,I1LTI2	: in std_logic;
			-- input1				: in std_logic_vector(3 downto 0);
			-- input2				: in std_logic_vector(3 downto 0);
			-- TEST_PASS			: out std_logic							 
		--	); 
	--	end component;

	--component HVAC 
		--port (
			--	HVAC_SIM			: in boolean;
			--	clk					: in std_logic; 
			--	run					: in std_logic;
			--	increase, decrease	: in std_logic;
			--	temp				: out std_logic_vector (3 downto 0)
		--	);
	--end component;
	
	-- 4-bit magnitude comparator
	component Compx4
		port (
			A_Input	: in std_logic_vector(3 downto 0);	-- First operand
			B_Input	: in std_logic_vector(3 downto 0);	-- Second operand
			led	: out std_logic_vector(2 downto 0)		-- Comparison result LEDs
		); 
	end component Compx4;

	-- 8-bit bidirectional shift register
	component Bidir_shift_reg
		port (
			CLK				: in std_logic := '0';				-- Clock signal
			RESET			: in std_logic := '0';				-- Reset signal
			CLK_EN			: in std_logic := '0';				-- Clock enable
			LEFT0_RIGHT1	: in std_logic := '0';				-- Shift direction control
			REG_BITS		: out std_logic_vector(7 downto 0)	-- Shift register output
		);
	end component Bidir_shift_reg;

	-- Configuration constant
	constant HVAC_SIM : boolean := FALSE;	-- Set TRUE for simulation, FALSE for hardware

	-- Internal signals
	signal clk_in				: std_logic;					-- Global clock
	signal hex_A, hex_B			: std_logic_vector(3 downto 0);	-- Inputs for display
	signal hexA_7seg, hexB_7seg	: std_logic_vector(6 downto 0);	-- 7-segment encoded value

begin
	-- Assign the input clock
	clk_in <= clkin_50;

	-- Map switch values to inputs
	hex_A <= sw(3 downto 0);
	hex_B <= sw(7 downto 4);

	-- Component instantiations
	inst1: sevensegment port map (hex_A, hexA_7seg);												-- Display hex_A on 7-segment
	inst2: sevensegment port map (hex_B, hexB_7seg);												-- Display hex_B on 7-segment
	inst3: segment7_mux port map (clk_in, hexA_7seg, hexB_7seg, seg7_data, seg7_char2, seg7_char1);	-- Mux display
	--	inst4: Compx4 port map (hex_A, hex_B, leds(2 downto 0));									-- Optional: Comparator output
	inst5: Bidir_shift_reg port map (clk_in, not(pb_n(0)), sw(0), sw(1), leds(7 downto 0));			-- Shift register driven by buttons/switches
end design;