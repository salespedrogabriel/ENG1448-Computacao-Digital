
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
	port(
		A, B, ROT_CENTER : in STD_LOGIC;
		CLK, RST : in STD_LOGIC;
		LEDS : out STD_LOGIC_VECTOR(7 downto 0)
	);
end main;

architecture Behavioral of main is

	signal rotary_in : STD_LOGIC_VECTOR(1 downto 0);
	signal LEDS_reg : STD_LOGIC_VECTOR(7 downto 0) := (0 => '1', others => '0');

	signal rotary_q1 : std_logic := '0';
	signal rotary_q2 : std_logic := '0';
	
	signal delay_rotary_q1 : std_logic := '0';
	signal rotary_left : std_logic := '0';
	signal rotary_event : std_logic := '0';
	signal ROT_CENTER_TICK : std_logic := '0';

begin

	LEDS <= LEDS_reg;
	
	u_debounce : entity work.debounce(Behavioral)
		port map(
			clk    => clk,
			reset  => rst,
			sw     => ROT_CENTER,
			tick   => ROT_CENTER_TICK
		);	

	rotary_filter: process(clk)
		begin
			if clk'event and clk='1' then
				rotary_in <= B & A;
				case rotary_in is
					when "00" => rotary_q1 <= '0';
									 rotary_q2 <= rotary_q2;

					when "01" => rotary_q1 <= rotary_q1;
									 rotary_q2 <= '0';

					when "10" => rotary_q1 <= rotary_q1;
									 rotary_q2 <= '1';

					when "11" => rotary_q1 <= '1';
									 rotary_q2 <= rotary_q2;

					when others => rotary_q1 <= rotary_q1;
										rotary_q2 <= rotary_q2;
				end case;
			end if;
	end process rotary_filter;
	
	direction: process(clk)
		begin
			if clk'event and clk='1' then

				delay_rotary_q1 <= rotary_q1;
				if rotary_q1='1' and delay_rotary_q1='0' then
					rotary_event <= '1';
					rotary_left <= rotary_q2;
				else
					rotary_event <= '0';
					rotary_left <= rotary_left;
				end if;
			end if;
	end process direction;

	shift_leds: process(clk)
	begin
		if rising_edge(clk) then
		
			if (RST = '1') then
				LEDS_reg <= "00000001";
			end if;
		
			if (rotary_event = '1') then
				if (rotary_left = '1') then
					LEDS_reg <= LEDS_reg(6 downto 0) & LEDS_reg(7);
				else
					LEDS_reg <= LEDS_reg(0) & LEDS_reg(7 downto 1);
				end if;
			end if;
			
			if (ROT_CENTER_TICK = '1') then
				LEDS_reg <= not LEDS_reg;
			end if;
			
		end if;
	end process shift_leds;

end Behavioral;

