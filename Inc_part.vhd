library ieee;
use  ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
entity Inc_part is 
port(A :in std_logic_vector(15 downto 0);B :in std_logic_vector(15 downto 0); S : in std_logic_vector(1 downto 0);
cout,overflow:out std_logic; Output_fin :out std_logic_vector (15 downto 0));
end entity Inc_part;


architecture Dimplement of Inc_part is

  component my_nadder IS
Generic (n : integer := 8);
PORT    (a, b : in std_logic_vector(n-1 downto 0) ;
	cin : in std_logic;
	s : out std_logic_vector(n-1 downto 0);
	cout : out std_logic);
END component my_nadder;

signal input1,input2,aux,output :std_logic_vector (15 downto 0);
signal tempcout,lastcout :std_logic; 
signal zero :std_logic;
begin
  zero <= '0';
 
   
  input1 <= B ;
             
  
  with s select 
  
  input2 <=    x"0000" when "00",
               x"0000" when "01",
               x"0001" when  "10",
               x"ffff" when others;
            --  not B when "10",
             -- X"ffff" when others;
              
  Adder16 : my_nadder generic map (n => 16) port map(input1,input2,zero,aux,tempcout);
    
   
    with s  select
    output <= not B when "00",
                 -B   when "01",
                  aux when "10",
                  aux  when "11",
                  x"0000" when others;

    with s select 
   cout<=     tempcout when "10",
              not tempcout when "11",
              '0' when others; 
  -- with B & s select
     -- cout <= '0' when "000000000000000011", 
            --   lastcout when others; -- this one works as a last level mux
             
with s select 
overflow <= output(15) xor b(15)    when  "10", -- inc
            output(15) xor b(15)    when  "11", --dec
           '0' when others;  
  output_fin<=output;
end architecture Dimplement;

