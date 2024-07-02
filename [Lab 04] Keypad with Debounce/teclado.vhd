
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity teclado is
	port(
		clk, reset : in STD_LOGIC;
		rows : in STD_LOGIC_VECTOR(3 downto 0);
		cols : out STD_LOGIC_VECTOR(3 downto 0);
		key : out STD_LOGIC_VECTOR(3 downto 0);
		tick : out STD_LOGIC
	);
end teclado;

architecture Behavioral of teclado is

	-- refresh rate ~ 763 Hz (50 MHz / 2^16 = 762.9394 Hz)	-- portanto precisamos de mais 1 bit para controlar 2 saídas ===> 763 / 2 ~ 380 Hz (refresh rate)
	constant N : natural := 16;
	signal counter, c_next : unsigned(N-1 downto 0) := (others => '0');

	type fsm_t is (col1, col1_read_rows, col2, col2_read_rows, col3, col3_read_rows, col4, col4_read_rows);
	signal state : fsm_t := col1;
	
	signal sel : STD_LOGIC := '0';
	signal rows_db : STD_LOGIC_VECTOR(3 downto 0);
	signal key_tick : STD_LOGIC_VECTOR(3 downto 0);
	
	signal key_reg : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	

begin

	-- register
	process(clk, reset)
	begin
		if (clk'event and clk = '1') then
			if (reset = '1') then
				counter <= (others => '0');
			else
				counter <= c_next;
			end if;
		end if;
	end process;
	
	-- next-state logic for the counter
	c_next <= counter + 1;
	
	-- 2 MSB to control the 4-to-1 mux
	-- and generate active-low "an" signal
	sel <= STD_LOGIC(counter(N-1));

	debounce0 : entity work.debounce(Behavioral)
		port map(
			clk    => clk,
			reset  => reset,
			sw     => rows(0),
			db     => rows_db(0),
			tick   => key_tick(0)
		);
		
	debounce1 : entity work.debounce(Behavioral)
			port map(
				clk    => clk,
				reset  => reset,
				sw     => rows(1),
				db     => rows_db(1),
				tick   => key_tick(1)
			);
			
	debounce2 : entity work.debounce(Behavioral)
			port map(
				clk    => clk,
				reset  => reset,
				sw     => rows(2),
				db     => rows_db(2),
				tick   => key_tick(2)
			);
			
	debounce4 : entity work.debounce(Behavioral)
			port map(
				clk    => clk,
				reset  => reset,
				sw     => rows(3),
				db     => rows_db(3),
				tick   => key_tick(3)
			);

	tick <= key_tick(0) or key_tick(1) or key_tick(2) or key_tick(3);
	key <= key_reg;

	sync_proc: process(sel, reset)
	begin
		if (reset = '1') then
			key_reg <= "0000";
		elsif (rising_edge(sel)) then
			case state is
			
				when col1 =>
					cols <= "0111";
					state <= col1_read_rows;
				when col1_read_rows =>
					state <= col1_read_rows;
					if rows_db = "0111" then
						key_reg <= "0001"; -- 1
					elsif rows_db = "1011" then
						key_reg <= "0100"; -- 4
					elsif rows_db = "1101" then
						key_reg <= "0111"; -- 7
					elsif rows_db = "1110" then
						key_reg <= "0000"; -- 0
					else
						state <= col2;
					end if;
					
				when col2 =>
					cols <= "1011";
					state <= col2_read_rows;
				when col2_read_rows =>
					state <= col2_read_rows;
					if rows_db = "0111" then
						key_reg <= "0010"; -- 2
					elsif rows_db = "1011" then
						key_reg <= "0101"; -- 5
					elsif rows_db = "1101" then
						key_reg <= "1000"; -- 8
					elsif rows_db = "1110" then
						key_reg <= "1111"; -- F
					else
						state <= col3;
					end if;
					
				when col3 =>
					cols <= "1101";
					state <= col3_read_rows;
				when col3_read_rows =>
					state <= col3_read_rows;
					if rows_db = "0111" then
						key_reg <= "0011"; -- 3
					elsif rows_db = "1011" then
						key_reg <= "0110"; -- 6
					elsif rows_db = "1101" then
						key_reg <= "1001"; -- 9
					elsif rows_db = "1110" then
						key_reg <= "1110"; -- E
					else
						state <= col4;
					end if;
					
				when col4 =>
					cols <= "1110";
					state <= col4_read_rows;
				when col4_read_rows =>
					state <= col4_read_rows;
					if rows_db = "0111" then
						key_reg <= "1010"; -- A
					elsif rows_db = "1011" then
						key_reg <= "1011"; -- B
					elsif rows_db = "1101" then
						key_reg <= "1100"; -- C
					elsif rows_db = "1110" then
						key_reg <= "1101"; -- D
					else
						state <= col1;
					end if;
				
				when others => 
					state <= col1;
					
			end case;
		end if;
	end process sync_proc;

end Behavioral;

