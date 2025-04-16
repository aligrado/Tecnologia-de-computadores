----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2022 22:07:09
-- Design Name: 
-- Module Name: contadorMod10 - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity contadorMod10 is
    port(
        rst, rst_cont, clk, enable: in std_logic;
        salida: out std_logic_vector(3 downto 0)
    );
end contadorMod10;

architecture Behavioral of contadorMod10 is

signal numero: std_logic_vector(3 downto 0);

begin
    process (rst, clk, enable)
    begin
        if (rst = '1' OR rst_cont = '1') then
            numero <= "0000";
        elsif(rising_edge(clk)) then
            if (enable = '1') then
                if(numero = "1001") then
                    numero <= "0000";
                else
                    numero <= numero + '1';
                end if;
            end if;
        end if;
    end process;
salida <= numero;
end Behavioral;
