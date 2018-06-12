library ieee;
use ieee.std_logic_1164.all;

entity Hazard_Detection_Unit is port(
RS_Approval,RD_Approval: in std_logic;
IDEX_MemRead:            in std_logic;
IDEX_RD:                 in std_logic_vector (2 downto 0);
IFID_RS:                 in std_logic_vector (2 downto 0);
IFID_RD:                 in std_logic_vector (2 downto 0);
PC_Write:                out std_logic;
IFID_Enable:             out std_logic;
ldm:                     in std_logic
); 
end entity Hazard_Detection_Unit;

architecture Hazard_Detection_Unit_Arch of Hazard_Detection_Unit is 
begin

Process (RS_Approval,RD_Approval,IDEX_MemRead,IDEX_RD,IFID_RS,IFID_RD,ldm)
begin

if ( IDEX_MemRead='1' or ldm='1') then
	if ( ( IDEX_RD = IFID_RS and RS_Approval='1' ) or (IDEX_RD = IFID_RD and RD_Approval='1' ) ) then
		PC_Write    <= '0';
		IFID_Enable <= '0';
	else
		PC_Write    <= '1';
		IFID_Enable <= '1';
	end if;	

else
	PC_Write    <= '1';
	IFID_Enable <= '1';
end if;	

end process;

end Hazard_Detection_Unit_Arch; 
