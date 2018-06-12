
library ieee;
use  ieee.std_logic_1164.all;
entity decoder is port(S :in std_logic_vector(2 downto 0);Enable :in std_logic;output :out std_logic_vector(7 downto 0));
end entity decoder;

architecture decoderImp of decoder is 
signal temp:std_logic_vector(3 downto 0);
begin
 temp<=Enable&S;
 with temp select
 output <= "10000000" when "1000",
           "01000000" when "1001",
           "00100000" when "1010",
           "00010000" when "1011",
           "00001000" when "1100",
           "00000100" when "1101",
           "00000010" when "1110",
           "00000001" when "1111",
           "00000000" when others;

end architecture decoderImp;