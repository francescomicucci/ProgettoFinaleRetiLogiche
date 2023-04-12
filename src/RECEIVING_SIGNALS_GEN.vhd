
library ieee;
use ieee.std_logic_1164.ALL;

entity RECEIVING_SIGNALS_GEN is
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
end RECEIVING_SIGNALS_GEN;

architecture RTL of RECEIVING_SIGNALS_GEN is
	
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
	
	signal RST_COUNTER_7_BIT  : std_logic;
	signal RST_COUNTER_4_BIT  : std_logic;
	signal T_BUSY             : std_logic;
	signal T_READY_ENABLE     : std_logic;
	signal S1                 : std_logic_vector(6 downto 0);
	signal S2                 : std_logic_vector(3 downto 0);
	
begin

	T_READY_ENABLE <= (S1(6) and not S1(5) and not S1(4) and S1(3) and S1(2) and not S1(1) and not S1(0)) and RX;
	READY_ENABLE <= T_READY_ENABLE;
	SHIFT_ENABLE <= (not S1(2) and S1(1) and S1(0));
	
	T_BUSY <= S1(6) or S1(5) or S1(4) or S1(3) or S1(2) or S1(1) or S1(0);
	PARITY_RST <= not T_BUSY;
	RST_COUNTER_7_BIT <= RESET or (not T_BUSY and RX) or  (S1(6) and not S1(5) and not S1(4) and S1(3) and S1(2) and not S1(1) and not S1(0));
	
	U1: COUNTER generic map(
		SIZE => 7
	)
	port map(
		CLK => CLK,
		RST => RST_COUNTER_7_BIT,
		S   => S1
	);
	
	READY <= S2(3) or S2(2) or S2(1) or S2(0);
	RST_COUNTER_4_BIT <= RESET or (not T_READY_ENABLE and not (S2(3) or S2(2) or S2(1) or S2(0))) or (S2(3) and not S2(2) and not S2(1) and not S2(0));
	
	U2: COUNTER generic map(
		SIZE => 4
	)
	port map(
		CLK => CLK,
		RST => RST_COUNTER_4_BIT,
		S   => S2
	);
	
	RTS: FF_D_ENABLE port map(
		D		 => RTS_IN,
		ENABLE => '1',
		CLK	 => CLK,
		CLEAR  => '0',
		PRESET => '0',
		Q      => RTS_OUT
	);

end RTL;

