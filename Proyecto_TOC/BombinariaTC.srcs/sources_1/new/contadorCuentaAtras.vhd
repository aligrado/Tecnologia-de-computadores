----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2020 11:56:11
-- Design Name: 
-- Module Name: cont_mod10 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.ALL;

entity contadorCuentaAtras is
	port (
		rst : in std_logic;
		clk : in std_logic;
		enable : in std_logic;
		salida : out std_logic_vector(3 downto 0));
end contadorCuentaAtras;

architecture Behavioral of contadorCuentaAtras is

signal numero: std_logic_vector(3 downto 0);

begin

	process (rst, clk, enable)
	begin
		if rst = '1' then
			numero <= (others => '1');
		else
			if rising_edge(clk) then
				if enable = '1' then
					if numero = "0000" then -- Si el numero es 0 vuelve a 15
						numero <= (others => '1');
					else
						numero <= numero - 1;
					end if;
				end if;
			end if;
		end if;
		salida <= numero;
	end process;
end Behavioral;
