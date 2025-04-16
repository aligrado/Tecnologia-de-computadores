----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.12.2022 00:22:05
-- Design Name: 
-- Module Name: sintesis_bombinaria - Behavioral
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

entity sintesis_bombinaria is
    port(
        rst: in std_logic;
        clk: in std_logic;
        boton_inicio: in std_logic;
        boton_defusar: in std_logic;
        numero: in std_logic_vector(7 downto 0);
        display: out std_logic_vector(6 downto 0);
        leds: out std_logic_vector(15 downto 0);
        s_display: out std_logic_vector (3 downto 0)
    );
end sintesis_bombinaria;

architecture Behavioral of sintesis_bombinaria is

    component bombinaria is
    port (
    rst: in std_logic;
    clk: in std_logic;
    inicio: in std_logic;
    defusar: in std_logic;
    numero: in std_logic_vector(7 downto 0);
    numRand: out std_logic_vector(7 downto 0);
    cuentaAtras: out std_logic_vector(3 downto 0);
    leds: out std_logic_vector(15 downto 0)
    );
    end component;
    
    component debouncer is
    port (
    rst: in std_logic;
    clk: in std_logic;
    x: in std_logic;
    xDeb: out std_logic;
    xDebFallingEdge: out std_logic;
    xDebRisingEdge: out std_logic
    );
    end component;
    
    component displays is
    port (
    rst: in std_logic;
    clk: in std_logic;
    digito_0: in std_logic_vector(3 downto 0);
    digito_1: in std_logic_vector(3 downto 0);
    digito_2: in std_logic_vector(3 downto 0);
    digito_3: in std_logic_vector(3 downto 0);
    display: out std_logic_vector(6 downto 0);
    display_enable: out std_logic_vector(3 downto 0)
    );
    end component;
    
    signal s_displays: std_logic_vector(3 downto 0);
    signal inicio, empezar, defusar: std_logic;
    signal reset_n: std_logic;
    
    signal cuentaAtras: std_logic_vector(3 downto 0);
    signal numRand: std_logic_vector(7 downto 0);
    alias cont1: std_logic_vector (3 downto 0) is numRand(3 downto 0);
    alias cont2: std_logic_vector (3 downto 0) is numRand(7 downto 4);

begin
    reset_n <= not rst;
    debouncerInsts_displayce1 : debouncer PORT MAP(reset_n, clk, boton_inicio, OPEN, OPEN, inicio);
	debouncerInsts_displayce2 : debouncer PORT MAP(reset_n, clk, boton_defusar, OPEN, OPEN, defusar);
	bombinariaInsts_displayce : bombinaria PORT MAP(rst => rst, clk => clk, inicio => inicio, defusar => defusar, numero => numero, numRand => numRand, cuentaAtras => cuentaAtras, leds => leds);
	displays_inst : displays PORT MAP(rst, clk, cont1, cont2, "0000", cuentaAtras, display, s_display);

end Behavioral;
