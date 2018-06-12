Library ieee;
Use ieee.std_logic_1164.all;

Entity PC is
port( Clk,Reset,CountEnable : in std_logic;
DataIN : in std_logic_vector(15 downto 0);
CountOut : out std_logic_vector(15 downto 0));
end PC;

Architecture PC_imp of PC is
begin
Process (Clk,Reset)
begin 
if (Reset = '1') then
 	CountOut <= "0000000000000000";
elsif rising_edge(Clk) then

	if CountEnable = '1' then
		if(DataIN >= "0000010000000000") then
		CountOut <= "0000000000000000";
		else 
		CountOut <= DataIN;
		end if;
	end if;
end if;

end process;
end PC_imp;
