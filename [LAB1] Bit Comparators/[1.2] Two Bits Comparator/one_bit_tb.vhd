--------------------------------------------------------------------------------
-- University: PUC-Rio
-- Discipline: ENG1448 - Computação Digital
-- Author: Pedro Gabriel Serodio Sales
--
-- Create Date:   10:03:38 03/11/2024
-- Evaluation Development Board: Spartan-3E Starter Board
-- Preferred Language: VHDL
-- Source Name: 	 VHDL Module
-- Module Name:    one_bit - Behavioral 
-- Project Name: 	 [1.2] Two Bits Comparator  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: single_bit
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY one_bit_tb IS
END one_bit_tb;
 
ARCHITECTURE behavior OF one_bit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT one_bit
    PORT(
         A : IN  std_logic;
         B : IN  std_logic;
         Z : OUT  std_logic
        );
    END COMPONENT;
	

   --Inputs
   signal A : std_logic := '0';
   signal B : std_logic := '0';

 	--Outputs
   signal Z : std_logic;
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: one_bit PORT MAP (
          A => A,
          B => B,
          Z => Z
        );

   -- Clock process definitions

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		a <= '0';
		b <= '0';
		wait for 100 ns;	
		a <= '1';
		b <= '0';
		wait for 100 ns;	
		a <= '0';
		b <= '1';
		wait for 100 ns;	
		a <= '1';
		b <= '1';
      wait for 100 ns;

      -- insert stimulus here 

      wait;
   end process;

END;
