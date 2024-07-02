library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity integrator_module is
port(
		clk : in STD_LOGIC;
		DAC_CLR : out STD_LOGIC;
		SPI_SCK, SPI_SS_B, AMP_CS, AD_CONV, SF_CE0, FPGA_INIT_B : out STD_LOGIC;
		SPI_MOSI, DAC_CS : out STD_LOGIC
	);
end integrator_module;

architecture Behavioral of integrator_module is

	signal data : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal send_data : STD_LOGIC := '0';
	signal ready : STD_LOGIC;
	signal is_rising : STD_LOGIC := '1';
	
begin

	process (clk)
	begin
		if (falling_edge(CLK)) then
			send_data <= '0';
			if (ready = '1') then
				if (unsigned(data) = 2047) then
					is_rising <= '0';
				elsif (unsigned(data) = 0) then
					is_rising <= '1';
				end if;
				
				if (is_rising = '1') then
					data <= std_logic_vector(unsigned(data) + 1);
				else
					data <= std_logic_vector(unsigned(data) - 1);
				end if;
				
				send_data <= '1';
			end if;
		end if;
	end process;

	DAC : entity work.DAC(Behavioral)
		port map(
			CLK => clk,
			--SPI_MISO => '0',
			DAC_CLR => DAC_CLR,
			SEND_DATA => send_data,
			DATA => data,
			READY => ready,
			SPI_MOSI => SPI_MOSI,
			DAC_CS => DAC_CS,
			SPI_SCK => SPI_SCK, 
			SPI_SS_B => SPI_SS_B,
			AMP_CS => AMP_CS,
			AD_CONV => AD_CONV,
			SF_CE0 => SF_CE0, 
			FPGA_INIT_B => FPGA_INIT_B			
		);

end Behavioral;

