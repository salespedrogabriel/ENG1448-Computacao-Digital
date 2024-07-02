
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is
	port(
		CLK : in STD_LOGIC;
		LCD_RS, LCD_RW, LCD_E : out STD_LOGIC;
		SF_CE0 : out STD_LOGIC;
		DATA : out STD_LOGIC_VECTOR(3 downto 0)
	);
end main;

architecture Behavioral of main is

	type INIT_DATA_t is array (0 to 3) of std_logic_vector(3 downto 0);
	signal INIT_DATA : INIT_DATA_t := (0 => "0011", 1 => x"3", 2 => x"3", 3 => x"2");
	
	type CONF_DATA_t is array (0 to 7) of std_logic_vector(3 downto 0);
	signal CONF_DATA : CONF_DATA_t := (0 => x"2", 1 => x"8", 2 => x"0", 3 => x"6", 4 => x"0", 5 => x"C", 6 => x"0", 7 => x"1");

	type WRITE_DATA_t is array (0 to 17) of std_logic_vector(3 downto 0);
	signal WRITE_DATA : WRITE_DATA_t := (
		0 => "0101", 1 => "0011", --  S 
		2 => "0100", 3 => "1111", --  O
		4 => "0100", 5 => "1100",  -- L
		6 => "0010", 7 => "0000",  -- " "
		8 => "0100", 9 => "0101",  -- E
		10 => "0010", 11 => "0000",  -- " "
		12 => "0100", 13 => "1100",  -- L
		14 => "0101", 15 => "0101",  -- U
		16 => "0100", 17 => "0001"  --  A
	);


	signal idx_data : integer := 0;

	type TIME_DATA_t is array (0 to 60) of unsigned(19 downto 0);
	signal TIME_DATA : TIME_DATA_t := (
	-- init time intervals
		0 => to_unsigned(750000, 20),
		1 => to_unsigned(12, 20),         -- 240 ns
		2 => to_unsigned(205000, 20),
		3 => to_unsigned(12, 20),
		4 => to_unsigned(5000, 20),       -- 100 us
		5 => to_unsigned(12, 20),
		6 => to_unsigned(2000, 20),       -- 40 us
		7 => to_unsigned(12, 20),
		8 => to_unsigned(2000, 20),
	-- conf time intervals
		9 => to_unsigned(12, 20),
		10 => to_unsigned(50, 20),        -- 1 us
		11 => to_unsigned(12, 20),        
		12 => to_unsigned(2000, 20),
		13 => to_unsigned(12, 20),
		14 => to_unsigned(50, 20),        -- 1 us
		15 => to_unsigned(12, 20),        
		16 => to_unsigned(2000, 20),
		17 => to_unsigned(12, 20),
		18 => to_unsigned(50, 20),        -- 1 us
		19 => to_unsigned(12, 20),        
		20 => to_unsigned(2000, 20),
		21 => to_unsigned(12, 20),
		22 => to_unsigned(50, 20),        -- 1 us
		23 => to_unsigned(12, 20),        
		24 => to_unsigned(82000, 20),
	-- write time intervals
		25 => to_unsigned(12, 20),
		26 => to_unsigned(50, 20),        -- 1 us
		27 => to_unsigned(12, 20),        
		28 => to_unsigned(2000, 20),
		
		29 => to_unsigned(12, 20),
		30 => to_unsigned(50, 20),        -- 1 us
		31 => to_unsigned(12, 20),        
		32 => to_unsigned(2000, 20),
		
		33 => to_unsigned(12, 20),
		34 => to_unsigned(50, 20),        -- 1 us
		35 => to_unsigned(12, 20),        
		36 => to_unsigned(2000, 20),
		
		37 => to_unsigned(12, 20),
		38 => to_unsigned(50, 20),        -- 1 us
		39 => to_unsigned(12, 20),        
		40 => to_unsigned(2000, 20),
		
		41 => to_unsigned(12, 20),
		42 => to_unsigned(50, 20),        -- 1 us
		43 => to_unsigned(12, 20),        
		44 => to_unsigned(2000, 20),
		
		45 => to_unsigned(12, 20),
		46 => to_unsigned(50, 20),        -- 1 us
		47 => to_unsigned(12, 20),        
		48 => to_unsigned(2000, 20),
		
		49 => to_unsigned(12, 20),
		50 => to_unsigned(50, 20),        -- 1 us
		51 => to_unsigned(12, 20),        
		52 => to_unsigned(2000, 20),
		
		53 => to_unsigned(12, 20),
		54 => to_unsigned(50, 20),        -- 1 us
		55 => to_unsigned(12, 20),        
		56 => to_unsigned(2000, 20),
		
		57 => to_unsigned(12, 20),
		58 => to_unsigned(50, 20),        -- 1 us
		59 => to_unsigned(12, 20),        
		60 => to_unsigned(2000, 20)
	);
		
	TYPE FSM_t is (idle, init_a, init_b, conf_a, conf_b, write_a, write_b, finish);
	signal STATE : FSM_t := idle;
	
	signal counter : unsigned(19 downto 0) := (others => '0');
	signal idx : integer := 0;
	signal counter_limit : unsigned(19 downto 0) := TIME_DATA(0);

