----------------------------------------------------------------------------------
-- Company: Universidad Complutense de Madrid
-- Engineer: Hortensia Mecha
-- 
-- Design Name: divisor 
-- Module Name:    divisor - divisor_arch 
-- Project Name: 
-- Target Devices: 
-- Description:
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY divisor IS
	PORT (
		rst : IN STD_LOGIC;
		clk_entrada : IN STD_LOGIC;
		clk_salida : OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END divisor;

ARCHITECTURE divisor_arch OF divisor IS
	SIGNAL cuenta_2Hz : STD_LOGIC_VECTOR(27 DOWNTO 0);
	SIGNAL cuenta_display1 : STD_LOGIC_VECTOR(27 DOWNTO 0);
	SIGNAL cuenta_4Hz : STD_LOGIC_VECTOR(27 DOWNTO 0);
	SIGNAL cuenta_1Hz:  STD_LOGIC_VECTOR(27 DOWNTO 0);
	SIGNAL clk_aux : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
	clk_salida <= clk_aux;
	contador :
	PROCESS (rst, clk_entrada)
	BEGIN
		IF (rst = '1') THEN
			cuenta_2Hz <= (OTHERS => '0');
			cuenta_display1 <= (OTHERS => '0');
			cuenta_4Hz <= (OTHERS => '0');
			cuenta_1Hz <= (OTHERS => '0');
			clk_aux <= "0000";
		ELSIF (rising_edge(clk_entrada)) THEN
			IF (cuenta_2Hz = "0010111110101111000010000000") THEN --100MHz / 2Hz = 50.000.000
				clk_aux(0) <= '1';
				cuenta_2Hz <= (OTHERS => '0');
			ELSE
				cuenta_2Hz <= cuenta_2Hz + '1';
				clk_aux(0) <= '0';
			END IF;
			IF (cuenta_display1 = "0000000000001000010000000000") THEN
				clk_aux(1) <= '1';
				cuenta_display1 <= (OTHERS => '0');
			ELSE
				cuenta_display1 <= cuenta_display1 + '1';
				clk_aux(1) <= '0';
			END IF;
			IF (cuenta_4Hz = "1011111010111100001000000") THEN --100MHz / 4Hz = 25.000.000
				clk_aux(2) <= '1';
				cuenta_4Hz <= (OTHERS => '0');
			ELSE
				cuenta_4Hz <= cuenta_4Hz + '1';
				clk_aux(2) <= '0';
			END IF;
			IF (cuenta_1Hz = "101111101011110000100000000") THEN --100MHz / 1Hz = 100.000.000
				clk_aux(3) <= '1';
				cuenta_1Hz <= (OTHERS => '0');
			ELSE
				cuenta_1Hz <= cuenta_1Hz + '1';
				clk_aux(3) <= '0';
			END IF;
		END IF;
	END PROCESS contador;

END divisor_arch;
