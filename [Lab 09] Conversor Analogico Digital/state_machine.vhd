library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity state_machine is
	port ( 
		analog_in : in STD_LOGIC;
		digital_out : out STD_LOGIC
	);
end state_machine;

architecture Behavioral of state_machine is

begin

	-- Disable other devices
	SPI_SS_B <= '1';
	AMP_CS <= '1';
	AD_CONV <= '0';
	SF_CE0 <= '1';
	FPGA_INIT_B <= '0';
	DAC_CLR <= '1'; -- reset active-low
	
	-- A ideia central � receber uma entrada analogica
	--		e entregar na sa�da da maquina de estados sua vers�o digital
	--			segundo o protocolo SPI
	
	
	-- Preciso controlar ADC e Amplifier via protocolo SPI 
	-- 	para tanto, � necess�rio 2 fsm para cada componente, cada uma
	-- 		trabalhando com seu clock
	
	-- A sa�da do Amplifier vai ser a entrada anal�gica da fsm do ADC


end Behavioral;

