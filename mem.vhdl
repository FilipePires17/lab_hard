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
        data_out: out std_logic_vector((data_width*4)-1 downto 0)
    );
end entity;