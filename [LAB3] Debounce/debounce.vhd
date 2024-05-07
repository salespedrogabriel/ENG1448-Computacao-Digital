library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity debounce is
    generic(
        clk_freq    : natural := 50_000_000;  -- clock frequency in hz
        stable_time : natural := 10           -- time the signal must remain stable in ms
    );
    port(
        clk, reset  : in  STD_LOGIC;
        sw          : in  STD_LOGIC;
        tick        : out STD_LOGIC
    );
end debounce;

architecture Behavioral of debounce is

    constant counter_width : natural := natural(ceil(log2(real(clk_freq * stable_time / 1000))));
    constant counter_limit : natural := natural((clk_freq * stable_time / 1000) - 1);

    signal counter         : unsigned(counter_width-1 downto 0) := (0 => '1', others => '0');
    constant counter_l     : unsigned(counter_width-1 downto 0) := to_unsigned(counter_limit, counter_width);

    signal dff             : std_logic_vector(1 downto 0) := (others => '0');
    signal counter_set     : std_logic := '0';
    signal tick_reg        : std_logic_vector(1 downto 0) := (others => '0');

begin

    -- counter set/reset
    counter_set <= dff(0) xor dff(1);

    process(clk, reset)
    begin
        if reset = '1' then
            dff      <= (others => '0');
            counter  <= (others => '0');
            tick_reg <= (others => '0');
        elsif (clk'event and clk = '1') then
            dff(0)      <= sw;
            dff(1)      <= dff(0);
            tick_reg(1) <= tick_reg(0);
            if (counter_set = '1') then
                counter     <= (0 => '1', others => '0'); -- 1 pois um clock foi perdido pelo FFD do counter_set
            elsif (counter < counter_l) then
                counter     <= counter + 1; -- unsigned + integer <-- definido em IEEE.NUMERIC_STD.ALL
            else
                tick_reg(0) <= dff(1);
            end if;
        end if;
    end process;
    
    tick <= tick_reg(0) and not(tick_reg(1));

end Behavioral;
