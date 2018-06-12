library ieee;
use  ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity Decode_stage is port (int,Clk:in std_logic;Reset:in std_logic;InstructionBits :in std_logic_vector(31 downto 0);
MemWb_Wb:in std_logic;MemWb_RD:in std_logic_vector(2 downto 0);Write_value:in std_logic_vector(15 downto 0);Fisrt_operand,Second_Operand :out std_logic_vector(15 downto 0);
 Call : out std_logic ;
  CarrySetReset : out std_logic_vector(1 downto 0) ; Jump : out std_logic ; MemWrite : out std_logic ; MemRead : out std_logic ;  
  SpSelect : out std_logic ;  RetFlush : out std_logic ; AddressSelect : out std_logic ; MemSrc : out std_logic ;
  RegWrite : out std_logic ;  AluOp : out std_logic_vector(1 downto 0) ;  MemToReg : out std_logic ; 
  SpChanger : out std_logic_vector(1 downto 0) ; PortValue : out std_logic ; OutPortEnable : out std_logic;RD_Out :out std_logic_vector(2 downto 0);rti: out std_logic;f0,f1,f2,f3,f4,f5 :out std_logic_vector(15 downto 0));

end entity Decode_Stage;

-- note that this reset signal has nothing to do with reset instrction
architecture Decode_Stage_imp of Decode_Stage is

 component registerfile is 
  port(Port1_sel :in std_logic_vector( 2 downto 0);port2_sel :in std_logic_vector( 2 downto 0);
    W_en : in std_logic;W_sel :in std_logic_vector(2 downto 0);
    write_value :in std_logic_vector(15 downto 0);
    clk,rst :in std_logic;Port1_data,Port2_data,f0,f1,f2,f3,f4,f5 :out std_logic_vector(15 downto 0));
  end component registerfile;

component mux is
generic (m : integer :=8);-- where n is no of bits in inputs
 port (A,B :in std_logic_vector(m-1 downto 0);s :in std_logic;output:out std_logic_vector(m-1 downto 0));
end component;

component Control_Unit is 
port
( int:in std_logic;OpCode : in std_logic_vector(2 downto 0); FunctionCode : in std_logic_vector(2 downto 0); Call : out std_logic ;
  CarrySetReset : out std_logic_vector(1 downto 0) ; Jump : out std_logic ; MemWrite : out std_logic ; MemRead : out std_logic ;  
  SpSelect : out std_logic ;  RetFlush : out std_logic ; AddressSelect : out std_logic ; MemSrc : out std_logic ;
  RegWrite : out std_logic ;  AluOp : out std_logic_vector(1 downto 0) ;  MemToReg : out std_logic ; 
  SpChanger : out std_logic_vector(1 downto 0) ; PortValue : out std_logic ; OutPortEnable : out std_logic;ldd :out std_logic;rti: out std_logic );

-- MemToReg -- > For Write Back '0' for memory value and '1' for alu result value.
end component;
signal ldd:std_logic;
signal RD:std_logic_vector(2 downto 0);
begin
muxinstance:mux generic map(m=>3) port map(InstructionBits(9 downto 7),InstructionBits(12 downto 10),ldd,RD); 
RD_Out <= RD;
Register_file_instance: Registerfile port map(instructionbits(12 downto 10),RD,
MemWb_Wb,MemWb_RD,write_value,clk,reset,fisrt_operand,second_operand,f0,f1,f2,f3,f4,f5 );

Control_Unit_instance :Control_Unit port map(int,instructionbits(15 downto 13),instructionbits(6 downto 4),
Call , CarrySetReset , Jump , MemWrite, MemRead ,SpSelect,RetFlush , AddressSelect , MemSrc,RegWrite, AluOp ,MemToReg, 
  SpChanger , PortValue, OutPortEnable,ldd,rti );
end architecture Decode_Stage_imp;