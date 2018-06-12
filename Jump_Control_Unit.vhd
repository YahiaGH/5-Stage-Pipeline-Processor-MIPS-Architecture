library ieee;
use ieee.std_logic_1164.all;

entity Jump_Control_Unit is port(
Func:           in std_logic_vector (2 downto 0);
Jmp_Signal:     in std_logic;
Flag_Registers: in std_logic_vector (3 downto 0); --(carry,,zero,neg,overflow)
Jmp_Approval:   out std_logic                   --SAMY carry,overflow,sign,zero
); 
end entity Jump_Control_Unit;

architecture Jump_Control_Unit_Arch of Jump_Control_Unit is 
begin

process(Func,Jmp_Signal,Flag_Registers)
begin
Jmp_Approval <= '0';
if (Jmp_Signal = '1') then
	if    (Func="100" and Flag_Registers(0)='1') then --JZ
		Jmp_Approval <= '1';
	elsif (Func="101" and Flag_Registers(1)='1') then --JN
		Jmp_Approval <= '1';
	elsif (Func="110" and Flag_Registers(3)='1') then --JC
		Jmp_Approval <= '1';
	elsif (Func="111")                           then --JMP
		Jmp_Approval <= '1';
	end if;
end if;

end process;

end Jump_Control_Unit_Arch;