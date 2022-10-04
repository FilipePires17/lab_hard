library ieee;
use ieee.std_logic_1164.all;

entity tb_cpu is 
end;

architecture hibrida of tb_cpu is
    signal clk, halt: in std_logic;
    
    signal instruction_in: in std_logic_vector(data_width-1 downto 0);
    signal instruction_addr: out std_logic_vector(addr_width-1 downto 0);
    
    signal data_read, data_write: out std_logic;
    signal data_addr: out std_logic_vector(addr_width-1 downto 0);
    signal data_in: out std_logic_vector((data_width*4)-1 downto 0);
    signal data_out: in std_logic_vector(data_width-1 downto 0);

    signal codec_interrupt, codec_read, codec_write: out std_logic;
    signal codec_valid: in std_logic;

    signal codec_data_out: in std_logic_vector(7 downto 0);
    signal codec_data_in: out std_logic_vector(7 downto 0);

begin
    t1 : entity work.cpu()
          port map (clk, halt, instruction_in, instruction_addr, data_read, data_write, data_addr, data_in,
          data_out, codec_interrupt, codec_read, codec_write, codec_valid, codec_data_out, codec_data_in);
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