library ieee, std;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity codec is
    port (
        interrupt : in std_logic;
        read_signal: in std_logic;
        write_signal: in std_logic;
        valid: out std_logic;

        codec_data_in: in bit_vector(7 downto 0);
        codec_data_out: out std_logic_vector(7 downto 0)
    );
end entity;

architecture io_sim of codec is

    subtype word1 is std_logic_vector(7 downto 0);
    type t_arq is file of word1;
    
begin
        
    process (interrupt)
        file arq_load_in : text open read_mode is "input.txt";
        file arq_load_out : text open append_mode is "output.bin";
        variable text_line, teste : line;
        variable aux : std_logic_vector(7 downto 0) := "00000000";
        variable t : integer;
    begin
        valid <= '0';
        codec_data_out <= "00000000";
        if rising_edge(interrupt) then
            if read_signal = '1' and write_signal = '0' then
                write(teste, codec_data_in);
                writeline(arq_load_out, teste);
                valid <= '1', '0' after 1 ns;
            end if;
            if read_signal = '0' and write_signal = '1' and not endfile(arq_load_in) then
                readline(arq_load_in, text_line);
                read(text_line, t);
                aux := std_logic_vector(to_unsigned(t, 8));
                codec_data_out <= aux;
                valid <= '1', '0' after 1 ns;
            end if;
        end if;
    end process;

end architecture;