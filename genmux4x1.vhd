library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity genmux4x1 is
generic (n : integer :=8);-- where n is no of bits in inputs
 port (A,B,c,d :in std_logic_vector(n-1 downto 0);s :in std_logic_vector(1 downto 0);output:out std_logic_vector(n-1 downto 0));
end entity genmux4x1;


architecture arch of genmux4x1 is 
begin
with s select 

output <=A when "00",
         B when "01",
         c when "10",
         d when others; 
end architecture;
