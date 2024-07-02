--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:08:10 06/17/2022
-- Design Name:   
-- Module Name:   C:/Users/jpjab/Desktop/lab10-eng1448/lab10-eng1448/VGA/main_tb.vhd
-- Project Name:  VGA
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY main_tb IS
END main_tb;
 
ARCHITECTURE behavior OF main_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         VGA_RED : OUT  std_logic;
         VGA_GREEN : OUT  std_logic;
         VGA_BLUE : OUT  std_logic;
         VGA_HSYNC : OUT  std_logic;
         VGA_VSYNC : OUT  std_logic;
         LEDS : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';

 	--Outputs
   signal VGA_RED : std_logic;
   signal VGA_GREEN : std_logic;
   signal VGA_BLUE : std_logic;
   signal VGA_HSYNC : std_logic;
   signal VGA_VSYNC : std_logic;
   signal LEDS : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          CLK => CLK,
          RST => RST,
          VGA_RED => VGA_RED,
          VGA_GREEN => VGA_GREEN,
          VGA_BLUE => VGA_BLUE,
          VGA_HSYNC => VGA_HSYNC,
          VGA_VSYNC => VGA_VSYNC,
          LEDS => LEDS
        );

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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
