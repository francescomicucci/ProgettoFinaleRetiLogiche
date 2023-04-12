
library ieee;
use ieee.std_logic_1164.ALL;

entity RCA is
	generic(
		SIZE : integer
	);
	port(
		X    : in std_logic_vector(SIZE - 1 downto 0);
		Y    : in std_logic_vector(SIZE - 1 downto 0);
		CIN  : in std_logic;
		S    : out std_logic_vector(SIZE - 1 downto 0)
	);
end RCA;

architecture RTL of RCA is

	component FA is
		port(
			X    : in std_logic;
			Y    : in std_logic;
			CIN  : in std_logic;
			S    : out std_logic;
			COUT : out std_logic
		);
	end component;
	
	signal C   : std_logic_vector(SIZE downto 0);
	
begin

	C(0) <= CIN;
	
	GEN: for I in 0 to SIZE - 1 generate
		U: FA port map(
			X    => X(I),
			Y    => Y(I),
			CIN  => C(I),
			S    => S(I),
			COUT => C(I+1)
			);
	end generate;

end RTL;

