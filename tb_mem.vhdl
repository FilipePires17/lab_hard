library ieee;
use ieee.std_logic_1164.all;

entity tb_mem is
end;

architecture hibrida of tb_mem is
    signal clock, data_read, data_write : std_logic;

    signal data_addr: std_logic_vector(addr_width-1 downto 0);
    signal data_in: std_logic_vector(data_width-1 downto 0);
    signal data_out: std_logic_vector((data_width-1 downto 0);

begin
    t1 : entity work.mem(comportamental)
          port map (clock, data_read, data_write, data_addr, data_in, data_out);

    check : process is
        type linha is record
        clock, data_read, data_write, data_read, data_write: std_logic;
        data_addr: std_logic_vector(addr_width-1 downto 0) : (others => '0');
        data_in: std_logic_vector(data_width-1 downto 0) : (others => '0');
        data_out: std_logic_vector((data_width-1 downto 0) : (others => '0');
        end record;

        type vet_linha is array (natural range <>) of linha;
        constant tab_vdd : vet_linha :=

        (("1", "0", "0", "0000000000000000", "00000000", "00000000"),
         ("0", "0", "1", "0000000000000001", "10101010", "00000000"),
         ("1", "1", "0", "0000000000000001", "00000000", "10101010"));

        begin
            for i in tab_vdd'range loop
                clock <= tab_vdd(i).clock;
                data_read <= tab_vdd(i).data_read;
                data_write <= tab_vdd(i).data_write;
                data_addr <= tab_vdd(i).data_addr;
                data_in <= tab_vdd(i).data_in;

                wait for 1 ns;

                assert data_out = tab_vdd(i).data_out report "Erro data_out";
            end loop;

            report "Fim dos testes";

            wait;
        end process check;
end hibrida ; -- hibrida