library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
    generic (
        addr_width: natural := 16;
        data_width: natural := 8
    );
    port (
        clk   : in std_logic;
        halt : in std_logic;

        instruction_in: in std_logic_vector(data_width-1 downto 0);
        instruction_addr: out std_logic_vector(addr_width-1 downto 0);

        mem_data_read: out std_logic;
        mem_data_write: out std_logic;
        mem_data_addr: out std_logic_vector(addr_width-1 downto 0);
        mem_data_in: out std_logic_vector((data_width*2)-1 downto 0);
        mem_data_out: in std_logic_vector((data_width*4)-1 downto 0);

        codec_interrupt: out std_logic;
        codec_read: out std_logic;
        codec_write: out std_logic;
        codec_valid: in std_logic;

        codec_data_out: in std_logic_vector(7 downto 0);
        codec_data_in: out std_logic_vector(7 downto 0)
    );
end entity;

architecture clean of cpu is
    signal opcode, imediate: std_logic_vector(3 downto 0) := "0000";
    signal flag : std_logic := '0';
begin

    instruction_addr <= std_logic_vector(to_unsigned(0, addr_width));
    mem_data_read <= '0';
    mem_data_write <= '0';
    mem_data_addr <= "0000000000000000";
    mem_data_in <= "0000000000000000";
    codec_interrupt <= '0';
    codec_read <= '0';
    codec_write <= '0';
    codec_data_in <= "00000000";

    process 
        variable ip, sp: natural := 0;
        variable auxv: std_logic_vector(7 downto 0) := (others => '0');
        variable auxi: integer := 0;
        variable drop_dup: std_logic_vector(7 downto 0) := (others => '0');
    begin
        if rising_edge(halt) then
            flag <= '1';
        end if;
        if flag = '0' then
            instruction_addr <= std_logic_vector(to_unsigned(0, addr_width));
            mem_data_read <= '0';
            mem_data_write <= '0';
            mem_data_addr <= "0000000000000000";
            mem_data_in <= "0000000000000000";
            codec_interrupt <= '0';
            codec_read <= '0';
            codec_write <= '0';
            codec_data_in <= "00000000";
        else
            opcode <= instruction_in(7 downto 4);
            imediate <= instruction_in(3 downto 0);
            codec_read <= '0';
            codec_write <= '0';
            codec_interrupt <= '0';
            mem_data_read <= '0';
            mem_data_write <= '0';
            mem_data_addr <= std_logic_vector(to_unsigned(sp,addr_width));
            if rising_edge(clk) then
                if opcode = "0000" then
                    --halt
                    flag <= '0';

                elsif opcode = "0001" then
                    --in
                    codec_write <= '1';
                    codec_interrupt <= '1';
                    wait on codec_valid;
                    mem_data_in <= "00000000" & codec_data_out;
                    mem_data_write <= '1';
                    sp := sp + 1;

                elsif opcode = "0010" then
                    --out
                    mem_data_read <= '1';
                    codec_data_in <= mem_data_out;
                    codec_read <= '1';
                    codec_interrupt <= '1';
                    wait on codec_valid;
                    sp := sp - 1;

                elsif opcode = "0011" then
                    --puship
                    mem_data_in <= std_logic_vector(to_unsigned(ip, addr_width));
                    mem_data_write <= '1';
                    sp := sp + 2;

                elsif opcode = "0100" then
                    --push imm
                    mem_data_in <= "000000000000" & instruction_in(3 downto 0);
                    mem_data_write <= '1';
                    sp := sp + 1;

                elsif opcode = "0101" then
                    --drop
                    mem_data_read <= '1';
                    drop_dup := mem_data_out(7 downto 0);
                    sp := sp - 1;

                elsif opcode = "0110" then
                    --DUP
                    mem_data_in <= "00000000" & drop_dup;
                    mem_data_write <= '1';
                    sp := sp + 1;

                elsif opcode = "1000" then
                    --ADD
                    mem_data_read <= '1';
                    auxi := to_integer(signed(mem_data_out(31 downto 24))) + to_integer(signed(mem_data_out(23 downto 16)));
                    auxv := std_logic_vector(to_signed(auxi, auxv'length));
                    mem_data_in <= "00000000" & auxv;
                    mem_data_addr <= std_logic_vector(to_unsigned(sp-1,addr_width));
                    mem_data_write <= '1';
                    sp := sp - 1;

                elsif opcode = "1001" then
                    --SUB
                    mem_data_read <= '1';
                    auxi := to_integer(signed(mem_data_out(31 downto 24))) - to_integer(signed(mem_data_out(23 downto 16)));
                    auxv := std_logic_vector(to_signed(auxi, auxv'length));
                    mem_data_in <= "00000000" & auxv;
                    mem_data_addr <= std_logic_vector(to_unsigned(sp-1,addr_width));
                    mem_data_write <= '1';
                    sp := sp - 1;

                elsif opcode = "1010" then
                    --NAND
                    auxv := not (mem_data_out(31 downto 24) and mem_data_out(23 downto 16));
                    mem_data_in <= "00000000" & auxv;
                    mem_data_addr <= std_logic_vector(to_unsigned(sp-1,addr_width));
                    mem_data_write <= '1';
                    sp := sp - 1;

                elsif opcode = "1011" then
                    --SLT
                    if mem_data_out(31 downto 24) < mem_data_out(23 downto 16) then
                        auxv := "00000001";
                    else
                        auxv := "00000000";
                    end if;
                    mem_data_in <= "00000000" & auxv;
                    mem_data_addr <= std_logic_vector(to_unsigned(sp-1,addr_width));
                    mem_data_write <= '1';
                    sp := sp - 1;

                elsif opcode = "1100" then
                    --SHL
                    auxv := std_logic_vector(unsigned(mem_data_out(31 downto 24)) sll to_integer(signed(mem_data_out(23 downto 16))));
                    mem_data_in <= "00000000" & auxv;
                    mem_data_addr <= std_logic_vector(to_unsigned(sp-1,addr_width));
                    mem_data_write <= '1';
                    sp := sp - 1;

                elsif opcode = "1101" then
                    --SHR
                    auxv := std_logic_vector(unsigned(mem_data_out(31 downto 24)) srl to_integer(signed(mem_data_out(23 downto 16))));
                    mem_data_in <= "00000000" & auxv;
                    mem_data_addr <= std_logic_vector(to_unsigned(sp-1,addr_width));
                    mem_data_write <= '1';
                    sp := sp - 1;

                elsif opcode = "1110" then
                    --JEQ
                    if mem_data_out(31 downto 24) = mem_data_out(23 downto 16) then
                        ip := ip + to_integer(signed(mem_data_out(15 downto 0))) - 1;
                    else
                    end if;
                    sp := sp - 4;

                elsif opcode = "1111" then
                    --JMP
                    ip := to_integer(signed(mem_data_out(31 downto 16))) - 1;
                    sp := sp -2;
                end if;
            
                ip := ip + 1;
                instruction_addr <= std_logic_vector(to_unsigned(ip,addr_width));
                
            end if;
        end if;
        wait on clk;
    end process;
    
end architecture;