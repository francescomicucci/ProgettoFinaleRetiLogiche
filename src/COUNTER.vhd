
library ieee;
use ieee.std_logic_1164.ALL;

entity COUNTER is
	generic (
		SIZE : integer
	);
	port(
		CLK  : in std_logic;
		RST  : in std_logic;
		S    : out std_logic_vector(SIZE - 1 downto 0)
	);
end COUNTER;

architecture RTL of COUNTER is
	
	component RCA is
		generic(
			SIZE : integer
		);
		port(
			X    : in std_logic_vector(SIZE - 1 downto 0);
			Y    : in std_logic_vector(SIZE - 1 downto 0);
			CIN  : in std_logic;
			S    : out std_logic_vector(SIZE - 1 downto 0)
		);
	end component;

	signal TS: std_logic_vector(SIZE - 1 downto 0);
	signal Y: std_logic_vector(SIZE - 1 downto 0);
	signal RCA_OUT: std_logic_vector(SIZE - 1 downto 0);

begin

	U: RCA 
	generic map(
		SIZE => SIZE
	)
	port map(
		X   => TS,
		Y   => Y,
		CIN => '0',
		S   => RCA_OUT
	);
	
	S <= TS;
	Y(SIZE - 1 downto 1) <= (others => '0');
	Y(0) <= '1';
	
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			if RST = '1' then 
				TS <= (others => '0');
			else
				TS <= RCA_OUT;
			end if;
		end if;
	end process;
	
end RTL;

