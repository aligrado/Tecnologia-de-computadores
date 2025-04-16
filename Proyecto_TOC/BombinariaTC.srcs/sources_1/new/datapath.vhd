----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.12.2022 01:22:54
-- Design Name: 
-- Module Name: datapath - Behavioral
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

entity datapath is
    port(
        rst: in std_logic;
        clk: in std_logic_vector(3 downto 0);--Puede q haya q modificarlo
        ctrl: in std_logic_vector(6 downto 0);--ver si es justo 4 a 0 (5)
        numRand: out std_logic_vector(7 downto 0);
        cuentaAtras: out std_logic_vector(3 downto 0);
        contador_5seg: out std_logic_vector(3 downto 0);
        leds: out std_logic_vector(15 downto 0)
    );
end datapath;

architecture Behavioral of datapath is

    component contador_8bits
    port(
    rst: in std_logic;
    clk: in std_logic;
    enable: in std_logic;
    salida: out std_logic_vector(7 downto 0)
    );
    end component;
    
    component contadorCuentaAtras
    port(
    rst: in std_logic;
    clk: in std_logic;
    enable: in std_logic;
    salida: out std_logic_vector(3 downto 0)
    );
    end component;
    
    component contadorMod10
    port(
    rst: in std_logic;
    clk: in std_logic;
    enable: in std_logic;
    salida: out std_logic_vector(3 downto 0)
    );
    end component;
    
    component defusada_leds
    port(
    rst: in std_logic;
    clk: in std_logic;
    leds: out std_logic_vector(15 downto 0)
    );
    end component;
    
    component explosion_leds
    port(
    rst: in std_logic;
    clk: in std_logic;
    leds: out std_logic_vector(15 downto 0)
    );
    end component;
    
    component esperando_numero--Registro 
    port(
    rst, clk, entrada: in std_logic;
    leds: out std_logic_vector(15 downto 0)
    );
    end component;
    
    signal ctrl_aux: std_logic_vector(6 downto 0);
    alias rst_conts: std_logic is ctrl_aux(0);
    alias rst_cont5seg: std_logic is ctrl_aux(1);
    alias enable_numRand: std_logic is ctrl_aux(2);
    alias enable_cont5seg: std_logic is ctrl_aux(3);
    alias enable_cuentaAtras: std_logic is ctrl_aux(4);
    alias mux_leds: std_logic_vector(1 downto 0) is ctrl_aux(6 downto 5);
    
    signal defusada, explosion, esperando: std_logic_vector(15 downto 0);
    signal entrada_esperando: std_logic;

begin
    ctrl_aux <= ctrl;
    entrada_esperando <= not esperando(15);
    
    my_numRand: contador_8bits port map(rst => rst_conts, clk => clk(1), enable => enable_numRand, salida => numRand);
    my_cuentaAtras: contadorCuentaAtras port map(rst => rst_conts, clk => clk(3), enable => enable_cuentaAtras, salida => cuentaAtras);--Habrá q cambiarle el clk
    my_cont5seg: contadorMod10 port map(rst => rst_cont5seg, clk => clk(0), enable => enable_cont5seg, salida => contador_5seg);
    my_defusada_leds: defusada_leds port map(rst => rst_conts, clk => clk(0), leds => defusada);
    my_explosion_leds: explosion_leds port map(rst => rst_conts, clk => clk(0), leds => explosion);
    my_esperando_numero: esperando_numero port map(rst => rst_conts, clk => clk(2), entrada => entrada_esperando, leds => esperando);
    
    secuencias: process(defusada, explosion, esperando, ctrl_aux, mux_leds, clk)
    begin
        if mux_leds = "00" then
            leds <= (others => '0');
        elsif mux_leds = "01" then
            leds <= esperando;
        elsif mux_leds = "10" then
            leds <= defusada;
        elsif mux_leds = "11" then
            leds <= explosion;
        end if;
    end process secuencias;

end Behavioral;
