library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem is
    generic (
        addr_width: natural := 16;
        data_width: natural := 8
        );
    port (
        clock: in std_logic;
        
        data_read: in std_logic;
        data_write: in std_logic;
        data_addr: in std_logic_vector(addr_width-1 downto 0);
        data_in: in std_logic_vector(data_width-1 downto 0);
        data_out: out std_logic_vector((data_width*4)-1 downto 0)
    );
end entity;
            
architecture comportamental of mem is

    type stack is array ((2**addr_width)-1 downto 0) of std_logic_vector(data_width-1 downto 0);
    
begin
    process (clock, data_read, data_write)
        variable aux : integer := 0;
        constant zero_byte : std_logic_vector(data_width-1 downto 0) := (others => '0');
        variable memoria : stack := (others => zero_byte);
    begin
        data_out <=  zero_byte & zero_byte & zero_byte & zero_byte;
        if data_read = '1' and data_write = '0' then
            --for i in 3 to 0 loop
            --    aux := to_integer(signed(data_addr)) + i - 3;
            --    for j in data_width-1 downto 0 loop
            --        if aux < 0 then
            --            data_out(i*8 + j) <= '0';
            --        else
            --            data_out(i*8 + j) <= memoria(aux)(j);
            --        end if;
            --    end loop;
            --end loop;
            data_out((data_width*4)-1 downto (data_width*3)) <= memoria(to_integer(signed(data_addr)));
            if to_integer(signed(data_addr))-1 < 0 then
                data_out((data_width*3)-1 downto (data_width*2)) <= zero_byte;
            else
                data_out((data_width*3)-1 downto (data_width*2)) <= memoria(to_integer(signed(data_addr))-1);
            end if;
            if to_integer(signed(data_addr))-2 < 0 then
                data_out((data_width*2)-1 downto (data_width*1)) <= zero_byte;
            else
                data_out((data_width*2)-1 downto (data_width*1)) <= memoria(to_integer(signed(data_addr))-2);
            end if;
            if to_integer(signed(data_addr))-3 < 0 then
                data_out((data_width*1)-1 downto (data_width*0)) <= zero_byte;
            else
                data_out((data_width*1)-1 downto (data_width*0)) <= memoria(to_integer(signed(data_addr))-3);
            end if;
            
        end if;

        if falling_edge(clock) and data_write = '1' and data_read = '0' then
            memoria(to_integer(unsigned(data_addr))) := data_in;
        end if;
    end process;

end architecture;