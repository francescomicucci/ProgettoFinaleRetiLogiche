
library ieee;
use ieee.std_logic_1164.ALL;

entity RECEIVING_REGISTER is
	port(
		RX				 		 : in std_logic;
		CLK			 		 : in std_logic;
		COMMUNICATION_MODE : in std_logic;
		SHIFT_ENABLE 		 : in std_logic;
		READY_ENABLE 		 : in std_logic;
		RESET        		 : in std_logic;
		PARITY_RST         : in std_logic;
		ERROR        		 : out std_logic;
		DOUT			 		 : out std_logic_vector(7 downto 0)
	);
end RECEIVING_REGISTER;

architecture RTL of RECEIVING_REGISTER is

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
	
	signal SP_IN  		   : std_logic_vector(8 downto 0);
	signal SP_OUT 		   : std_logic_vector(8 downto 0);
	signal NOT_ERROR	   : std_logic;
	signal NOT_ERROR_RST : std_logic;
	signal ERROR_VALUE   : std_logic;

begin
	
	SP_IN(0) <= RX;
	SP_IN(8 downto 1) <= SP_OUT(7 downto 0);

	GEN_SP: for I in 0 to 8 generate
		SP: FF_D_ENABLE port map(
			D		 => SP_IN(I),
			ENABLE => SHIFT_ENABLE,
			CLK    => CLK,
			CLEAR  => RESET,
			PRESET => '0',
			Q      => SP_OUT(I)
		);
	end generate;
	
	GEN: for I in 0 to 7 generate
		PP: FF_D_ENABLE port map(
			D		 => SP_OUT(I + 1),
			ENABLE => READY_ENABLE,
			CLK    => CLK,
			CLEAR  => RESET,
			PRESET => '0',
			Q      => DOUT(I)
		);
	end generate;
	
	NOT_ERROR_RST <= RESET or PARITY_RST;
	ERROR_VALUE   <= not NOT_ERROR and COMMUNICATION_MODE;
	
	FF_ERROR: FF_D_ENABLE port map(
		D		 => ERROR_VALUE,
		ENABLE => READY_ENABLE,
		CLK    => CLK,
		CLEAR  => RESET,
		PRESET => '0',
		Q      => ERROR
	);
	
	FF_NOT_ERROR: FF_T_ENABLE port map(
		T		 => RX,
		ENABLE => SHIFT_ENABLE,
		CLK    => CLK,
		CLEAR  => NOT_ERROR_RST,
		PRESET => '0',
		Q      => NOT_ERROR
	);
	
end RTL;

