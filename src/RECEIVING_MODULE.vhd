
library ieee;
use ieee.std_logic_1164.ALL;

entity RECEIVING_MODULE is
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
end RECEIVING_MODULE;

architecture RTL of RECEIVING_MODULE is

	component RECEIVING_REGISTER is
		port(
			RX						 : in std_logic;
			CLK			 		 : in std_logic;
			COMMUNICATION_MODE : in std_logic;
			SHIFT_ENABLE 		 : in std_logic;
			READY_ENABLE 		 : in std_logic;
			RESET        		 : in std_logic;
			PARITY_RST         : in std_logic;
			ERROR        		 : out std_logic;
			DOUT			  		 : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component RECEIVING_SIGNALS_GEN is
		port(
			CLK           : in std_logic;
			RESET         : in std_logic;
			RX            : in std_logic;
			RTS_IN        : in std_logic;
			READY_ENABLE  : out std_logic;
			SHIFT_ENABLE  : out std_logic;
			READY         : out std_logic;
			RTS_OUT       : out std_logic;
			PARITY_RST    : out std_logic
		);
	end component;
	
	signal SHIFT_ENABLE: std_logic;
	signal READY_ENABLE: std_logic;
	signal PARITY_RST  : std_logic;

begin

	REG: RECEIVING_REGISTER port map(
		RX           	    => RX,
		CLK          		 => CLK,
		COMMUNICATION_MODE => COMMUNICATION_MODE,
		SHIFT_ENABLE 		 => SHIFT_ENABLE,
		READY_ENABLE 		 => READY_ENABLE,
		RESET        		 => RESET,
		PARITY_RST   		 => PARITY_RST,
		ERROR        		 => ERROR,
		DOUT         		 => DOUT
	);
	
	GEN: RECEIVING_SIGNALS_GEN port map(
		CLK           => CLK,
		RESET         => RESET,
		RX            => RX,
		RTS_IN        => RTS_IN,
		READY_ENABLE  => READY_ENABLE,
		SHIFT_ENABLE  => SHIFT_ENABLE,
		READY         => READY,
		RTS_OUT       => RTS_OUT,
		PARITY_RST    => PARITY_RST
	);
	
end RTL;

