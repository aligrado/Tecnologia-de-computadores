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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity contador_8bits is
	port (
		rst : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		enable : IN STD_LOGIC;
		salida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end contador_8bits;

architecture Behavioral of contador_8bits is

signal numero: std_logic_vector(7 downto 0);

begin

	process (rst, clk, enable)
	begin
		if rst = '1' then
			numero <= (others => '0');
		else
			if rising_edge(clk) then
				if enable = '1' then
					if numero = "11111111" then -- Si el numero es FF vuelve a 0
						numero <= (others => '0');
					else
						numero <= numero + 1;
					end if;
				end if;
			end if;
		end if;
		salida <= numero;
	end process;
end Behavioral;
