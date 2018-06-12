library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mux is
generic (m : integer :=8);-- where n is no of bits in inputs
 port (A,B :in std_logic_vector(m-1 downto 0);s :in std_logic;output:out std_logic_vector(m-1 downto 0));
end entity  mux;


architecture arch of mux is 
begin
with s select 

output <=A when '0',
         B when others; 
end architecture;