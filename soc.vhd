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

    imem: entity work.mem(comportamental);

    dmem: entity work.mem(comportamental);

    i9: entity work.cpu(clean);

    codec_io: entity work.codec(io_sim);

end architecture;