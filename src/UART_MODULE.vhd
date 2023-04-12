
library ieee;
use ieee.std_logic_1164.ALL;

entity UART_MODULE is
	port(
		CLK   					: in std_logic;
		CTS   					: in std_logic;
		COMMUNICATION_MODE   : in std_logic;
		START 					: in std_logic;
		RESET 					: in std_logic; 
		DIN   					: in std_logic_vector(7 downto 0);
		RX    					: in std_logic;
		RTS_IN					: in std_logic;
		
		TX    					: out std_logic;
		BUSY  					: out std_logic;  
		READY 					: out std_logic;
		ERROR 					: out std_logic;
		RTS_OUT					: out std_logic;
		DOUT  					: out std_logic_vector(7 downto 0) 
	);
end UART_MODULE;

architecture RTL of UART_MODULE is

	component TRANSMISSION_MODULE is
		port(
			CLK   				  : in std_logic;
			CTS   				  : in std_logic;
			COMMUNICATION_MODE  : in std_logic;
			START 				  : in std_logic;
			RESET               : in std_logic;
			DIN  					  : in std_logic_vector(7 downto 0);
			TX  					  : out std_logic;
			BUSY 					  : out std_logic
		);
	end component;
	
	component RECEIVING_MODULE is
		port(
			RX    				  : in std_logic;
			CLK  					  : in std_logic;
			RESET 				  : in std_logic;
			COMMUNICATION_MODE  : in std_logic;
			RTS_IN     		     : in std_logic;
			READY 				  : out std_logic;
			ERROR					  : out std_logic;
			RTS_OUT				  : out std_logic;
			DOUT					  : out std_logic_vector(7 downto 0) 
		);
	end component;

begin
	
	TRA: TRANSMISSION_MODULE port map(
		CLK   => CLK,
		CTS   => CTS,
		COMMUNICATION_MODE  => COMMUNICATION_MODE,
		START => START,
		RESET => RESET,
		DIN   => DIN,
		TX    => TX,
		BUSY  => BUSY
	);
	
	REC: RECEIVING_MODULE port map(
		RX    => RX,
		CLK   => CLK,
		RESET => RESET,
		COMMUNICATION_MODE  => COMMUNICATION_MODE,
		RTS_IN => RTS_IN,
		READY => READY,
		ERROR => ERROR,
		RTS_OUT => RTS_OUT,
		DOUT  => DOUT
	);

end RTL;

