library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;   
Entity MemoryStage is 	
port ( 
	clk,SPselect,AddressSelect,interrupt,memsrc,memwrite : in std_logic; 
	SPchanger : in std_logic_vector(1 downto 0); 
	EA: in std_logic_vector(9 downto 0);
	aluoutput,previouspc,nextpc: in std_logic_vector(15 downto 0); 	
	memvalue,M0,M1: out std_logic_vector(15 downto 0);
	rst:in std_logic;Spp:out std_logic_vector(15 downto 0)); 
end entity MemoryStage;

architecture MemoryStage_arch of MemoryStage is 

component my_SP is
Generic ( n : integer := 16);
port( Clk,Rst : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end component;

component SPhandler is 	
port ( 
	SPselect,AddressSelect : in std_logic; 
	SPchanger : in std_logic_vector(1 downto 0); 
	SP: in std_logic_vector(15 downto 0);
	EffectiveAddress : in std_logic_vector(9 downto 0); 	
	NewSP: out std_logic_vector(15 downto 0);
	Address: out std_logic_vector(9 downto 0)); 
end component;

component DataMemory is 	
port ( 
	clk : in std_logic; 
	memwrite : in std_logic; 
	address : in std_logic_vector(9 downto 0); 	
	writevalue : in std_logic_vector(15 downto 0);
	M0: out std_logic_vector(15 downto 0);
	M1: out std_logic_vector(15 downto 0); 
	dataout : out std_logic_vector(15 downto 0) ); 
end component;

signal address1: std_logic_vector(9 downto 0);
signal tempRst: std_logic := '1'; 
signal currentSP,newSP,tempvalue:std_logic_vector(15 downto 0);
signal selector:std_logic_vector(1 downto 0);

begin 
	SP:my_SP port map(clk,tempRst,newSP,currentSP);
	SPunit: SPhandler port map(SPselect,AddressSelect,SPchanger,currentSP,EA,newSP,address1);	
	Memory:DataMemory port map(clk,memwrite,address1,tempvalue,M0,M1,memvalue);   
	tempRst<= '1' when currentSP="XXXXXXXXXXXXXXXX" else
      	          rst;
	selector<= interrupt&memsrc;
	tempvalue<= aluoutput when selector="00" else
		    previouspc when selector="01" else
		    nextpc;
	Spp<=currentSp;
end architecture MemoryStage_arch;
