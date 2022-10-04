library ieee;
use ieee.std_logic_1164.all;

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

    type stack is array ((2**16)-1 downto 0) of std_logic_vector(data_width-1 downto 0);
    
    begin
        
    process (clock)
        variable mem : stack;
    begin
        if data_read = '1' then
            data_out <= mem(data_addr);
        end if;

        if falling_edge(clock) and data_write = '1' then
            mem(data_addr) := data_in;
        end if;
    end process;

end architecture;