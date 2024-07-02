library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_ADC is
	port ( 
		CLK : in STD_LOGIC;
		DAC_CLR : out STD_LOGIC;
		VINA : in STD_LOGIC;
		AMP_DOUT : in STD_LOGIC; 				-- Desconsiderar este sinal
		SPI_MOSI, AMP_CS, SPI_SCK, AMP_SHDN : out STD_LOGIC
	);
end fsm_ADC;

architecture Behavioral of fsm_ADC is

	signal counter : integer := 0;
	type fsm_t is (conf_amp, send_data);
	signal state : fsm_t := conf_amp;
	
	signal conf_amp_bits: std_logic_vector(7 downto 0) := "00010001";
	signal clk_120ns : std_logic := '0';
	
begin
	SPI_SCK <= clk_120ns;

	process (CLK)
		variable counter : natural range 0 to 3;
	begin
		if (rising_edge(CLK)) then
			counter := counter + 1;
			if counter = 3 then
				clk_120ns <= not clk_120ns;
				counter := 0;
			end if;
		end if;
	end process;

	process (CLK)
	begin
		if (rising_edge(clk_120ns)) then		
			case state is		
			
				when conf_amp =>
					AMP_CS <= '0';
					counter <= counter + 1;
					SPI_MOSI <= conf_amp_bits(7 - counter);
					
					if (counter = 7) then
						state <= send_data;
						counter <= 0;
						AMP_CS <= '1'; -- Desabilita o setting de um novo ganho do pre-amp
						AD_CONV <= '1';
					end if;			
					
				when send_data =>
					AD_CONV <= '0';
					counter <= counter + 1;
					
					if (counter > 17) then
						SPI_MOSI <= conf_amp_bits(31 - counter);

					
					end if;
				
					
				when others =>
					state <= wait_conf_amp;
			end case;

		end if;
	end process;

	-- Disable other devices
	SPI_SS_B <= '1';
	AMP_CS <= '1';
	AD_CONV <= '0';
	SF_CE0 <= '1';
	FPGA_INIT_B <= '0';
	DAC_CLR <= '1'; -- reset active-low
	
	-- A ideia central é receber uma entrada analogica
	--		e entregar na saída da maquina de estados sua versão digital
	--			segundo o protocolo SPI
	
	
	-- Preciso controlar ADC e Amplifier via protocolo SPI 
	-- 	para tanto, é necessário 2 fsm para cada componente, cada uma
	-- 		trabalhando com seu clock
	
	-- A saída do Amplifier vai ser a entrada analógica da fsm do ADC


end Behavioral;

