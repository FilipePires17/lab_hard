library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity tb_soc is
end;

architecture mixed of tb_soc is

    constant firmware_filename: string := "firmware.txt";
    signal clock : std_logic := '0';
    signal started : std_logic := '0';

begin

    cpu: entity work.soc(hw)
        generic map (firmware_filename)
        port map (clock, started);

    estimulo_checagem : process is
        type linha is record
            clock, started : std_logic;
        end record;
        type tv is array (natural range 0 to 8) of linha;
        constant tabela: tv :=
        (('1','0'),
         ('0','0'),
         ('1','0'),
         ('0','0'),
         ('1','0'),
         ('0','0'),
         ('1','0'),
         ('0','0'),
         ('1','0'));

    begin
        for i in tabela'range loop
            clock <= tabela(i).clock;
            started <= tabela(i).started;
           
            wait for 5 ns;

        end loop;
        report "Fim dos testes";
        wait;
    end process estimulo_checagem;
end architecture;