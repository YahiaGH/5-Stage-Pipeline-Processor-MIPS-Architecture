

Library ieee;
Use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.numeric_std.all;

entity Forward_Unit is 
port
( ExecMem_RegWrite : in std_logic ; MemWB_RegWrite : in std_logic ; ID_EX_RS : in std_logic_vector(2 downto 0); 
  ID_EX_RD : in std_logic_vector(2 downto 0); ExecMem_RD : in std_logic_vector(2 downto 0);
  MemWB_RD : in std_logic_vector(2 downto 0);
  Forward_A : out std_logic_vector(1 downto 0); Forward_B : out std_logic_vector(1 downto 0) );
end entity;


Architecture Forward_Unit_imp of Forward_Unit is
begin

Process (ExecMem_RegWrite,MemWB_RegWrite,ID_EX_RS,ID_EX_RD,ExecMem_RD,MemWB_RD)
begin

Forward_A <="00";
Forward_B <="00";

		if(ExecMem_RegWrite = '1') then

			if (ID_EX_RS = ExecMem_RD) then
				Forward_A <="01";
			end if;	
			if (ID_EX_RD = ExecMem_RD) then
				Forward_B <="01";	
			end if;
		end if;	
		if(MemWB_RegWrite = '1') then

		        if (ID_EX_RS = MemWB_RD and (ID_EX_RS /= ExecMem_RD or ExecMem_RegWrite /= '1')) then
				Forward_A <="10";
			end if;	
			if (ID_EX_RD = MemWB_RD and (ID_EX_RD /= ExecMem_RD or ExecMem_RegWrite /= '1')) then
				Forward_B <="10";	
			end if;
			
		end if;
end process;
end Forward_Unit_imp;