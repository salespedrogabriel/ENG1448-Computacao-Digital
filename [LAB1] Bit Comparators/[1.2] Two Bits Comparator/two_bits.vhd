----------------------------------------------------------------------------------
-- University: PUC-Rio
-- Discipline: ENG1448 - Computação Digital
-- Author: Pedro Gabriel Serodio Sales
-- 
-- Create Date:    10:03:10 03/11/2024 
-- Evaluation Development Board: Spartan-3E Starter Board
-- Preferred Language: 		 VHDL
-- Source Name: 	         VHDL Module
-- Module Name:                  two_bits - Behavioral 
-- Project Name: 	         [1.2] Two Bits Comparator
-- Description: 
--
-- Revision: 
-- Revision 0.02 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity two_bits is
    Port ( a : in  STD_LOGIC_VECTOR(1 downto 0);
           b : in  STD_LOGIC_VECTOR(1 downto 0);
           z : out STD_LOGIC);
end two_bits;

architecture Behavioral of two_bits is

	signal comp : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

begin

	CompBit0 : entity work.one_bit(Behavioral)
	 port map(
		 a => a(0),
		 b => b(0),
		 z => comp(0)
	 );

	CompBit1 : entity work.one_bit(Behavioral)
	 port map(
		 a => a(1),
		 b => b(1),
		 z => comp(1)
	 );

	 Z <= comp(0) AND comp(1);


end Behavioral;

