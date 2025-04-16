----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2022 17:02:54
-- Design Name: 
-- Module Name: biestable - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity defusada_explosion_leds is
    port(
        rst, clk, entrada: in std_logic;
        enable: in std_logic_vector(1 downto 0);
        leds: out std_logic_vector(15 downto 0)
    );
end defusada_explosion_leds;

architecture Behavioral of defusada_explosion_leds is

signal leds_aux: std_logic_vector(15 downto 0);

begin
    leds <= leds_aux;
    process(enable, clk)
    begin
        if (rst = '1') then
            leds_aux <= (others => '0');
        elsif (rising_edge(clk)) then
            if (enable = "10") then --Bomba defusada
                leds_aux(15) <= not entrada;
                leds_aux(14) <= not entrada;
                leds_aux(13) <= entrada;
                leds_aux(12) <= entrada;
                leds_aux(11) <= not entrada;
                leds_aux(10) <= not entrada;
                leds_aux(9) <= entrada;
                leds_aux(8) <= entrada;
                leds_aux(7) <= not entrada;
                leds_aux(6) <= not entrada;
                leds_aux(5) <= entrada;
                leds_aux(4) <= entrada;
                leds_aux(3) <= not entrada;
                leds_aux(2) <= not entrada;
                leds_aux(1) <= entrada;
                leds_aux(0) <= entrada;
                leds_aux(15 downto 0) <= not leds_aux(15 downto 0);
            elsif (enable = "11") then --Explosion
                leds_aux(15 downto 0) <= not leds_aux(15 downto 0);
            end if;
        end if;
    end process;

end Behavioral;
