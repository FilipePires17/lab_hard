library ieee;
use ieee.std_logic_1164.all;

entity tb_codec is 
end;

architecture hibrida of tb_codec is
    signal clk: std_logic;
    
    signal interrupt, read_signal, write_signal, valid: std_logic;
    signal codec_data_in, codec_data_out: std_logic_vector(7 downto 0);

begin
    t1 : entity work.mem(comportamental)
          port map (clk, interrupt, read_signal, write_signal, valid, codec_data_in, codec_data_out);
    check : process is
        type     is record
            
        end record;
        type      is array (natural range <>) of    ;
        constant     :    :=
        (   );

        begin
            for i in      'range loop
            

                wait for 1 ns;

                assert     report "Erro";
                assert     report "Erro";
            end loop;

            report "Fim dos testes";

            wait;
        end process check;
end hibrida ; -- hibrida