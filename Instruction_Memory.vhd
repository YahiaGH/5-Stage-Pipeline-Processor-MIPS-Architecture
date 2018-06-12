
Library ieee;
Use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.numeric_std.all;

entity Instruction_Memory is 
port
( AddressValue : in std_logic_vector(9 downto 0); Instruction_Bits : out std_logic_vector(31 downto 0) );
end entity;


Architecture Instruction_Memory_imp of Instruction_Memory is

type Memory_type is array(0 to 1023) of std_logic_vector(15 downto 0);
 -- WORD = 2 Bytes (16-Bits) with max 10-bits >> 1KB Address Space
signal Inst_Memory : Memory_type;

begin
Process (AddressValue)
variable temp_MSB : std_logic_vector(15 downto 0);
begin


if  (AddressValue = "1111111111") then
temp_MSB :=  "0000000000000000" ;
else
temp_MSB := Inst_Memory(to_integer(unsigned(AddressValue)+ 1));
end if;
Instruction_Bits <= temp_MSB & Inst_Memory(to_integer(unsigned(AddressValue)));

end process;
end Instruction_Memory_imp;