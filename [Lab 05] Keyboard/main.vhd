
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
	port(
		clk, clk_kbd, reset : in STD_LOGIC;
		data : in STD_LOGIC;
		an : out STD_LOGIC;
		sseg : out STD_LOGIC_VECTOR(6 downto 0)
	);
end main;

architecture Behavioral of main is

	signal key : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	
begin

	u_states : entity work.states(Behavioral)
		port map(
			clk_kbd => clk_kbd,
			reset => reset,
			data => data,
			key => key
		);
		
	u_display : entity work.display(Behavioral)
		port map(
			clk  => clk,
			reset => reset,
			hex0 => key(3 downto 0),
			hex1 => key(7 downto 4),
			an => an,
			sseg => sseg
		);
	
end Behavioral;

