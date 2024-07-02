
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity states is
	port(
		clk_kbd, reset : in STD_LOGIC;
		data : in STD_LOGIC;
		key : out STD_LOGIC_VECTOR(7 downto 0)
	);
end states;

architecture Behavioral of states is

	signal key_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal counter_reg : unsigned(3 downto 0) := "0000";
	
	type fsm_t is (idle, rx_kbd_data, send_key);
	signal state : fsm_t := idle;
	
begin	
	key <= key_reg;

	sync_proc: process(clk_kbd, reset)
	begin
		if (reset = '1') then
			key_reg <= "00000000";
			
		elsif (rising_edge(clk_kbd)) then
			case state is			
				when idle =>
					if (data = '0') then
						state <= rx_kbd_data;
					end if;

				when rx_kbd_data =>
					if(counter_reg(3) /= '1') then
						key_reg <= data & key_reg(7 downto 1);
						counter_reg <= counter_reg + 1;
					else
						counter_reg <= "0000";
						state <= send_key;
					end if;
					
				when send_key =>
					state <= idle;
									
				when others => 
					state <= idle;					
			end case;
		end if;
	end process sync_proc;
end Behavioral;

