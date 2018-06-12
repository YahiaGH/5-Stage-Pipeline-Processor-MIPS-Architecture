library ieee;
use  ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
-- let this part is for shifting therefore starts at s3s2=11
entity shift_part is 
port(A :in std_logic_vector(15 downto 0);B :in std_logic_vector(15 downto 0);
 S : in std_logic_vector(1 downto 0);shiftmagnitude :in std_logic_vector(3 downto 0);
 cout:out std_logic;Overflow_shift: out std_logic; Output :out std_logic_vector (15 downto 0));
end entity Shift_part;


architecture Cimplement of shift_part is
--signal OneOnRIght,oneOnleft,Shiftrightone,shiftleftone : std_logic_vector(15 downto 0);
--signal SRMask,SLMask :std_logic_vector (15 downto 0);
signal Shift_mag : std_logic_vector(3 downto 0);
signal CR,Cl :std_logic;
signal IsAllZero :std_logic_vector(3 downto 0);
signal temp_output :std_logic_vector(15 downto 0);
begin

--oneonright <= x"0001";
--oneonleft  <= x"8000";
--shiftrightone <= std_logic_vector( shift_right(unsigned(oneonleft),to_integer(unsigned(shift_mag))));
--shiftleftone <= std_logic_vector( shift_left(unsigned(oneonright),to_integer(unsigned(shift_mag))));
--SRMask <= A and shiftleftone;
--SLMask <= A and shiftrightone; -- now we have a signal haveing one 1 or all zeros
--CR <= '0' when SRmask= x"0000" else '1';
--CL <= '0' when SLmask= x"0000" else '1';
 CR <= A(to_integer(unsigned(shift_mag)-1));
 Cl <= A(to_integer(16-unsigned(shift_mag)));
 
IsAllzero <= "0001" when shiftmagnitude = "0000" else "0000";
Shift_mag <= std_logic_vector(unsigned(shiftmagnitude)+unsigned(isallzero));
  with S select 
  
  temp_output <= std_logic_vector( shift_left(unsigned(A),to_integer(unsigned(shift_mag)))) when "00",
            std_logic_vector( shift_right(unsigned(A),to_integer(unsigned(shift_mag)))) when "01" , 
            x"0000" when others; 
 


            
 with S select    
 
  Cout <=   CL when "00",
            CR when "01",
            '0' when others;
            

     
 
  overflow_shift  <=  A(15) xor temp_output(15);
                     
   output <= temp_output;
        
  
  end architecture Cimplement;
