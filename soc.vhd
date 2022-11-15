library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity soc is
    generic (
        firmware_filename: string := "firmware.txt"
    );
    port (
        clock: in std_logic;
        started: in std_logic
    );
end entity;

architecture hw of soc is
   
    constant addr_width: natural := 16;
    constant data_width: natural := 8;
    signal halt : std_logic := '0';
    signal imem_read, imem_write, mem_data_read, mem_data_write, codec_interrupt, codec_read, codec_write, codec_valid: std_logic := '0';
    signal instruction_in : std_logic_vector(data_width-1 downto 0) := (others => '0');
    signal instruction_addr, mem_data_addr, addr_aux : std_logic_vector(addr_width-1 downto 0) := (others => '0');
    signal mem_data_in, imem_in : std_logic_vector((data_width*2)-1 downto 0) := (others => '0');
    signal mem_data_out,auxv : std_logic_vector((data_width*4)-1 downto 0) := (others => '0');
    signal codec_data_out, codec_data_in : std_logic_vector(7 downto 0) := (others => '0');

begin

    i9: entity work.cpu(clean)
        generic map(addr_width,data_width)
        port map(clock,halt,auxv(31 downto 24),instruction_addr,mem_data_read,mem_data_write,mem_data_addr,mem_data_in,mem_data_out,codec_interrupt,codec_read,codec_write,codec_valid,codec_data_out,codec_data_in);

    imem: entity work.mem(comportamental)
        generic map(addr_width,data_width)
        port map(clock,imem_read,imem_write,addr_aux,imem_in,auxv);
   
    dmem: entity work.mem(comportamental)
        generic map(addr_width,data_width)
        port map(clock,mem_data_read,mem_data_write,mem_data_addr,mem_data_in,mem_data_out);

    io_codec: entity work.codec(io_sim)
        port map(codec_interrupt,codec_read,codec_write,codec_valid,codec_data_in,codec_data_out);

    process (clock)
        file arq : text open read_mode is firmware_filename;
        variable text_line: line;
        variable auxiliar: bit_vector(7 downto 0);
        variable endereco: std_logic_vector(addr_width-1 downto 0) := (others => '0');
        variable endereco2: std_logic_vector(addr_width-1 downto 0) := (others => '0');

    begin
        if started = '0' then
            halt <= '0';
            if falling_edge(clock) then
                readline(arq,text_line);
                read(text_line,auxiliar);
                imem_read <= '0';
                imem_write <= '1';
                addr_aux <= endereco;
                imem_in(15 downto 0) <= to_stdlogicvector(auxiliar) & "00000000";
                wait for 1 ns;
                endereco := std_logic_vector(unsigned(endereco) + 1);
            end if;
        else
            halt <= '1';
            addr_aux <= instruction_addr;
        end if;
    end process;
end architecture;