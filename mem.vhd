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
        data_out: out std_logic_vector(data_width-1 downto 0)
    );
end entity;
            
architecture comportamental of mem is

    type stack is array ((2**addr_width)-1 downto 0) of std_logic_vector(data_width-1 downto 0);
    
begin
    process (clock, data_read, data_write)
        variable memoria : stack := (others => "00000000");
    begin
        data_out <= "00000000";
        if data_read = '1' and data_write = '0' then
            data_out <= memoria(to_integer(unsigned(data_addr)));
        end if;

        if falling_edge(clock) and data_write = '1' and data_read = '0' then
            memoria(to_integer(unsigned(data_addr))) := data_in;
        end if;
    end process;

end architecture;