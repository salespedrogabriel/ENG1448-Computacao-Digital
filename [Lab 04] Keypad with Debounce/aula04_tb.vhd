library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

 
ENTITY aula04_tb IS
END aula04_tb;
 
ARCHITECTURE behavior OF aula04_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lab04
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         hex1 : IN  std_logic_vector(3 downto 0);
         hex0 : IN  std_logic_vector(3 downto 0);
         an : OUT  std_logic;
         sseg : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal hex1 : std_logic_vector(3 downto 0) := (others => '0');
   signal hex0 : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal an : std_logic;
   signal sseg : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lab04 PORT MAP (
          clk => clk,
          reset => reset,
          hex1 => hex1,
          hex0 => hex0,
          an => an,
          sseg => sseg
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.	
		
		hex1 <= "0011";
      hex0 <= "0001";

      wait for 1 ms;	

		hex1 <= "0011";
      hex0 <= "0001";

      wait for 1 ms;	
	
		hex1 <= "0000";
      hex0 <= "1111";

      wait for 1 ms;	

		hex1 <= "1110";
      hex0 <= "0000";

      wait for clk_period*10;
	
      -- insert stimulus here 

      wait;
   end process;

END;
