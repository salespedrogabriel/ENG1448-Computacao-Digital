library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity fsm is
	port(
		clk, rst : in std_logic;
		rx : in std_logic;
		tx : out std_logic_vector(7 downto 0)
	);
end fsm;

architecture Behavioral of fsm is
	type state is (idle, half_startbit, rx_data, tx_data);
	signal curr_state : state := idle;
	
	signal bit_counter : unsigned(3 downto 0) := (others => '0');
	signal tx_reg : std_logic_vector(7 downto 0) := (others => '0');
	
	signal clk_counter : unsigned(8 downto 0) := (others => '0');
	signal clk_counter_limit : unsigned(8 downto 0) := (others => '0');
	signal clk_counter_flag : std_logic := '0';
	signal clk_counter_enable : std_logic := '0';
	signal rs232_clock : std_logic := '0';
	
begin
	rs232_clock <= std_logic(clk_counter(8));


	process (clk)
	begin
		if (rising_edge(clk)) then
			if (clk_counter_enable = '1') then
				if (clk_counter_flag = '1') then
					clk_counter <= (others => '0');
				else
					clk_counter <= clk_counter + 1;
				end if;
			else
				clk_counter <= (others => '0');
			end if;
		end if;
	end process;
	clk_counter_flag <= '1' when clk_counter = clk_counter_limit else '0';
	
	process (clk)
	begin
		if (rising_edge(clk)) then		
			case curr_state is
				when idle =>
					bit_counter <= (others => '0');
					clk_counter_enable <= '0';
					if (rx = '0') then -- recebi um 0, começar a contar!! K/2
						clk_counter_enable <= '1';
						clk_counter_limit  <= to_unsigned(216, clk_counter_limit'length);
						curr_state         <= half_startbit;
					end if;
					
				when half_startbit =>
					if (clk_counter_flag = '1') then -- contei k/2
						clk_counter_limit  <= to_unsigned(433, clk_counter_limit'length);
						curr_state 			 <= rx_data;
					end if;
					
				when rx_data =>
					if (clk_counter_flag = '1') then -- contei k/2
						if (bit_counter /= 8) then -- considera a leitura de dados com 8 bits
							bit_counter <= bit_counter + 1;
							tx_reg <= rx & tx_reg(7 downto 1);
						else -- if (bit_counter = 8) then
							bit_counter <= (others => '0');
							curr_state <= tx_data;
						end if;
					end if;
								
				when tx_data =>
					if tx_reg /= x"0D" then
						curr_state <= idle;
						tx <= tx_reg;		
					end if;

				when others =>
					curr_state <= idle;
			end case;
		end if;
	end process;
end Behavioral;

