library ieee;
use ieee.std_logic_1164.all;

entity mux8x1 is port (A1,A2,A3,A4,A5,A6,A7,A8 : in std_logic_vector(15 downto 0);
s:in std_logic_vector(2 downto 0);output :out std_logic_vector(15 downto 0)); 

end entity mux8x1;

architecture arch of mux8x1 is 
begin 
with s select 
  output <= A1 when "000",
            A2 when "001",
            A3 when "010",
            A4 when "011",
            A5 when "100",
            A6 when "101",
            A7 when "110",
            A8 when "111",
            x"ffff" when others;
           
 end architecture arch;