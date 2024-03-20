--------------------------------------------------------------------------------
-- University: PUC-Rio
-- Discipline: ENG1448 - Computação Digital
-- Author: Pedro Gabriel Serodio Sales
--
-- Create Date:   10:03:38 03/11/2024
-- Evaluation          Development Board: Spartan-3E Starter Board
-- Preferred Language: VHDL
-- Source Name:        VHDL Module
-- Module Name:        parking - Behavioral 
-- Project Name:       [2] Parking  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: parking
-- 
-- Revision:
-- Revision 0.02 - File Created
-- Additional Comments:
--
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY parking_tb IS
END parking_tb;
ARCHITECTURE behavior OF parking_tb IS
	 -- Component Declaration for the Unit Under Test (UUT)
	 COMPONENT parking
	 PORT(
	 CLK : IN std_logic;
	 ENB : IN std_logic;
	 A : IN std_logic;
	 B : IN std_logic;
	 Z : OUT std_logic_vector(7 downto 0)
	 );
	 END COMPONENT;
	 --Inputs
	 signal CLK : std_logic := '0';
	 signal ENB : std_logic := '0';
	 signal A : std_logic := '0';
	 signal B : std_logic := '0';
	 --Outputs
	 signal Z : std_logic_vector(7 downto 0);
	 -- Clock period definitions
	 constant clk_period : time := 10 ns;
BEGIN
	 -- Instantiate the Unit Under Test (UUT)
	 uut: parking PORT MAP (
	 CLK => CLK,
	 ENB => ENB,
	 A => A,
	 B => B,
	 Z => Z
	 );
	 -- Clock process definitions
	 clk_process :process
	 begin
		 CLK <= '0';
		 wait for clk_period/2;
		 CLK <= '1';
		 wait for clk_period/2;
	 end process;
	 -- Stimulus process
	 stim_proc: process
	 begin
	 ENB <='1';
	 wait for clk_period*10;
	 ENB <='0';
	 
	 wait for clk_period*10;
	 A <='0'; B <='0'; wait for clk_period*1;
	 A <='1'; B <='0'; wait for clk_period*1;
	 A <='1'; B <='1'; wait for clk_period*1;
	 A <='0'; B <='1'; wait for clk_period*1;
	 A <='0'; B <='0'; wait for clk_period*1;
	 -- 1o car joined
	
	wait for clk_period*10;
	 A <='0'; B <='0'; wait for clk_period*5;
	 A <='1'; B <='0'; wait for clk_period*5;
	 A <='1'; B <='1'; wait for clk_period*5;
	 A <='0'; B <='1'; wait for clk_period*5;
	 A <='0'; B <='0'; wait for clk_period*5;
	 -- 2o car joined
	 
	 wait for clk_period*10;
	 A <='0'; B <='0'; wait for clk_period*5;
	 A <='0'; B <='1'; wait for clk_period*5;
	 A <='1'; B <='1'; wait for clk_period*5;
	 A <='1'; B <='0'; wait for clk_period*5;
	 A <='0'; B <='0'; wait for clk_period*5;
	 -- 1o car left
	 
	 wait for clk_period*10;
	 A <='0'; B <='0'; wait for clk_period*1;
	 A <='0'; B <='1'; wait for clk_period*1;
	 A <='1'; B <='1'; wait for clk_period*1;
	 A <='1'; B <='0'; wait for clk_period*1;
	 A <='0'; B <='0'; wait for clk_period*1;
	 -- 2o car left
	 wait;
	 end process;
END;
