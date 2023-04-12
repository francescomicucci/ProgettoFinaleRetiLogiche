
library ieee;
use ieee.std_logic_1164.ALL;

entity TRANSMISSION_REGISTER is
	port(
		CLK                : in std_logic;
		LOAD_SHIFT	       : in std_logic;
		RESET			       : in std_logic;
		CLK_ENABLE         : in std_logic;
		PARITY				 : in std_logic;
		PARITY_RST         : in std_logic;
		DIN			       : in std_logic_vector(7 downto 0);
		TX				       : out std_logic
	);
end TRANSMISSION_REGISTER;

architecture RTL of TRANSMISSION_REGISTER is
	
	component FF_D_ENABLE is
		port(
			D	    : in std_logic;
			ENABLE : in std_logic;
			CLK    : in std_logic;
			CLEAR  : in std_logic;
			PRESET : in std_logic;
			Q      : out std_logic	
		);
	end component;
	
	component FF_T_ENABLE is
		port(
			T	    : in std_logic;
			ENABLE : in std_logic;
			CLK    : in std_logic;
			CLEAR  : in std_logic;
			PRESET : in std_logic;
			Q      : out std_logic	
		);
	end component;
	
	signal PS_IN  		   : std_logic_vector(8 downto 0);
	signal PS_OUT 		   : std_logic_vector(8 downto 0);
	signal LOAD_VECTOR	: std_logic_vector(8 downto 0);
	signal SHIFT_VECTOR : std_logic_vector(8 downto 0);
	
	signal FF_PARITY_RST : std_logic;
	signal PARITYBIT     : std_logic;
	
begin

	LOAD_VECTOR(8) <= '0';
	LOAD_VECTOR(7 downto 0) <= DIN(7 downto 0);
	
	SHIFT_VECTOR(0) <= '1';
	SHIFT_VECTOR(7 downto 1) <= PS_OUT(6 downto 0);
	SHIFT_VECTOR(8) <= PARITYBIT when PARITY = '1' else
							  PS_OUT(7);
	
	PS_IN <= LOAD_VECTOR when LOAD_SHIFT = '1' else
				SHIFT_VECTOR;
				
	TX <= PS_OUT(8);

	GEN_PS: for I in 0 to 8 generate
		SP: FF_D_ENABLE port map(
			D		 => PS_IN(I),
			ENABLE => CLK_ENABLE,
			CLK    => CLK,
			CLEAR  => '0',
			PRESET => RESET,
			Q      => PS_OUT(I)
		);
	end generate;
	
	FF_PARITY_RST <= RESET or PARITY_RST;
	
	FF_PARITY: FF_T_ENABLE port map(
		T      => PS_OUT(7),
		ENABLE => CLK_ENABLE,
		CLK    => CLK,
		CLEAR  => FF_PARITY_RST,
		PRESET => '0',
		Q      => PARITYBIT
	);

end RTL;

