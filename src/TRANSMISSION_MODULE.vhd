
library ieee;
use ieee.std_logic_1164.ALL;

entity TRANSMISSION_MODULE is
	port(
		CLK   : in std_logic;
		CTS   : in std_logic;
		COMMUNICATION_MODE  : in std_logic;
		START : in std_logic;
		RESET : in std_logic;
		DIN   : in std_logic_vector(7 downto 0);
		TX    : out std_logic;
		BUSY  : out std_logic
	);
end TRANSMISSION_MODULE;

architecture RTL of TRANSMISSION_MODULE is
	
	component TRANSMISSION_REGISTER is
		port(
			CLK       			 : in std_logic;
			LOAD_SHIFT	       : in std_logic;
			RESET			       : in std_logic;
			CLK_ENABLE         : in std_logic;
			PARITY				 : in std_logic;
			PARITY_RST         : in std_logic;
			DIN			       : in std_logic_vector(7 downto 0);
			TX				       : out std_logic
		);
	end component;
	
	component TRANSMISSION_SIGNALS_GEN is
		port(
			CLK                : in std_logic; 
			CTS					 : in std_logic; 
			COMMUNICATION_MODE : in std_logic; 
			START					 : in std_logic; 
			RESET					 : in std_logic; 
			BUSY					 : out std_logic; 
			LOAD_SHIFT			 : out std_logic; 
			PARITY_RST         : out std_logic;
			CLK_ENABLE 		    : out std_logic; 
			PARITY				 : out std_logic
		);
	end component;
	
	signal LOAD_SHIFT			  : std_logic; 
	signal CLK_ENABLE         : std_logic; 
	signal PARITY				  : std_logic;
	signal PARITY_RST         : std_logic;

begin
	
	REG: TRANSMISSION_REGISTER port map(
		CLK   				 => CLK,
		LOAD_SHIFT         => LOAD_SHIFT,
		RESET              => RESET,
		CLK_ENABLE         => CLK_ENABLE,
		PARITY				 => PARITY,
		PARITY_RST         => PARITY_RST,
		DIN                => DIN,
		TX                 => TX
	);	
	
	GEN: TRANSMISSION_SIGNALS_GEN port map(
		CLK                => CLK,
		CTS                => CTS,
		COMMUNICATION_MODE => COMMUNICATION_MODE,
		START              => START,
		RESET              => RESET,
		BUSY               => BUSY,
		LOAD_SHIFT         => LOAD_SHIFT,
		PARITY_RST			 => PARITY_RST,
		CLK_ENABLE         => CLK_ENABLE,
		PARITY				 => PARITY
	);

end RTL;

