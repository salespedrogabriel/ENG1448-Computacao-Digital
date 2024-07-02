LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb IS
END tb;
 
ARCHITECTURE behavior OF tb IS 
 
   -- Clock period definitions
	signal CLK : std_logic := '0';
   constant CLK_period : time := 10 ns;

	signal ADC_DATA : signed(13 downto 0) := (others => '0');
	signal ADC_DATA_SUM : signed(13 downto 0) := (others => '0');

BEGIN
 
	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;

	-- Stimulus process
	stim_proc: process
   begin		
		ADC_DATA <= to_signed(-8192, 14);
		
		wait for 10*CLK_period;
		ADC_DATA <= to_signed(-4095, 14);
		
		wait for 10*CLK_period;
		ADC_DATA <= to_signed(0, 14);
		
		wait for 10*CLK_period;
		ADC_DATA <= to_signed(4095, 14);
		
		wait for 10*CLK_period;
		ADC_DATA <= to_signed(8192, 14); -- -8192 -> 8191
		
		wait for 10*CLK_period;
		
		for i in 0 to 7 loop
			ADC_DATA <= to_signed(i*2048, 14);
			wait for CLK_period;
			ADC_DATA_SUM <= ADC_DATA + to_signed(-8192, 14);
			wait for 4*CLK_period;
		end loop;


		wait;
	end process;

END;
