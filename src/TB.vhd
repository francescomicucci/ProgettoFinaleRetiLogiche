
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY TB IS
END TB;
 
ARCHITECTURE behavior OF TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART_MODULE
    PORT(
         CLK : IN  std_logic;
         CTS : IN  std_logic;
         COMMUNICATION_MODE : IN  std_logic;
         START : IN  std_logic;
         RESET : IN  std_logic;
         DIN : IN  std_logic_vector(7 downto 0);
         RX : IN  std_logic;
			RTS_IN : IN std_logic;
         TX : OUT  std_logic;
         BUSY : OUT  std_logic;
         READY : OUT  std_logic;
         ERROR : OUT  std_logic;
			RTS_OUT : OUT std_logic;
         DOUT : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
   
	signal RESET1 : std_logic;
	signal RESET2 : std_logic;
	signal COMMUNICATION_MODE1 : std_logic;
	signal COMMUNICATION_MODE2 : std_logic;
	
	--Trasmissione da UART1 a UART2
   signal CLK1 : std_logic;
   signal RTS_IN2 : std_logic;
	signal RTS_OUT2 : std_logic;
	signal CTS1 : std_logic;
	signal START1 : std_logic;
	signal BUSY1 : std_logic;
	signal DIN1 : std_logic_vector(7 downto 0);
	signal TX1 : std_logic;
	signal RX2 : std_logic;
	signal READY2 : std_logic;
   signal ERROR2 : std_logic;
   signal DOUT2 : std_logic_vector(7 downto 0);
	signal CORRECT12 : std_logic;
	
	--Trasmissione da UART2 a UART1
   signal CLK2 : std_logic;
   signal RTS_IN1 : std_logic;
	signal RTS_OUT1 : std_logic;
	signal CTS2 : std_logic;
	signal START2 : std_logic;
	signal BUSY2 : std_logic;
	signal DIN2 : std_logic_vector(7 downto 0);
	signal TX2 : std_logic;
	signal RX1 : std_logic;
	signal READY1 : std_logic;
   signal ERROR1 : std_logic;
   signal DOUT1 : std_logic_vector(7 downto 0);
	signal CORRECT21 : std_logic;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   UART1: UART_MODULE PORT MAP (
          CLK => CLK1,
          CTS => CTS1,
          COMMUNICATION_MODE => COMMUNICATION_MODE1,
          START => START1,
          RESET => RESET1,
          DIN => DIN1,
          RX => RX1,
			 RTS_IN => RTS_IN1,
          TX => TX1,
          BUSY => BUSY1,
          READY => READY1,
          ERROR => ERROR1,
			 RTS_OUT => RTS_OUT1,
          DOUT => DOUT1
        );
		  
	UART2: UART_MODULE PORT MAP (
          CLK => CLK2,
          CTS => CTS2,
          COMMUNICATION_MODE => COMMUNICATION_MODE2,
          START => START2,
          RESET => RESET2,
          DIN => DIN2,
          RX => RX2,
			 RTS_IN => RTS_IN2,
          TX => TX2,
          BUSY => BUSY2,
          READY => READY2,
          ERROR => ERROR2,
			 RTS_OUT => RTS_OUT2,
          DOUT => DOUT2
        );
		  
	RX2 <= TX1;
	RX1 <= TX2;
	CTS1 <= RTS_OUT2;
	CTS2 <= RTS_OUT1;

   -- Clock
   process
   begin
		CLK1 <= '0';
		wait for 67816.84 ps;
		CLK1 <= '1';
		wait for 67816.84 ps;
   end process;
	
	process
   begin
		CLK2 <= '1';
		wait for 67861.02 ps;
		CLK2 <= '0';
		wait for 67861.02 ps;
   end process;
	
	-- Reset
	process
	begin
		RESET1 <= '1';
		wait for 1085069.44 ps;
		RESET1 <= '0';
		wait;
	end process;
	
	process
	begin
		RESET2 <= '1';
		wait for 1085069.44 ps;
		RESET2 <= '0';
		wait;
	end process;
	
	-- Code
	process
	begin
		COMMUNICATION_MODE1 <= '1';
		COMMUNICATION_MODE2 <= '1';
		wait for 38000 ns;
		COMMUNICATION_MODE1 <= '0';
		COMMUNICATION_MODE2 <= '0';
		wait for 22000 ns;
		COMMUNICATION_MODE1 <= '0';
		COMMUNICATION_MODE2 <= '1';
		wait;
	end process;
	
	-- Segnale di verfica CORRECT12
	process
	begin
		CORRECT12 <= '0';
		wait for 13717215 ps;
		
		if DOUT2 = "11100111" then
			CORRECT12 <= '1';
		else
			CORRECT12 <= '0';
		end if;
		wait for 10857760 ps;
		
		if DOUT2 = "10010110" then
			CORRECT12 <= '1';
		else
			CORRECT12 <= '0';
		end if;
		wait for 10857760 ps;
		
		if DOUT2 = "01011001" then
			CORRECT12 <= '1';
		else
			CORRECT12 <= '0';
		end if;
		wait for 13029312 ps;
		
		if DOUT2 = "00010100" then
			CORRECT12 <= '1';
		else
			CORRECT12 <= '0';
		end if;
		wait for 10857760 ps;
		
		if DOUT2 = "01011000" then
			CORRECT12 <= '1';
		else
			CORRECT12 <= '0';
		end if;	
		wait for 12214980 ps;
		
		if DOUT2 = "10011000" then
			CORRECT12 <= '1';
		else
			CORRECT12 <= '0';
		end if;
		wait for 10857760 ps;
		
		if DOUT2 = "11011000" then
			CORRECT12 <= '1';
		else
			CORRECT12 <= '0';
		end if;		
		wait;
	end process;
 

   -- Trasmissione da UART 1 a UART2
   process
   begin	
		-- Parole trasmesse quando COMMMUNICATION_MODE = '1'
		START1 <= '0';
		RTS_IN2 <= '0';
		DIN1 <= "11100110";
		wait for 1085069.44 ps;
		START1 <= '1';
		wait for 1085069.44 ps;
		START1 <= '0';
		wait for 1085069.44 ps;
		
		RTS_IN2 <= '1';
		START1 <= '1';
		wait for 1085069.44 ps;
		START1 <= '0';
		wait for 9765624.96 ps;
		
		START1 <= '1';
		DIN1 <= "10010110";
		wait for 1085069.44 ps;
		RTS_IN2 <= '0';
		START1 <= '0';
		wait for 9765624.96 ps;
		
		RTS_IN2 <= '1';
		START1 <= '1';
		DIN1 <= "01011000";
		wait for 1085069.44 ps;
		START1 <= '0';
		wait for 11958338 ps;
		
		-- Parole trasmesse quando COMMMUNICATION_MODE = '0'
		START1 <= '1';
		DIN1 <= "00010100";
		wait for 1085069.44 ps;
		START1 <= '0';
		wait for 9765624.96 ps;
		
		START1 <= '1';
		DIN1 <= "01011000";
		wait for 1085069.44 ps;
		START1 <= '0';
		wait for 11064238 ps;
		
		--Parole trasmesse quando le UART hanno COMMUNICATION_MODE diverso
		START1 <= '1';
		DIN1 <= "10011000";
		wait for 1085069.44 ps;
		START1 <= '0';
		wait for 9765624.96 ps;
		
		START1 <= '1';
		DIN1 <= "11011000";
		wait for 1085069.44 ps;
		START1 <= '0';
		wait;
   end process;
	
	-- Segnale di verfica CORRECT21
	process
	begin
		CORRECT21 <= '0';
		wait for 11470197 ps;
		wait for 135722.04 ps;
		
		if DOUT1 = "11110000" then
			CORRECT21 <= '1';
		else
			CORRECT21 <= '0';
		end if;
		wait for 10850560 ps;
		
		if DOUT1 = "11110000" then
			CORRECT21 <= '1';
		else
			CORRECT21 <= '0';
		end if;
		wait for 10850560 ps;
		
		if DOUT1 = "00111100" then
			CORRECT21 <= '1';
		else
			CORRECT21 <= '0';
		end if;
		wait for 15190784 ps;
		
		if DOUT1 = "01101011" then
			CORRECT21 <= '1';
		else
			CORRECT21 <= '0';
		end if;
		wait for 10850560 ps;
		
		if DOUT1 = "00001110" then
			CORRECT21 <= '1';
		else
			CORRECT21 <= '0';
		end if;		
		wait;
	end process;
	
	-- Trasmissione da UART 2 a UART1
	process
	begin	
	   -- Parole trasmesse quando COMMMUNICATION_MODE = '1'
		START2 <= '0';
		RTS_IN1 <= '1';
		DIN2 <= "11110001";
		wait for 1085069.44 ps;
		wait for 135722.04 ps;
		START2 <= '1';
		wait for 1085069.44 ps;
		START2 <= '0';
		wait for 9771281.88 ps;
		
		DIN2 <= "11110001";
		START2 <= '1';
		wait for 1085069.44 ps;
		START2 <= '0';
		wait for 9771281.88 ps;
		
		DIN2 <= "00111101";
		START2 <= '1';
		wait for 1085069.44 ps;
		START2 <= '0';
		wait for 14117162 ps;
		
		-- Parole trasmesse quando COMMMUNICATION_MODE = '0'
		START2 <= '1';
		DIN2 <= "01101011";
		wait for 1085069.44 ps;
		START2 <= '0';
		wait for 9771281.88 ps;
		
		START2 <= '1';
		DIN2 <= "00001110";
		wait for 1085069.44 ps;
		START2 <= '0';		
		wait;
	end process;


END;
