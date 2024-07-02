library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity main is
    Port ( 
			  clk, reset : in STD_LOGIC;
			  an : out STD_LOGIC;
			  sseg : out STD_LOGIC_VECTOR(6 downto 0);
			  rows : in STD_LOGIC_VECTOR(3 downto 0);
			  cols : out STD_LOGIC_VECTOR(3 downto 0)
	 );
end main;

architecture Behavioral of main is

	signal hex1 : STD_LOGIC_VECTOR(3 downto 0);
	signal hex0 : STD_LOGIC_VECTOR(3 downto 0);
	signal tick : STD_LOGIC := '0';
	signal key : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	

begin


	u_display: entity work.display(Behavioral)
	
		port map(
		clk => clk,
		reset => reset,
		hex1 => hex1,
		hex0 =>hex0,
		an => an,
		sseg => sseg
		);
		
  u_teclado: entity work.teclado(Behavioral)
	
		port map(
		clk => clk,
		reset => reset,
		rows => rows,
		cols => cols,
		key => key,
		tick => tick
	);
	 
	main : process(clk)
	
	begin
		if(clk'event and clk ='1') then
			if(reset = '1') then
				hex0 <= "0000";
				hex1 <= "0000";
			elsif (tick = '1') then
				hex1 <= hex0;
				hex0 <= key;
			end if;
		end if;
	end process;
	 
end Behavioral;

