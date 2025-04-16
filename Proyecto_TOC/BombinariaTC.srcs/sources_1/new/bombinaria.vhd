----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.12.2022 00:43:01
-- Design Name: 
-- Module Name: bombinaria - Behavioral
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

entity bombinaria is
    port(
        rst: in std_logic;
        clk: in std_logic;
        inicio: in std_logic;
        defusar: in std_logic;
        numero: in std_logic_vector(7 downto 0);
        numRand: out std_logic_vector(7 downto 0);
        cuentaAtras: out std_logic_vector(3 downto 0);
        leds: out std_logic_vector(15 downto 0)
    );
end bombinaria;

architecture Behavioral of bombinaria is

    component divisor
    port(
    rst: in std_logic;
    clk_entrada: in std_logic;
    clk_salida: out std_logic_vector(3 downto 0)
    );
    end component;
    
    component controller
    port(
    rst: in std_logic;
    clk: in std_logic;
    inicio: in std_logic;
    defusar: in std_logic;
    numero: in std_logic_vector(7 downto 0);
    numRand: in std_logic_vector(7 downto 0);
    cuentaAtras: in std_logic_vector(3 downto 0);
    contador_5seg: in std_logic_vector(3 downto 0);
    ctrl: out std_logic_vector(6 downto 0)
    );
    end component;
    
    component datapath
    port(
    rst: in std_logic;
    clk: in std_logic_vector(3 downto 0);
    ctrl: in std_logic_vector(6 downto 0);
    numRand: out std_logic_vector(7 downto 0);
    cuentaAtras: out std_logic_vector(3 downto 0);
    contador_5seg: out std_logic_vector(3 downto 0);
    leds: out std_logic_vector(15 downto 0)
    );
    end component;
    
    signal clk_aux: std_logic_vector(3 downto 0); --puede q modificar
    signal ctrl_aux: std_logic_vector(6 downto 0);
    signal numRand_aux: std_logic_vector(7 downto 0);
    signal cuentaAtras_aux: std_logic_vector(3 downto 0);
    signal cont_5seg: std_logic_vector(3 downto 0);

begin
    numRand <= numRand_aux;
    cuentaAtras <= cuentaAtras_aux;
    
    my_divisor: divisor port map (rst => rst, clk_entrada => clk, clk_salida => clk_aux);
    my_datapath: datapath port map (rst => rst, clk => clk_aux, ctrl => ctrl_aux, numRand => numRand_aux, cuentaAtras => cuentaAtras_aux, contador_5seg => cont_5seg, leds => leds);
    my_controller: controller port map (rst => rst, clk => clk, inicio => inicio, defusar => defusar, numero => numero, numRand => numRand_aux, cuentaAtras => cuentaAtras_aux, contador_5seg => cont_5seg, ctrl => ctrl_aux);


end Behavioral;
