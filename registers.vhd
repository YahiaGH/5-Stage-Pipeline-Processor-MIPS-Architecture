library ieee;
use ieee.std_logic_1164.all;
entity my_nDFFs
 is Generic ( n : integer := 16);
  port( Clk,Rst,enable: in std_logic; d : in std_logic_vector(n-1 downto 0); q : out std_logic_vector(n-1 downto 0));
   end my_nDFFs;
 Architecture a_my_nDFFs of my_nDFFs is
 begin 
 Process (Clk,Rst)
  begin 
  if Rst = '1' 
  then q <= (others=>'0');
   elsif falling_edge(Clk) and enable='1'
    then q <= d;
 end if;
 end process;
 end a_my_nDFFs;

