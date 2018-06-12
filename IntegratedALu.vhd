library ieee;
use  ieee.std_logic_1164.all;
entity ALU is 
port(A :in std_logic_vector (15 downto 0);b :in std_logic_vector (15 downto 0);S : in std_logic_vector (3 downto 0);
cin,Overflow_in,sign_in,zero_in : in std_logic ;Shift_magnitude: in std_logic_vector(3 downto 0); F :out std_logic_vector (15 downto 0); CarryFlag,OverFlowFlag,SignFlag,ZeroFlag :out std_logic);
end entity ALU;


architecture ALU_ARCH of ALU is 

signal Inc_partout,Logic_partout,rotate_partout,Shift_partout,output: std_logic_vector(15 downto 0);
signal c1,c2,c3,c4 :std_logic;
signal TempOverflow,overflow1,overflow2,overflow3,overflow4 :std_logic;
component rotate_part is 
port(A :in std_logic_vector(15 downto 0);B :in std_logic_vector(15 downto 0); S : in std_logic_vector(1 downto 0);
cin:in std_logic; cout,overflow:out std_logic;Output_fin :out std_logic_vector (15 downto 0));
end component rotate_part;

component Inc_part is 
port(A :in std_logic_vector(15 downto 0);B :in std_logic_vector(15 downto 0); S : in std_logic_vector(1 downto 0);
cout,overflow:out std_logic; Output_fin :out std_logic_vector (15 downto 0));
end component Inc_part;


component shift_part is 
port(A :in std_logic_vector(15 downto 0);B :in std_logic_vector(15 downto 0);
 S : in std_logic_vector(1 downto 0);shiftmagnitude :in std_logic_vector(3 downto 0);
 cout:out std_logic;Overflow_shift: out std_logic; Output :out std_logic_vector (15 downto 0));
end component Shift_part;


component logic_part is port(A :in std_logic_vector(15 downto 0);B :in std_logic_vector(15 downto 0); S : in std_logic_vector(1 downto 0); cout,overflow:out std_logic; Output_fin :out std_logic_vector (15 downto 0));
end component logic_part;

component genmux4x1 is
generic (n : integer :=8);-- where n is no of bits in inputs
 port (A,B,c,d :in std_logic_vector(n-1 downto 0);s :in std_logic_vector(1 downto 0);output:out std_logic_vector(n-1 downto 0));
end component genmux4x1;


begin 

  P1 : Rotate_part port map (A,B,S(1 downto 0),cin,C1,overflow1,Inc_partout);
  P2 : Inc_part port map (A,B,S(1 downto 0),C2,overflow2,rotate_partout);
  P3 : Logic_part port map (A,B,S(1 downto 0),C3,overflow3,logic_partout);
  P4 : shift_part port map (A,B,S(1 downto 0),Shift_magnitude,C4,overflow4,shift_partout);
    
  F <= output;

  Mux : genmux4x1 generic map(n=>16) port map(Inc_partout,rotate_partout,logic_partout,shift_partout,s(3 downto 2),output);
    
    with s select 
    
    carryflag <= c1 when "0010", 
                 c1 when "0011",      
                 c2 when "0110",
                 c2 when "0111",
                 c3 when "1000",
                 c3 when "1001",
                 c4 when "1100",
                 c4 when "1101",
                 cin when others;
--with s(3 downto 2) select 
    
--    carryflag <= c1 when "00",
--            c2 when "01",
--            c3 when "10",
--            c4 when "11",
--            '0' when others;

   with s select
   signflag <= sign_in when "0000",
               sign_in when "0001",
              output(15) when others;

   with s select
   zeroflag <= zero_in when "0000",
               zero_in when "0001",
       not(output(15) or output(14) or output(13) or output(12) or output(11) or output(10) or output(9) or 
   output(8) or output(7) or output(6) or output(5) or output(4) or output(3) or output(2) or output(1) or  output(0)) when others;  

-- overflow flag appears only in specific operations like add,sub 

 with s select 
  overflowflag <= overflow1 when "0010",--rlc
                  overflow1 when "0011",--rcr
                  overflow2 when "0110", --inc
                  overflow2 when "0111",--dec  
                  overflow3 when "1000",--add
                  overflow3 when "1001",--sub
                  overflow4 when "1100",--shl
                  overflow4 when "1101",--shr
                  overflow_in when others;
    
  end architecture ALU_ARCH ;       
            

