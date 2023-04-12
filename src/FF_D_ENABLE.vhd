
library ieee;
use ieee.std_logic_1164.all;

entity FF_D_ENABLE is
	port(
		D	    : in std_logic;
		ENABLE : in std_logic;
		CLK    : in std_logic;
		CLEAR  : in std_logic;
		PRESET : in std_logic;
		Q      : out std_logic	
	);
end FF_D_ENABLE;

architecture RTL of FF_D_ENABLE is

begin

	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			if PRESET = '1' then
				Q <= '1';
			else
				if CLEAR = '1' then 
					Q <= '0';
				else
					if ENABLE = '1' then
						Q <= D;
					end if;
				end if;
			end if;
		end if;
	end process;
	
end RTL;

