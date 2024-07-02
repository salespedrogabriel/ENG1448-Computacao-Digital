library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity PIXEL_CTRL is
	generic(
		h_pixels : NATURAL := 800; --horizontal display width in pixels
		v_pixels : NATURAL := 600 --vertical display width in rows
	);
	
	port(
		pixel_clock : IN STD_LOGIC; --pixel clock
		display_on : IN STD_LOGIC; --display enable ('1' = display time, '0' = blanking time)
		pixel_x : IN NATURAL; --horizontal pixel coordinate
		pixel_y : IN NATURAL; --vertical pixel coordinate
		red : OUT STD_LOGIC;
		green : OUT STD_LOGIC;
		blue : OUT STD_LOGIC
	);
end PIXEL_CTRL;

architecture Behavioral of PIXEL_CTRL is

	signal img_height : integer := 100;
	signal img_width  : integer := 100;	
	constant vel_x	: integer := 1;
	constant vel_y	: integer := 1;
	signal img_vel_x	: integer := vel_x;
	signal img_vel_y	: integer := vel_y;
	
	signal hit_box_xi : integer := 350; --integer(ceil(real(h_pixels - img_width)*0.5));
	signal hit_box_yi : integer := 250; --integer(ceil(real(v_pixels - img_height)*0.5));
	signal hit_box_xf : integer := 0;	
	signal hit_box_yf : integer := 0;	
	
	signal counter : integer := 0;
	
	type t_colors is array (0 to 3) of std_logic_vector(2 downto 0);
	signal colors : t_colors := (
		0 => "100", -- Red
		1 => "010", -- Green
		2 => "001", -- Blue
		3 => "110"
	);
	signal idx_color : integer := 0;
	signal RGB       : std_logic_vector(2 downto 0) := "000";

begin

	hit_box_xf <= hit_box_xi + img_width - 1;
	hit_box_yf <= hit_box_yi + img_height - 1;


-- DESAFIO
	process(pixel_clock)
	begin
		if rising_edge(pixel_clock) then
			counter <= counter + 1;
			if (counter = 1000000) then
			
				if (hit_box_xi <= 0) then
					hit_box_xi <= hit_box_xi + vel_x;
					img_vel_x  <= vel_x;		
					idx_color <= idx_color + 1;
					if idx_color + 1 = colors'length then
						idx_color <= 0;
					end if;
				elsif (hit_box_xf >= h_pixels - 1) then
					hit_box_xi <= hit_box_xi - vel_x;
					img_vel_x  <= -vel_x;
					idx_color <= idx_color + 1;
					if idx_color + 1 = colors'length then
						idx_color <= 0;
					end if;
				else
					hit_box_xi <= hit_box_xi + img_vel_x;
				end if;
					
				if (hit_box_yi <= 0) then
					hit_box_yi <= hit_box_yi + vel_y;
					img_vel_y  <= vel_y;
					idx_color <= idx_color + 1;
					if idx_color + 1 = colors'length then
						idx_color <= 0;
					end if;					
				elsif (hit_box_yf >= v_pixels - 1) then
					hit_box_yi <= hit_box_yi - vel_y;
					img_vel_y  <= -vel_y;	
					idx_color <= idx_color + 1;
					if idx_color + 1 = colors'length then
						idx_color <= 0;
					end if;					
				else
					hit_box_yi <= hit_box_yi + img_vel_y;
				end if;		

				counter <= 0;
			end if;
		end if;
	end process;
-- codigo quadrado vermelho
--	process(pixel_clock)
--	begin
--		if rising_edge(pixel_clock) then
		
--			
--			if (pixel_x >= 350 and pixel_x <= 450) then
--				if (pixel_y >= 250 - 100 and pixel_y <= 350 - 100) then
--					RGB <= "100";
--				end if;										
--			else
--				RGB <= "000";
--			end if;		

--			if (pixel_x >= hit_box_xi and pixel_x <= hit_box_xf) and
--				(pixel_y >= hit_box_yi and pixel_y <= hit_box_yf) then
--				RGB <= colors(idx_color);
--			else
--				RGB <= "000";
--			end if;
			
--		end if;
--	end process;
	red   <= RGB(2) when display_on = '1' else '0';
	green <= RGB(1) when display_on = '1' else '0';
	blue  <= RGB(0) when display_on = '1' else '0';
	
end Behavioral;