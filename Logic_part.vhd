Library ieee;
Use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.numeric_std.all;
 
 entity logic_part is port(A :in std_logic_vector(15 downto 0);
			    B :in std_logic_vector(15 downto 0); 
			    S : in std_logic_vector(1 downto 0); 
			    cout,overflow:out std_logic; 
			    Output_fin :out std_logic_vector (15 downto 0));
end entity logic_part;


architecture Aimplement of logic_part is
  
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
signal temp:std_logic_vector (17 downto 0);
begin
  zero <= '0';
 
   
  input1 <= A ;
             
  
  with s select 
  
  input2 <=    B when "00",
              -B when "01",
               x"0000" when others;
            --  not B when "10",
             -- X"ffff" when others;
              
  Adder16 : my_nadder generic map (n => 16) port map(input1,input2,zero,aux,tempcout);
    
   
    with s  select
    output <= aux when "00",
              aux when "01",
              A and B when "10",
              A or B  when "11",
              x"0000" when others;

    with s select 
   lastcout<=     tempcout when "00",
              not tempcout when "01",
              '0' when others; 
   temp<=B & s;
   with temp select
      cout <= '0' when "000000000000000001", 
               lastcout when others; -- this one works as a last level mux

with s select 
overflow <=       (not A(15) and not B(15) and output(15)) or (A(15) and B(15) and not output(15)) when "00", -- add
                  (A(15) and not b(15) and not output(15)) or (not A(15) and  b(15) and  output(15)) when "01", -- sub
                  '0' when others;

output_fin<= output;

  end architecture aimplement; 

            
  
  
  
  
