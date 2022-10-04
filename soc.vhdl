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