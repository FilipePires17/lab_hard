library ieee;
use ieee.std_logic_1164.all;

entity tb_mem is 
end;

architecture hibrida of tb_mem is
    signal clk: in std_logic;
    
    signal data_read, data_write: out std_logic;
    signal data_addr: in std_logic_vector(addr_width-1 downto 0);
    signal data_in: in std_logic_vector(data_width-1 downto 0);
    signal data_out: out std_logic_vector((data_width*4)-1 downto 0);

begin
    t1 : entity work.mem()
          port map (clock, data_read, data_write, data_addr, data_in, data_out);
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