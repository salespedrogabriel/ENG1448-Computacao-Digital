
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lab06 is
	port(
		clk, rst : in STD_LOGIC;
		data 		: in STD_LOGIC;
		an 		: out STD_LOGIC;
		sseg 		: out STD_LOGIC_VECTOR(6 downto 0)
	
	);
	
end lab06;

architecture Behavioral of lab06 is
	signal key : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

begin

	
	u_fsm : entity work.fsm(Behavioral)
		port map(
			clk => clk,
			rst => rst,
			rx => data,
			tx => key
		);
	
	u_display : entity work.display(Behavioral)
		port map(
			clk => clk,
			rst => rst,
			hex0 => key(3 downto 0),
			hex1 => key(7 downto 4),
			an => an,
			sseg => sseg
		);
	


end Behavioral;

