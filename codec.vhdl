library ieee;
use ieee.std_logic_1164.all;

entity codec is
    port (
        clk   : in std_logic;
        
        interrupt : in std_logic;
        read_signal: in std_logic;
        write_signal: in std_logic;
        valid: out std_logic;

        codec_data_in: in std_logic_vector(7 downto 0);
        codec_data_out: out std_logic_vector(7 downto 0)
    );
end entity;