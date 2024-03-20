----------------------------------------------------------------------------------
-- University: PUC-Rio
-- Discipline: ENG1448 - Computação Digital
-- Author: Pedro Gabriel Serodio Sales
-- 
-- Create Date:    10:03:10 03/11/2024 
-- Evaluation Development Board: Spartan-3E Starter Board
-- Preferred Language: 		 VHDL
-- Source Name: 	         VHDL Module
-- Module Name:                  one_bit - Behavioral 
-- Project Name: 	         [1.2] One Bit Comparator
-- Description: 
--
-- Revision: 
-- Revision 0.02 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity one_bit is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Z : out  STD_LOGIC);
end one_bit;

architecture Behavioral of one_bit is

	signal comp1,comp2 : std_logic := '0';

begin
	
	comp1 <= (A AND B);
	comp2 <= (NOT A AND NOT B);
	Z<= comp1 OR comp2;


end Behavioral;

