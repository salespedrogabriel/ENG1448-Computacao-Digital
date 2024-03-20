----------------------------------------------------------------------------------
-- University: PUC-Rio
-- Discipline: ENG1448 - Computação Digital
-- Author:     Pedro Gabriel Serodio Sales
-- 
-- Create Date:    09:49:55 03/18/2024 
-- Evaluation Development Board: Spartan-3E Starter Board
-- Preferred Language:           VHDL
-- Source Name: 	         VHDL Module 
-- Module Name:                  parking - Behavioral 
-- Project Name:                 [2] Parking
-- Description: 
--
-- Revision: 
-- Revision 0.03 - File Created
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

entity parking is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Z : out  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           ENB : in  STD_LOGIC);
end parking;

architecture Behavioral of parking is

	type state_type is (idle, e1, e2, e3, e4, l1, l2, l3, l4);
	signal state_reg, state_next: state_type := idle;
	signal output_machine : std_logic_vector(1 downto 0) := "00";
	signal counter : std_logic_vector(7 downto 0) := (others => '0');
begin

	process(CLK, ENB)
	begin
		if(ENB = '1') then
			counter <= (others => '0');
		elsif (CLK'event and CLK = '1') then
			if output_machine = "01" then
				counter <= '0' & counter(7 downto 1);
			elsif output_machine = "10" then
				counter <= counter(6 downto 0) & '1';			
			end if;
		end if;
	end process;
					
	process(CLK, ENB)
	begin
		if(ENB = '1') then
			state_reg <= idle;
		elsif (CLK'event and CLK = '1') then
			state_reg <= state_next;
		end if;
	end process;

-- next state output logic
	process(state_reg, A,B, output_machine, counter)
	begin
		state_next <= state_reg;
		case state_reg is
			
			when idle =>
				-- Starting to Enter --
				if a = '1' and b = '0' then
					state_next<= E1;
					output_machine <= "00";
				-- Starting to Leave --
				elsif a = '0' and b = '1' then
					state_next<= L1;
					output_machine <= "00";
				-- Idle --
				elsif a = '0' and b = '0' then
					state_next<= idle;
					output_machine <= "00";
				end if;

			-- Cases while Entering --
							
			when E1 =>
				if a = '1' and b = '1' then
					state_next<= E2;
					output_machine <= "00";
				elsif a = '0' and b = '0' then
					state_next<= idle;
					output_machine <= "00";
				end if;
				
			when E2 =>
				if a = '0' and b = '1' then
					state_next<= E3;
					output_machine <= "00";
				elsif a = '1' and b = '0' then
					state_next<= E1;
					output_machine <= "00";
				end if;
			
			when E3 =>
				if a = '0' and b = '0' then
					state_next<= E4;
					output_machine <= "10";
				elsif a = '1' and b = '1' then
					state_next<= E1;
					output_machine <= "00";
				end if;
				
			when E4 =>
					state_next<= idle;
					output_machine <= "00";
					
			-- Cases while Leaving --

			when L1 =>
				if a = '1' and b = '1' then
					state_next<= L2;
					output_machine <= "00";
				elsif a = '0' and b = '0' then
					state_next<= idle;
					output_machine <= "00";
				end if;
				
			when L2 =>
				if a = '1' and b = '0' then
					state_next<= L3;
					output_machine <= "00";
				elsif a = '0' and b = '1' then
					state_next<= L1;
					output_machine <= "00";
				end if;
			
			when L3 =>
				if a = '0' and b = '0' then
					state_next<= L4;
					output_machine <= "01";
	
				elsif a = '1' and b = '1' then
					state_next<= L2;
					output_machine <= "00";
				end if;
				
			when L4 =>
					state_next<= idle;
					output_machine <= "00";
			
		end case;
	end process;

	Z <= counter;	

end Behavioral;

