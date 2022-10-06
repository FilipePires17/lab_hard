library ieee;
use ieee.std_logic_1164.all;

entity tb_codec is
end;

architecture hibrida of tb_codec is
    signal clk, interrupt, read_signal, write_signal, valid: std_logic;

    signal codec_data_in, codec_data_out: std_logic_vector(7 downto 0) : (others
=> '0');

begin

    t1 : entity work.codec(comportamental)
          port map (clk, interrupt, read_signal, write_signal, valid,
codec_data_in, codec_data_out);

    check : process is
        type linha is record
            clk, interrupt, read_signal, write_signal, valid : std_logic;
            codec_data_in, codec_data_out : std_logic_vector(7 downto 0);
        end record;

        type vet_linha is array (natural range <>) of linha;
        constant tab_vdd : vet_linha :=

        -- para instrucao in (read = 1, write = 0, interrupt = 1, valid = 1,
interrupt = 0)
        --( ( "1", "1", "1", "0", "1", "10101010", "00000000" ),
        --( "0", "", "", "", "", "", "" ),
        --( "1", "", "", "", "", "", "" ) );

        begin
            for i in tab_vdd'range loop


                wait for 1 ns;

                assert     report "Erro";
                assert     report "Erro";
            end loop;

            report "Fim dos testes";

            wait;
        end process check;
end hibrida ; -- hibrida