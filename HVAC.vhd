-- Import standard logic and numeric libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity for a basic HVAC simulation module
-- Supports runtime temperature control using simulated or divided clock
entity HVAC is
	port (
		HVAC_SIM	: in boolean;						-- Selects between simulation or real-time clock
		clk			: in std_logic;						-- 50 MHz base clock input
		run			: in std_logic;						-- Enable signal to activate temperature control
		increase	: in std_logic;						-- Input signal to increase temperature
		decrease	: in std_logic;						-- Input signal to decrease temperature
		temp		: out std_logic_vector (3 downto 0)	-- 4-bit output representing temperature
	);
end entity;

-- Architecture generates a 2 Hz clock, supports clock selection, and drives a temperature counter
architecture rtl of HVAC is
	signal clk_2hz			: std_logic;						-- 2 Hz derived clock from 50 MHz base
	signal HVAC_clock		: std_logic;						-- Selected clock
	signal digital_counter	: std_logic_vector(23 downto 0);	-- Intermediate counter for 2 Hz generation

begin
	-- Clock divider: converts 50 MHz clock to ~2 Hz using a 24-bit counter
	clk_divider: process (clk)
		variable counter : unsigned(23 downto 0);
	begin
		if (rising_edge(clk)) then
			counter :=  counter + 1;
		end if;
		digital_counter <= std_logic_vector(counter);		
	end process;
	
	-- Use MSB of counter to generate a 2 Hz clock signal
	clk_2hz <= digital_counter(23);

	-- Clock multiplexer selects either real-time 2 Hz clock or simulation clock
	clk_mux: process (HVAC_SIM)
	begin
		if (HVAC_SIM) then
			HVAC_clock<=  clk;
		else
			HVAC_clock<=  clk_2hz;
		end if;
	end process;

	-- Temperature counter process
	counter: process (HVAC_clock)
		variable cnt : unsigned(3 downto 0) := "0111";	-- Initialize temperature to 7
	begin
	-- Output current temperature value	
		temp <= std_logic_vector(cnt);		
	end process;
end rtl;