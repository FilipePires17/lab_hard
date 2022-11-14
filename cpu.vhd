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
        mem_data_in: out std_logic_vector(data_width-1 downto 0);
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
    signal ip, sp: natural := 0;
    signal opcode, imediate: std_logic_vector(3 downto 0) := "0000";
    variable aux: std_logic_vector(7 downto 0) := (others => '0') ;
begin

    --halt <= '0';
    instruction_addr <= std_logic_vector(to_unsigned(ip, addr_width));
    mem_data_read <= '0';
    mem_data_write <= '0';
    mem_data_addr <= "0000000000000000";
    mem_data_in <= "00000000000000000000000000000000";
    codec_interrupt <= '0';
    codec_read <= '0';
    codec_write <= '0';
    codec_data_in <= "00000000";

    process (clk)
    begin
        opcode <= instruction_in(7 downto 4);
        imediate <= instruction_in(3 downto 0);
        case opcode is
            when "0000" =>
                --halt
                --halt <= '1';
            when "0001" =>
                --in
                codec_write <= '1';
                codec_interrupt <= '1';
                mem_data_in <= codec_data_out;
                mem_data_write <= '1';
                wait on codec_valid;
                codec_write <= '0';
                codec_interrupt <= '0';
            when "0010" =>
                --out
                mem_data_write <= '1';
                codec_write <= '1';
                codec_interrupt <= '1';
                mem_data_in <= codec_data_out;
                wait on codec_valid;
                codec_write <= '0';
                codec_interrupt <= '0';
            when "0011" =>
                --puship
                mem_data_addr <= std_logic_vector(to_unsigned(sp, addr_width));
                mem_data_in <= std_logic_vector(to_unsigned(ip, addr_width));
                mem_data_write <= '1';
            when "0100" =>
                --push imm
                mem_data_addr <= std_logic_vector(to_unsigned(sp, addr_width));
                mem_data_in <= "0000" & instruction_in(3 downto 0);
                mem_data_write <= '1';
            when "0101" =>
                --drop
                mem_data_addr <= std_logic_vector(to_unsigned(sp, addr_width));
                mem_data_in <= "00000000";
                mem_data_write <= '1';
            when "0110" =>
                --DUP

            when "1000" =>
                --ADD
                mem_data_read <= '1';
                aux := std_logic_vector(signed(mem_data_out(31 downto 24)) + signed(mem_data_out(23 downto 16)), aux'length);
                
            when "1001" =>
                --SUB
                mem_data_read <= '1';
                aux := std_logic_vector(signed(mem_data_out(31 downto 24)) - signed(mem_data_out(23 downto 16)), aux'length);
            when "1010" =>
                --NAND
                aux := not (mem_data_out(31 downto 24) and mem_data_out(23 downto 16));
            when "1011" =>
                --SLT
                if mem_data_out(31 downto 24) < mem_data_out(23 downto 16) then
                    aux := "00000001";
                else
                    aux := "00000000";
                end if;
            when "1100" =>
                --SHL
                aux := mem_data_out(31 downto 24) sll to_integer(signed(mem_data_out(23 downto 16)));
            when "1101" =>
                --SHR
                aux := mem_data_out(31 downto 24) srl to_integer(signed(mem_data_out(23 downto 16)));
            when "1110" =>
                --JEQ
                if mem_data_out(31 downto 24) = mem_data_out(23 downto 16) then
                    ip <= ip + to_integer(signed(mem_data_out(15 downto 0)));
                else
                end if;
            when "1111" =>
                --JMP
                ip <= to_integer(signed(mem_data_out(31 downto 16)));
        end case;
    end process;
    
end architecture;