library ieee;
use ieee.std_logic_1164.all;

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

        data_read: out std_logic;
        data_write: out std_logic;
        data_addr: out std_logic_vector(addr_width-1 downto 0);
        data_in: out std_logic_vector((data_width*4)-1 downto 0);
        data_out: in std_logic_vector(data_width-1 downto 0);

        codec_interrupt: out std_logic;
        codec_read: out std_logic;
        codec_write: out std_logic;
        codec_valid: in std_logic;

        codec_data_out: in std_logic_vector(7 downto 0);
        codec_data_in: out std_logic_vector(7 downto 0)
    );
end entity;