library ieee;
use ieee.std_logic_1164.all;
entity registerfile is 
  port(Port1_sel :in std_logic_vector( 2 downto 0);Port2_sel :in std_logic_vector( 2 downto 0);
    W_en : in std_logic;W_sel :in std_logic_vector(2 downto 0);
    write_value :in std_logic_vector(15 downto 0);
    clk,rst :in std_logic;Port1_data,Port2_data,f0,f1,f2,f3,f4,f5 :out std_logic_vector(15 downto 0));
  end entity registerfile;
  architecture R_f of registerfile is 
  
  component my_nDFFs
  is Generic ( n : integer := 16);
  port( Clk,Rst,enable: in std_logic; d : in std_logic_vector(n-1 downto 0); q : out std_logic_vector(n-1 downto 0));
   end component my_nDFFs;

component decoder is port(S :in std_logic_vector(2 downto 0);Enable :in std_logic;output :out std_logic_vector(7 downto 0));
end component decoder;

component mux8x1 is port (A1,A2,A3,A4,A5,A6,A7,A8 : in std_logic_vector(15 downto 0);
s:in std_logic_vector(2 downto 0);output :out std_logic_vector(15 downto 0)); 
end component mux8x1;


signal q1,q2,q3,q4,q5,q6,q7,q8: std_logic_vector(15 downto 0);
signal E1,E2,E3,E4,E5,E6,E7,E8 : std_logic;
signal enables :std_logic_vector(7 downto 0);

begin
  
 
  
  
  R1: my_ndffs generic map (n => 16) port map(clk,rst,E1,write_value,q1);
  R2: my_ndffs generic map (n => 16) port map(clk,rst,E2,write_value,q2);
  R3: my_ndffs generic map (n => 16) port map(clk,rst,E3,write_value,q3);
  R4: my_ndffs generic map (n => 16) port map(clk,rst,E4,write_value,q4);
  R5: my_ndffs generic map (n => 16) port map(clk,rst,E5,write_value,q5);
  R6: my_ndffs generic map (n => 16) port map(clk,rst,E6,write_value,q6);
  R7: my_ndffs generic map (n => 16) port map(clk,rst,E7,write_value,q7);
  R8: my_ndffs generic map (n => 16) port map(clk,rst,E8,write_value,q8);
  M1 : mux8x1 port map(q1,q2,q3,q4,q5,q6,q7,q8,port1_sel,port1_data);
  M2 : mux8x1 port map(q1,q2,q3,q4,q5,q6,q7,q8,port2_sel,port2_data);
  D : decoder port map(W_sel,W_en,enables);
  E1<=enables(7);
  E2<=enables(6);
  E3<=enables(5);
  E4<=enables(4);
  E5<=enables(3);
  E6<=enables(2);
  E7<=enables(1);
  E8<=enables(0);
  f0<=q1;
  f1<=q2;
  f2<=q3;
  f3<=q4;
  f4<=q5;
  f5<=q6;
    
  
   
  
  
  
  end architecture R_f;