library ieee;
use ieee.std_logic_1164.all;

entity ALU_Control_Unit is port(
ALU_OP: in std_logic_vector (1 downto 0);
Func: in std_logic_vector (2 downto 0);
ALU_Control_Output: out std_logic_vector (3 downto 0)
); 
end entity ALU_Control_Unit;

architecture ALU_Control_Unit_Arch of ALU_Control_Unit is 
begin
process (ALU_OP,Func)
begin
if    (ALU_OP="00") then --No operation
	ALU_Control_Output<="0000";
elsif (ALU_OP="10") then --Pass first operand
	ALU_Control_Output<="0001";
elsif (ALU_OP="01") then
	if    (Func="000") then --RLC
		ALU_Control_Output<="0010";
	elsif (Func="001") then --RRC
		ALU_Control_Output<="0011";
	elsif (Func="010") then --NOT
		ALU_Control_Output<="0100";
	elsif (Func="011") then --NEG
		ALU_Control_Output<="0101";
	elsif (Func="100") then --INC
		ALU_Control_Output<="0110";
	elsif (Func="101") then --DEC
		ALU_Control_Output<="0111";
	end if;
elsif (ALU_OP="11") then 
	if    (Func="001") then --ADD
		ALU_Control_Output<="1000";
	elsif (Func="010") then --SUB
		ALU_Control_Output<="1001";
	elsif (Func="011") then --AND
		ALU_Control_Output<="1010";
	elsif (Func="100") then --OR
		ALU_Control_Output<="1011";
	elsif (Func="101") then --SHL
		ALU_Control_Output<="1100";
	elsif (Func="110") then --SHR
		ALU_Control_Output<="1101";
	end if;
end if;
end process;


end ALU_Control_Unit_Arch;
