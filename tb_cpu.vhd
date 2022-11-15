library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cpu is 
end;

architecture hibrida of tb_cpu is
    signal clk, halt: std_logic;
    
    signal instruction_in, data_out : std_logic_vector(7 downto 0);
    signal instruction_addr, data_addr: std_logic_vector(7 downto 0);
    
    signal data_read, data_write, codec_valid, codec_interrupt, codec_read, codec_write: std_logic;
    signal data_in: std_logic_vector(31 downto 0);

    signal codec_data_out, codec_data_in: std_logic_vector(7 downto 0);

begin
    t1 : entity work.cpu(clean)
          port map (clk, halt, instruction_in, instruction_addr, data_read, data_write, data_addr, data_in,
          data_out, codec_interrupt, codec_read, codec_write, codec_valid, codec_data_out, codec_data_in);
    check : process is
        type linha is record
            clk, halt: std_logic;
            instruction_in, data_out: std_logic_vector(7 downto 0);
            instruction_addr, data_addr: std_logic_vector(7 downto 0);
            data_read, data_write, codec_valid, codec_interrupt, codec_read, codec_write: std_logic;
            data_in: std_logic_vector(31 downto 0);
            codec_data_out, codec_data_in: std_logic_vector(7 downto 0);
        end record;
        type vet_linha is array (natural range <>) of linha;
        constant tab_vdd : vet_linha :=
        --(clk,halt,ins_in,d_o,ins_addr,d_addr,d_r,d_w,c_v,c_int,c_r,c_w,d_in, c_d_o, c_d_i)
        (('0', '0', "00000000", "00000000", "00000000", "00000000", '0', '0', '0', '0', '0', '0', "00000000000000000000000000000000", "00000000", "00000000"),
         ('0', '0', "00000000", "00000000", "00000000", "00000000", '0', '0', '0', '0', '0', '0', "00000000000000000000000000000000", "00000000", "00000000"),
         ('0', '0', "00000000", "00000000", "00000000", "00000000", '0', '0', '0', '0', '0', '0', "00000000000000000000000000000000", "00000000", "00000000"),
         ('0', '0', "00000000", "00000000", "00000000", "00000000", '0', '0', '0', '0', '0', '0', "00000000000000000000000000000000", "00000000", "00000000"));

        begin
            for i in tab_vdd'range loop
                clk <= tab_vdd(i).clk;
                halt <= tab_vdd(i).halt;
                instruction_in <= tab_vdd(i).instruction_in;
                data_out <= tab_vdd(i).data_out;
                codec_valid <= tab_vdd(i).codec_valid;
                codec_data_out <= tab_vdd(i).codec_data_out;
                wait for 2 ns;

                assert instruction_addr = tab_vdd(i).instruction_addr report "Erro instr_addr: "
                & integer'image(to_integer(unsigned(instruction_addr)))
                & " na tab_vdd: "
                & integer'image(to_integer(unsigned(tab_vdd(i).instruction_addr)));

                assert data_read = tab_vdd(i).data_read report "Erro data_read: "
                & integer'image(to_integer(unsigned(data_read)))
                & " na tab_vdd: "
                & integer'image(to_integer(unsigned(tab_vdd(i).data_read)));

                assert data_write = tab_vdd(i).data_write report "Erro data_write: "
                & integer'image(to_integer(unsigned(data_write)))
                & " na tab_vdd: "
                & integer'image(to_integer(unsigned(tab_vdd(i).data_write)));

                assert data_addr = tab_vdd(i).data_addr report "Erro data_addr: "
                & integer'image(to_integer(unsigned(data_addr)))
                & " na tab_vdd: "
                & integer'image(to_integer(unsigned(tab_vdd(i).data_addr)));

                assert data_in = tab_vdd(i).data_in report "Erro data_in: "
                & integer'image(to_integer(unsigned(data_in)))
                & " na tab_vdd: "
                & integer'image(to_integer(unsigned(tab_vdd(i).data_in)));

                assert codec_interrupt = tab_vdd(i).codec_interrupt report "Erro codec_interrupt: "
                & integer'image(to_integer(unsigned(codec_interrupt)))
                & " na tab_vdd: "
                & integer'image(to_integer(unsigned(tab_vdd(i).codec_interrupt)));
                
                assert codec_read = tab_vdd(i).codec_read report "Erro codec_read: "
                & integer'image(to_integer(unsigned(codec_read)))
                & " na tab_vdd: "
                & integer'image(to_integer(unsigned(tab_vdd(i).codec_read)));

                assert codec_write = tab_vdd(i).codec_write report "Erro codec_write: "
                & integer'image(to_integer(unsigned(codec_write)))
                & " na tab_vdd: "
                & integer'image(to_integer(unsigned(tab_vdd(i).codec_write)));

                assert codec_data_in = tab_vdd(i).codec_data_in report "Erro codec_data_in: "
                & integer'image(to_integer(unsigned(codec_data_in)))
                & " na tab_vdd: "
                & integer'image(to_integer(unsigned(tab_vdd(i).codec_data_in)));
            end loop;

            report "Fim dos testes";

            wait;
        end process check;
end hibrida ; -- hibrida