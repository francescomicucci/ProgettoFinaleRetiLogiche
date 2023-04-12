
library ieee;
use ieee.std_logic_1164.ALL;

entity TRANSMISSION_SIGNALS_GEN is
	port(
		CLK                : in std_logic; 
		CTS					 : in std_logic; 
		COMMUNICATION_MODE : in std_logic; 
		START					 : in std_logic; 
		RESET					 : in std_logic; 
		BUSY					 : out std_logic; 
		LOAD_SHIFT			 : out std_logic; 
		PARITY_RST         : out std_logic;
		CLK_ENABLE  		 : out std_logic; 
		PARITY				 : out std_logic
	);
end TRANSMISSION_SIGNALS_GEN;

architecture RTL of TRANSMISSION_SIGNALS_GEN is
	
	component COUNTER is
		generic (
			SIZE : integer
		);
		port(
			CLK  : in std_logic;
			RST  : in std_logic;
			S    : out std_logic_vector(SIZE - 1 downto 0)
		);
	end component;
	
	signal RST_COUNTER_7_BIT : std_logic;
	signal T_BUSY            : std_logic;
	signal S 					 : std_logic_vector(6 downto 0);
	
begin

	T_BUSY <= S(6) or S(5) or S(4) or S(3) or S(2) or S(1) or S(0);
	BUSY <= T_BUSY;
	
	LOAD_SHIFT <= not T_BUSY and START and CTS;
	CLK_ENABLE <= not S(2) and not S(1) and not S(0); 
	PARITY <= COMMUNICATION_MODE and (S(6) and not S(5) and not S(4) and not S(3) and not S(2) and not S(1) and not S(0));
	PARITY_RST <= not T_BUSY;
	
	RST_COUNTER_7_BIT <= RESET or (not T_BUSY and (not START or not CTS)) or (S(6) and not S(5) and not S(4) and S(3) and S(2) and S(1) and S(0));
	
	U: COUNTER generic map(
		SIZE => 7
	)
	port map(
		CLK => CLK,
		RST => RST_COUNTER_7_BIT,
		S   => S
	);

end RTL;

