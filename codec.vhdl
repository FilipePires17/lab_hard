library ieee, std;
use ieee.std_logic_1164.all;
use std.textio.all;

entity codec is
    port (
        interrupt : in std_logic;
        read_signal: in std_logic;
        write_signal: in std_logic;
        valid: out std_logic;

        codec_data_in: in std_logic_vector(7 downto 0);
        codec_data_out: out std_logic_vector(7 downto 0)
    );
end entity;

architecture naosei of codec is

    subtype word is std_logic_vector(7 downto 0);
    type t_arq is file of word;
    file arq_load_in : t_arq open read_mode is "input.bin";
    file arq_load_out : t_arq open append_mode is "output.bin";
    
begin
        
    process (interrupt)
        variable teste : word;
    begin
        if rising_edge(interrupt) then
            if read_signal = '1' and write_signal = '0' then
                codec_data_out <= "00000000";
                write(arq_load_out, codec_data_in);
                valid <= '1', '0' after 1 ns;
            end if;
            if read_signal = '0' and write_signal = '1' and not endfile(arq_load_in) then
                read(arq_load_in, teste);
                codec_data_out <= teste;
                valid <= '1', '0' after 1 ns;
            end if;
        end if;
    end process;

end architecture;