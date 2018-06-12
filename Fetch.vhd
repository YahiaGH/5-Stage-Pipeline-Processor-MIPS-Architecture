Library ieee;
Use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.numeric_std.all;



entity Fetch_Stage is port (CLK,rst : in std_logic;InstructionBits :out std_logic_vector(31 downto 0)  ; PcWrite : in std_logic ; 
  JumpCallControlSig : in std_logic  ; Interrupt : in std_logic  ;  RetFlushSig : in std_logic  ; Reset : in std_logic  ;
  Memory0 : in std_logic_vector(15 downto 0); Memory1 : in std_logic_vector(15 downto 0); AluValue : in std_logic_vector(15 downto 0); 
  DataMemoryValue : in std_logic_vector(15 downto 0); 
  PC_Next_Inst : out std_logic_vector(15 downto 0); 
  Double_Sized_Inst_flag : out std_logic; 
  PC : out std_logic_vector(9 downto 0) );
end entity ;



architecture Fetch_stage_imp of Fetch_Stage is

component PC_Unit is 
port
( CLK,rst : in std_logic ; CountEnable : in std_logic ; OpCodeCheck : in std_logic_vector(2 downto 0) ; 
  JumpCallControlSig : in std_logic  ; Interrupt : in std_logic  ;  RetFlushSig : in std_logic  ; Reset : in std_logic  ;
  Memory0 : in std_logic_vector(15 downto 0); Memory1 : in std_logic_vector(15 downto 0); AluValue : in std_logic_vector(15 downto 0); 
  DataMemoryValue : in std_logic_vector(15 downto 0); 
  AddressValue : out std_logic_vector(9 downto 0); PC_Next_Inst : out std_logic_vector(15 downto 0); 
  Double_Sized_Inst : out std_logic );
end component;

component Instruction_Memory is 
port
( AddressValue : in std_logic_vector(9 downto 0); Instruction_Bits : out std_logic_vector(31 downto 0) );
end component;


signal PcQ :std_logic_vector(9 downto 0);
signal Instruction_out : std_logic_vector(31 downto 0);
begin

Pc_Unit_instance : pc_unit port map(clk,rst,pcwrite,Instruction_out(15 downto 13),JumpCallControlSig,Interrupt, RetFlushSig,Reset,
Memory0,Memory1,AluValue , DataMemoryValue,PcQ,Pc_next_inst,Double_Sized_Inst_flag);

Instruction_memory_instance :Instruction_Memory port map(pcQ,Instruction_out);

InstructionBits <= Instruction_out;
pc<=pcq;

end architecture Fetch_stage_imp;






 