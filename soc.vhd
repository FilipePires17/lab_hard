library ieee;
use ieee.std_logic_1164.all;

entity soc is
    generic (
        firmware_filename: string := "filename.bin"
    );
    port (
        clock   : in std_logic;
        started : in std_logic
    );
end entity;

architecture chip of soc is

begin

    imem: entity work.mem(comportamental)
        generic map
            (
                addr_width: natural := 16;
                data_width: natural := 8
                );
            port map(
                clock: in std_logic;
                
                data_read: in std_logic;
                data_write: in std_logic;
                data_addr: in std_logic_vector(addr_width-1 downto 0);
                data_in: in std_logic_vector((data_width*2)-1 downto 0);
                data_out: out std_logic_vector((data_width*4)-1 downto 0)
            );
    

    dmem: entity work.mem(comportamental)

    generic map
        (
            addr_width: natural := 16;
            data_width: natural := 8
            );
        port map(
            clock: in std_logic;
            
            data_read: in std_logic;
            data_write: in std_logic;
            data_addr: in std_logic_vector(addr_width-1 downto 0);
            data_in: in std_logic_vector((data_width*2)-1 downto 0);
            data_out: out std_logic_vector((data_width*4)-1 downto 0)
        );

    i9: entity work.cpu(clean)

        generic map (
            addr_width: natural := 16;
            data_width: natural := 8
        );
        port map (
            clk   : in std_logic;
            halt : in std_logic;

            instruction_in: in std_logic_vector(data_width-1 downto 0);
            instruction_addr: out std_logic_vector(addr_width-1 downto 0);

            mem_data_read: out std_logic;
            mem_data_write: out std_logic;
            mem_data_addr: out std_logic_vector(addr_width-1 downto 0);
            mem_data_in: out std_logic_vector(data_width-1 downto 0);
            mem_data_out: in std_logic_vector((data_width*4)-1 downto 0);

            codec_interrupt: out std_logic;
            codec_read: out std_logic;
            codec_write: out std_logic;
            codec_valid: in std_logic;

            codec_data_out: in std_logic_vector(7 downto 0);
            codec_data_in: out std_logic_vector(7 downto 0)
        );    

    codec_io: entity work.codec(io_sim)

        port map (
            interrupt : in std_logic;
            read_signal: in std_logic;
            write_signal: in std_logic;
            valid: out std_logic;

            codec_data_in: in std_logic_vector(7 downto 0);
            codec_data_out: out std_logic_vector(7 downto 0)
        );    

    process integracao(clock, started): 
        
        if(started = '1') then
            file arq_load_in: text open read_mode is "input.txt";
            variable text_line : line;
            variable aux : bit_vector(7 downto 0);
            if rising_edge(clock) then
                write(text_line, to_bitvector(codec_data_in));
                writeline(arq_load_out, text_line);
            end if;
            
            firmware_filename

            --instrucoes: component imem port map (clock, data_read, data_write, data_addr, data_in, data_out);

            --dados: component dmem port map (clock, data_read, data_write, data_addr, data_in, data_out);

            --pc: component i9 port map (clock, halt, instruction_in, instruction_addr, mem_data_read, mem_data_write, mem_data_addr, mem_data_in, mem_data_out, codec_interrupt, codec_read, codec_write, codec_valid, codec_data_out, codec_data_in);

            --codec_1: component codec_io port map (clock, interrupt, read_signal, write_signal, valid, codec_data_in, codec_data_out);



end architecture;
