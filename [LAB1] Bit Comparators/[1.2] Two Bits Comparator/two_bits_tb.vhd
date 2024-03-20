--------------------------------------------------------------------------------
-- University: PUC-Rio
-- Discipline: ENG1448 - Computação Digital
-- Author: Pedro Gabriel Serodio Sales
--
-- Create Date:   10:03:38 03/11/2024
-- Evaluation Development Board: Spartan-3E Starter Board
-- Preferred Language: VHDL
-- Source Name: 	 VHDL Module
-- Module Name:    two_bit - Behavioral 
-- Project Name: 	 [1.1] Two Bits Comparator  
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
USE ieee.numeric_std.ALL;
 
ENTITY two_bits_tb IS
END two_bits_tb;
 
ARCHITECTURE behavior OF two_bits_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT two_bits
    PORT(
         a : IN  std_logic_vector(1 downto 0);
         b : IN  std_logic_vector(1 downto 0);
         z : OUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal a : std_logic_vector(1 downto 0) := (others => '0');
   signal b : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal z : std_logic;
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: two_bits PORT MAP (
          a => a,
          b => b,
          z => z
        );
 
   -- Stimulus process
   stim_proc: process
   begin		
		for I in 0 to 3 loop
			A <= std_logic_vector(to_unsigned(I, 2));
			for J in 0 to 3 loop
				B <= std_logic_vector(to_unsigned(J, 2));
				wait for 100 ns;
			end loop;
		end loop;

      wait for 100 ns;

      -- insert stimulus here 

      wait;
   end process;

END;
