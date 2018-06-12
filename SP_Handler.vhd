library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;   
Entity SPhandler is 	
port ( 
	SPselect,AddressSelect : in std_logic; 
	SPchanger : in std_logic_vector(1 downto 0); 
	SP: in std_logic_vector(15 downto 0);
	EffectiveAddress : in std_logic_vector(9 downto 0); 	
	NewSP: out std_logic_vector(15 downto 0);
	Address: out std_logic_vector(9 downto 0)); 
end entity SPhandler;

architecture SPhandler_arch of SPhandler is 

component my_nadder IS
Generic (n : integer := 8);
PORT    (a, b : in std_logic_vector(n-1 downto 0) ;
	cin : in std_logic;
	s : out std_logic_vector(n-1 downto 0);
	cout : out std_logic);
END component;

signal tempaddress: std_logic_vector(9 downto 0);
signal CarryIn,co: std_logic; 
signal adderinput,updatedSP:std_logic_vector(15 downto 0);

begin 
	adder1: my_nadder generic map(n=>16) port map (SP,adderinput,CarryIn,updatedSP,co);

	process(SPchanger,SP) is 
	begin 	
		if(SPchanger="00") then
			CarryIn<='0';
			adderinput<= "0000000000000000";
		elsif(SPchanger="01") then
			if(SP="0000000000000000") then
				adderinput<="0000001111111111";
				CarryIn<='0';
			else
				CarryIn<='0';
				adderinput<= "1111111111111111";
			end if;
		else
			if(SP="0000001111111111") then
				adderinput<=not SP;
				CarryIn<='1';
			else
				CarryIn<='1';
				adderinput<= "0000000000000000";
			end if;
		end if;
	end process;
	NewSP<=updatedSP;
	tempaddress<= SP(9 downto 0) when SPselect='0' else
		      updatedSP(9 downto 0);
	Address<= tempaddress when AddressSelect='0' else
		  EffectiveAddress;
		   
	
end architecture SPhandler_arch;
