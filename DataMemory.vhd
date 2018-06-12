library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;   
Entity DataMemory is 	
port ( 
	clk : in std_logic; 
	memwrite : in std_logic; 
	address : in std_logic_vector(9 downto 0); 	
	writevalue : in std_logic_vector(15 downto 0);
	M0: out std_logic_vector(15 downto 0);
	M1: out std_logic_vector(15 downto 0); 
	dataout : out std_logic_vector(15 downto 0) ); 
end entity DataMemory;

architecture DataMemory_arch of DataMemory is 

type ram_type is array (0 to 1023) of std_logic_vector(15 downto 0);
signal ram : ram_type; 

begin 
	process(clk,ram) is 
	begin 	
		if rising_edge(clk) then    	
			if memwrite = '1' then 
				ram(to_integer(unsigned(address))) <= writevalue;    
			end if; 
		end if; 
	end process; 
	dataout <= ram(to_integer(unsigned(address))); 
	M0<=ram(0);
	M1<=ram(1);
end architecture DataMemory_arch;
