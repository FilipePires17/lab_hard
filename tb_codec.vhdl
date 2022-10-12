library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_codec is
end;

architecture hibrida of tb_codec is

    signal interrupt, read_signal, write_signal, valid: std_logic;
    signal codec_data_in: bit_vector(7 downto 0); 
    signal codec_data_out: std_logic_vector(7 downto 0);

begin

    t1 : entity work.codec(io_sim)
          port map (interrupt, read_signal, write_signal, valid, codec_data_in, codec_data_out);

    check : process is
        type linha is record
            interrupt, read_signal, write_signal, valid : std_logic;
            codec_data_in : bit_vector(7 downto 0);
            codec_data_out : std_logic_vector(7 downto 0);
        end record;

        type vet_linha is array (natural range <>) of linha;
        constant tab_vdd : vet_linha :=

        --  (interrupt, r_s, w_s, valid, c_d_i, c_d_o)
        (( '0', '0', '0', '0', "00000000", "00000000" ),
         ( '1', '0', '1', '0', "00000000", "01010101" ),
         ( '0', '0', '0', '0', "00000000", "00000000" ),
         ( '1', '1', '0', '0', "00101010", "00000000" ),
         ( '0', '0', '0', '0', "00000000", "00000000" ),
         ( '1', '0', '1', '0', "00000000", "00101010" ),
         ( '0', '0', '0', '0', "00000000", "00000000" ),
         ( '0', '0', '0', '0', "00000000", "00000000" ),
         ( '0', '0', '0', '0', "00000000", "00000000" ));

        begin
            for i in tab_vdd'range loop
                interrupt <= tab_vdd(i).interrupt;
                read_signal <= tab_vdd(i).read_signal;
                write_signal <= tab_vdd(i).write_signal;
                codec_data_in <= tab_vdd(i).codec_data_in;

                wait for 2 ns;

                assert codec_data_out = tab_vdd(i).codec_data_out report "Erro data_out: " 
                    & integer'image(to_integer(unsigned(codec_data_out)))
                    & " na tab_vdd: "
                    & integer'image(to_integer(unsigned(tab_vdd(i).codec_data_out)));
            end loop;

            report "Fim dos testes";

            wait;
        end process check;
end hibrida ; -- hibrida