
library ieee;
use ieee.std_logic_1164.ALL;

entity FF_T_ENABLE is
	port(
		T	    : in std_logic;
		ENABLE : in std_logic;
		CLK    : in std_logic;
		CLEAR  : in std_logic;
		PRESET : in std_logic;
		Q      : out std_logic	
	);
end FF_T_ENABLE;

architecture RTL of FF_T_ENABLE is

	signal QINTERNAL: std_logic;
	
begin

	Q <= QINTERNAL;

	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			if PRESET = '1' then
				QINTERNAL <= '1';
			else
				if CLEAR = '1' then
					QINTERNAL <= '0';
				else
					if ENABLE = '1' then
						if T = '1' then
							QINTERNAL <= not QINTERNAL;
						elsif T = '0' then
							QINTERNAL <= QINTERNAL;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

end RTL;

