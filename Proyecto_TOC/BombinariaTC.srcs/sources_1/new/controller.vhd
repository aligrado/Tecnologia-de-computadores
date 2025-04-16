----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.12.2022 01:22:40
-- Design Name: 
-- Module Name: controller - Behavioral
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

entity controller is
    port(
        rst: in std_logic;
        clk: in std_logic;
        inicio: in std_logic;
        defusar: in std_logic;
        numero: in std_logic_vector(7 downto 0);
        numRand: in std_logic_vector(7 downto 0);--Numero random
        cuentaAtras: in std_logic_vector(3 downto 0);
        contador_5seg: in std_logic_vector(3 downto 0);
        ctrl: out std_logic_vector(6 downto 0)--ver si es justo 4 a 0 (5)
    );
end controller;

architecture Behavioral of controller is

    type STATES is (S0, S1, S2, S3, S4, S5);
    
    signal STATE, NEXT_STATE: STATES;
    signal ctrl_aux: std_logic_vector(6 downto 0);
    alias rst_conts: std_logic is ctrl_aux(0);
    alias rst_cont5seg: std_logic is ctrl_aux(1);
    alias enable_numRand: std_logic is ctrl_aux(2);
    alias enable_cont5seg: std_logic is ctrl_aux(3);
    alias enable_cuentaAtras: std_logic is ctrl_aux(4);
    alias mux_leds: std_logic_vector(1 downto 0) is ctrl_aux(6 downto 5);
    
    
begin
    ctrl <= ctrl_aux;
    
    p_state: process(clk, rst)
    begin
        if rst = '1' then
            STATE <= S0;
        elsif rising_edge(clk) then
            STATE <= NEXT_STATE;
        end if;
    end process p_state;
    
    p_next_state: process(clk, inicio, defusar, numRand, cuentaAtras, STATE)
    begin
        case STATE is
            when S0 =>
                rst_conts <= '1';
                rst_cont5seg <= '1';
                enable_numRand <= '0';
                enable_cont5seg <= '0';
                enable_cuentaAtras <= '0';
                mux_leds <= "00";--Apagadas
                
                if inicio = '1' then
                    NEXT_STATE <= S1;
                else
                    NEXT_STATE <= S0;
                end if;
            when S1=>
                rst_conts <= '0';
                rst_cont5seg <= '0';
                enable_numRand <= '1';
                enable_cont5seg <= '1';
                enable_cuentaAtras <= '0';
                mux_leds <= "01";--Esperando numero random
                
                if(contador_5seg = "1001") then
                    NEXT_STATE <= S2;
                else
                    NEXT_STATE <= S1;
                end if;
            when S2 =>
                rst_conts <= '0';
                rst_cont5seg <= '1';
                enable_numRand <= '0';
                enable_cont5seg <= '0';
                enable_cuentaAtras <= '1';
                mux_leds <= "00";
                
                if (cuentaAtras = "0000" OR defusar = '1') then
                    NEXT_STATE <= S3;
                else
                    NEXT_STATE <= S2;
                end if;
            when S3 =>
                rst_conts <= '0';
                rst_cont5seg <= '0';
                enable_numRand <= '0';
                enable_cont5seg <= '0';
                enable_cuentaAtras <= '0';
                mux_leds <= "00";
                
                if(numero = numRand)then
                    NEXT_STATE <= S4;
                else
                    NEXT_STATE <= S5;
                end if;
            when S4 =>
                rst_conts <= '0';
                rst_cont5seg <= '0';
                enable_numRand <= '0';
                enable_cont5seg <= '1';
                enable_cuentaAtras <= '0';
                mux_leds <= "10";
                
                if(contador_5seg = "1001") then
                    NEXT_STATE <= S0;
                else
                    NEXT_STATE <= S4;
                end if;
            when S5 =>
                rst_conts <= '0';
                rst_cont5seg <= '0';
                enable_numRand <= '0';
                enable_cont5seg <= '1';
                enable_cuentaAtras <= '0';
                mux_leds <= "11";
                
                if(contador_5seg = "1001") then
                    NEXT_STATE <= S0;
                else
                    NEXT_STATE <= S5;
                end if;
        end case;
    
    end process p_next_state;

end Behavioral;