begin

	SF_CE0 <= '1';
	LCD_RW <= '0';

	sync_proc: process(clk)
	begin
		if (rising_edge(clk)) then
			case state is			
				when idle =>
					data <= INIT_DATA(idx_data);
					LCD_RS <= '0';
					LCD_E <= '0';
					if (counter = counter_limit) then
						state <= init_a;
						idx <= idx + 1;
						counter <= (others => '0');
					else
						counter <= counter + 1;
					end if;
					
				when init_a =>
					LCD_E <= '1';				
					counter_limit <= TIME_DATA(idx); 
					if (counter = counter_limit) then
						state <= init_b;
						idx <= idx + 1;
						counter <= (others => '0');
					else
						counter <= counter + 1;
					end if;
					
				when init_b =>
					LCD_E <= '0';
					data <= INIT_DATA(idx_data);
					counter_limit <= TIME_DATA(idx);
					if (counter = counter_limit) then
						state <= init_a;
						idx <= idx + 1;
						counter <= (others => '0');
						idx_data <= idx_data + 1;
						
						if(idx = 8) then
							state <= conf_a;
							data <= CONF_DATA(0);
							idx_data <= 1; 
						end if;
					else
						counter <= counter + 1;
					end if;
				
				when conf_a =>
					LCD_E <= '1';
					counter_limit <= TIME_DATA(idx);
					if (counter = counter_limit) then
						state <= conf_b;
						idx <= idx + 1;
						counter <= (others => '0');
					else
						counter <= counter + 1;
					end if;
				
				when conf_b =>
					LCD_E <= '0';
					if(idx_data < 8) then
						data <= CONF_DATA(idx_data);
					end if;
					counter_limit <= TIME_DATA(idx);
					if (counter = counter_limit) then
						state <= conf_a;
						idx <= idx + 1;
						counter <= (others => '0');
						idx_data <= idx_data + 1;
						
						if(idx = 24) then
							state <= write_a;
							data <= WRITE_DATA(0);
							idx_data <= 1;
						end if;
					else
						counter <= counter + 1;
					end if;
					
				when write_a =>	
					LCD_E <= '1';
					LCD_RS <= '1';
					counter_limit <= TIME_DATA(idx);
					if (counter = counter_limit) then
						state <= write_b;
						idx <= idx + 1;
						counter <= (others => '0');
					else
						counter <= counter + 1;
					end if;
				
				when write_b =>
					LCD_E <= '0';
					LCD_RS <= '0';
					if(idx_data < 18) then
						data <= WRITE_DATA(idx_data);
					end if;
					counter_limit <= TIME_DATA(idx);
					if (counter = counter_limit) then
						state <= write_a;
						idx <= idx + 1;
						counter <= (others => '0');
						idx_data <= idx_data + 1;
						
						if(idx = 60) then
							state <= finish;
						end if;
					else
						counter <= counter + 1;
					end if;

				when finish =>
					null;
									
				when others => 
					state <= idle;					
			end case;
		end if;
	end process sync_proc;

end Behavioral;

