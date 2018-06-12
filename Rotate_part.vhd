library ieee;
use  ieee.std_logic_1164.all;
entity rotate_part is 
port(A :in std_logic_vector(15 downto 0);B :in std_logic_vector(15 downto 0); S : in std_logic_vector(1 downto 0);
cin:in std_logic; cout,overflow:out std_logic;Output_fin :out std_logic_vector (15 downto 0));
end entity rotate_part;


architecture bimplement of rotate_part is
signal output:std_logic_vector(15 downto 0);
begin
  with S select 
  
  output <=   A when "01",
              B(14 downto 0) & cin when "10",
              cin &  B(15 downto 1)    when "11",
              x"0000"  when others;
  with s select     

      cout <= B(15) when "10",
              B(0) when "11",
              '0' when others;

  with s select     

      overflow <=      B(15) xor output(15) when "10", -- rlc
                       B(15) xor output(15) when "11",--rrc
                       '0' when others;

Output_fin<=output;
end architecture bimplement;

