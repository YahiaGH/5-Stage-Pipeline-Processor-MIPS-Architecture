library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;   
Entity MicroProcessor is 	
port ( 
	clk,Preset,interrupt : in std_logic; 
	inputPort : in std_logic_vector(15 downto 0); 
	outputPort: out std_logic_vector(15 downto 0);
	AluOutput : out std_logic_vector(15 downto 0);
	MemoryOutput : out std_logic_vector(15 downto 0)); 
end entity MicroProcessor;

architecture MicroProcessor_arch of MicroProcessor is 

component Fetch_Stage is port (CLK,rst : in std_logic;InstructionBits :out std_logic_vector(31 downto 0)  ; PcWrite : in std_logic ; 
  JumpCallControlSig : in std_logic  ; Interrupt : in std_logic  ;  RetFlushSig : in std_logic  ; Reset : in std_logic  ;
  Memory0 : in std_logic_vector(15 downto 0); Memory1 : in std_logic_vector(15 downto 0); AluValue : in std_logic_vector(15 downto 0); 
  DataMemoryValue : in std_logic_vector(15 downto 0); 
  PC_Next_Inst : out std_logic_vector(15 downto 0); 
  Double_Sized_Inst_flag : out std_logic ; 
  PC : out std_logic_vector(9 downto 0));
end component ;

component Decode_stage is port (int,Clk:in std_logic;Reset:in std_logic;InstructionBits :in std_logic_vector(31 downto 0);
MemWb_Wb:in std_logic;MemWb_RD:in std_logic_vector(2 downto 0);Write_value:in std_logic_vector(15 downto 0);Fisrt_operand,Second_Operand :out std_logic_vector(15 downto 0);
 Call : out std_logic ;
  CarrySetReset : out std_logic_vector(1 downto 0) ; Jump : out std_logic ; MemWrite : out std_logic ; MemRead : out std_logic ;  
  SpSelect : out std_logic ;  RetFlush : out std_logic ; AddressSelect : out std_logic ; MemSrc : out std_logic ;
  RegWrite : out std_logic ;  AluOp : out std_logic_vector(1 downto 0) ;  MemToReg : out std_logic ; 
  SpChanger : out std_logic_vector(1 downto 0) ; PortValue : out std_logic ; OutPortEnable : out std_logic;RD_Out :out std_logic_vector(2 downto 0);rti: out std_logic;f0,f1,f2,f3,f4,f5 :out std_logic_vector(15 downto 0));

end component;

component Excute_stage is port (clk,Reset,RTI,portValue,double_sized_flag :in std_logic;Immediate_value,Input_Port :in std_logic_vector(15 downto 0);
First_operand,Second_operand : in std_logic_vector(15 downto 0);Shift_magnitude,Alu_select:in std_logic_vector(3 downto 0);
EXMEM_Rd,MEMWB_RD : in std_logic_vector(15 downto 0); ForwardA,ForwardB :in std_logic_vector(1 downto 0);carry_in,Overflow_in,sign_in,zero_in  :in std_logic;Temp_CarryFlag,Temp_OverFlowFlag,Temp_SignFlag,temp_ZeroFlag:in std_logic;
Final_Carry_Flag,OverFlowFlag,SignFlag,ZeroFlag:out std_logic;
Alu_out,outp:out std_logic_vector(15 downto 0);carry_set_reset :std_logic_vector(1 downto 0));
end component;

component MemoryStage is 	
port ( 
	clk,SPselect,AddressSelect,interrupt,memsrc,memwrite : in std_logic; 
	SPchanger : in std_logic_vector(1 downto 0); 
	EA: in std_logic_vector(9 downto 0);
	aluoutput,previouspc,nextpc: in std_logic_vector(15 downto 0); 	
	memvalue,M0,M1: out std_logic_vector(15 downto 0);
	rst:in std_logic;Spp:out std_logic_vector(15 downto 0)); 
end component;

component genmux4x1 is
generic (n : integer :=8);-- where n is no of bits in inputs
 port (A,B,c,d :in std_logic_vector(n-1 downto 0);s :in std_logic_vector(1 downto 0);output:out std_logic_vector(n-1 downto 0));
end component;

component Jump_Control_Unit is port(
Func:           in std_logic_vector (2 downto 0);
Jmp_Signal:     in std_logic;
Flag_Registers: in std_logic_vector (3 downto 0); --(carry,,zero,neg,overflow)
Jmp_Approval:   out std_logic
); 
end component;

component Hazard_Detection_Unit is port(
RS_Approval,RD_Approval: in std_logic;
IDEX_MemRead:            in std_logic;
IDEX_RD:                 in std_logic_vector (2 downto 0);
IFID_RS:                 in std_logic_vector (2 downto 0);
IFID_RD:                 in std_logic_vector (2 downto 0);
PC_Write:                out std_logic;
IFID_Enable:             out std_logic;
ldm   :                   in std_logic
); 
end component;

component ALU_Control_Unit is port(
ALU_OP: in std_logic_vector (1 downto 0);
Func: in std_logic_vector (2 downto 0);
ALU_Control_Output: out std_logic_vector (3 downto 0)
); 
end component;

component mux is
generic (m : integer :=8);-- where n is no of bits in inputs
 port (A,B :in std_logic_vector(m-1 downto 0);s :in std_logic;output:out std_logic_vector(m-1 downto 0));
end component;

component Approval is port ( opcode : in std_logic_vector(2 downto 0);FnCode : in std_logic_vector(2 downto 0);
RSapprove,RDapprove :out std_logic);
end component;

component InterruptUnit is  port
	( FetchInterrupt,DecodeInterrupt,ExecuteInterrupt,jumper,retflush : in std_logic;
	  memPC: out std_logic;
          decodePC,executePC : out std_logic_vector(1 downto 0)); 
end component;

Component my_nDFF
 is Generic ( n : integer := 16);
  port( Clk,Rst,enable: in std_logic; d : in std_logic_vector(n-1 downto 0); q : out std_logic_vector(n-1 downto 0));
   end component;

component Forward_Unit is 
port
( ExecMem_RegWrite : in std_logic ; MemWB_RegWrite : in std_logic ; ID_EX_RS : in std_logic_vector(2 downto 0); 
  ID_EX_RD : in std_logic_vector(2 downto 0); ExecMem_RD : in std_logic_vector(2 downto 0);
  MemWB_RD : in std_logic_vector(2 downto 0);
  Forward_A : out std_logic_vector(1 downto 0); Forward_B : out std_logic_vector(1 downto 0) );
end component;

signal PC:std_logic_vector(9 downto 0);
signal flag,rst:std_logic:='1';
signal InstructionBits:std_logic_vector(31 downto 0);
signal reset,PcWrite,JumpCallControlSig,Jmp_Approval,memPC,RS_Approval,RD_Approval,IFID_Enable,IFflush,IDflush,Memflush,ldm,anyinterrupt,retsig,JumpCallControlSignal: std_logic; 
signal Memory0, Memory1,writeValue,outp,R0,R1,R2,R3,R4,R5,SP:std_logic_vector(15 downto 0);
signal decodePC,executePC,ForwardA,ForwardB:std_logic_vector(1 downto 0);
signal ALU_Control_Output,FlagRegisterD,FlagRegisterQ,ReservedFlagQ:std_logic_vector(3 downto 0);
signal IF_ID_in,IF_ID_out:std_logic_vector(49 downto 0);
signal ID_EX_in,ID_EX_in_in,ID_EX_out:std_logic_vector(100 downto 0);
signal EX_Mem_in,EX_Mem_in_in,EX_Mem_out:std_logic_vector(55 downto 0);
signal Mem_WB_in,Mem_WB_out:std_logic_vector(52 downto 0);

begin 

IF_ID:my_nDFF generic map(n=>50) port map(clk,IFflush,IFID_Enable,IF_ID_in,IF_ID_out);
ID_EX:my_nDFF generic map(n=>101) port map(clk,rst,'1',ID_EX_in_in,ID_EX_out);
EX_Mem:my_nDFF generic map(n=>56) port map(clk,rst,'1',EX_Mem_in_in,EX_Mem_out);
Mem_WB:my_nDFF generic map(n=>53) port map(clk,rst,'1',Mem_WB_in,Mem_WB_out);
outputportinstance:my_nDFF generic map(n=>16) port map(clk,rst,ID_EX_out(79),outp,outputPort);
FlagRegisterInstance :         my_nDFF generic map(n=>4) port map(clk,reset,'1',FlagRegisterD,FlagRegisterQ);
ReservedFlagRegisterInstance : my_nDFF generic map(n=>4) port map(ID_EX_out(78),reset,'1',FlagRegisterQ,ReservedFlagQ);
 
process(clk)
begin
	if(rising_edge(clk) and flag='1')then
		flag<='0';
		rst<='0';
	end if;

end process;

process(JumpCallControlSig,EX_Mem_out(52),IF_ID_out(49),ID_EX_out(78),reset,interrupt)
begin
if ((IF_ID_out(49)='1') or (ID_EX_out(78)='1') or (interrupt='1')) then
	IFflush<='0';
else
	IFflush<=(reset or JumpCallControlSig or EX_Mem_out(52)) ; 
end if;
end process;

process(JumpCallControlSig,EX_Mem_out(52),ID_EX_out(78),IF_ID_out(49),reset,PcWrite)
begin
if ((ID_EX_out(78)='1') or (IF_ID_out(49)='1')) then
	IDflush<='0';
else
	IDflush<=(JumpCallControlSig or EX_Mem_out(52) or reset or (not PcWrite) ) ; 
end if;
end process;

process(EX_Mem_out(52),ID_EX_out(78))
begin
if ((ID_EX_out(78)='1')) then
	Memflush<='0';
else
	Memflush<=EX_Mem_out(52) ; 
end if;
end process;

with IDflush select 
			ID_EX_in_in(100 downto 35)<=ID_EX_in( 100 downto 35) when '0',
				                    (others =>'0') when others;	
with IDflush select 
			ID_EX_in_in(18 downto 0)<=ID_EX_in( 18 downto 0) when '0',
				                    (others =>'0') when others;

with Memflush select 
			EX_Mem_in_in(55 downto 29)<=EX_Mem_in(55 downto 29) when '0',
				     (others =>'0') when others;     
	
with Memflush select 
			EX_Mem_in_in(12 downto 0)<=EX_Mem_in(12 downto 0) when '0',
				     (others =>'0') when others; 
		
with interrupt select 
			IF_ID_in(47 downto 16)<= InstructionBits when '0',
			                         x"0000E000" when others; 

with interrupt select 
			IF_ID_in(48)<= ldm when '0',
			               '0' when others; 

with Mem_WB_out(51) select 
			writeValue<=Mem_WB_out(50 downto 35) when '0',
				    Mem_WB_out(34 downto 19) when others;	

with decodePC select 
			ID_EX_in(34 downto 19)<= IF_ID_out(15 downto 0) when "00",
			                         EX_Mem_in(44 downto 29) when "01",
						 Mem_WB_in(50 downto 35) when others;

with executePC select 
			EX_Mem_in(28 downto 13)<= ID_EX_out(34 downto 19) when "00",
			                         EX_Mem_in(44 downto 29) when "01",
						 Mem_WB_in(50 downto 35) when others;

with memPC select 
			Mem_WB_in(18 downto 3)<= EX_Mem_out(28 downto 13) when '0',
						 Mem_WB_in(50 downto 35) when others;

ID_EX_in_in(34 downto 19)<=ID_EX_in( 34 downto 19);
EX_Mem_in_in(28 downto 13)<=EX_Mem_in(28 downto 13);
JumpCallControlSig<=ID_EX_out(96) or Jmp_Approval;
reset<=rst or Preset;
JumpCallControlSignal<=JumpCallControlSig and (not(anyinterrupt));
retsig<=EX_Mem_out(52) and (not(anyinterrupt));
anyinterrupt<=IF_ID_out(49) or ID_EX_out(78);
ID_EX_in(100 downto 98)<=IF_ID_out(28 downto 26);
IF_ID_in(49)<=interrupt;
ID_EX_in(78)<=IF_ID_out(49);
ID_EX_in(77)<=IF_ID_out(48);
ID_EX_in(44 downto 35)<=IF_ID_out(25 downto 16);
ID_EX_in(15 downto 0)<=IF_ID_out(47 downto 32);
EX_Mem_in(55)<=ID_EX_out(78);
EX_Mem_in(54)<=ID_EX_out(92);
EX_Mem_in(53)<=ID_EX_out(91);
EX_Mem_in(52)<=ID_EX_out(89);
EX_Mem_in(51)<=ID_EX_out(88);
EX_Mem_in(50)<=ID_EX_out(86);
EX_Mem_in(49)<=ID_EX_out(83);
EX_Mem_in(48 downto 47)<=ID_EX_out(82 downto 81);
EX_Mem_in(46)<=ID_EX_out(90);
EX_Mem_in(45)<=ID_EX_out(87);
EX_Mem_in(12 downto 10)<=ID_EX_out(18 downto 16);
EX_Mem_in(9 downto 0)<=ID_EX_out(44 downto 35);
Mem_WB_in(52)<=EX_Mem_out(50);
Mem_WB_in(51)<=EX_Mem_out(49);
Mem_WB_in(34 downto 19)<=EX_Mem_out(44 downto 29);
Mem_WB_in(2 downto 0)<=EX_Mem_out(12 downto 10);

fetchStageInstance : Fetch_Stage port map(clk,'0',InstructionBits,PcWrite,JumpCallControlSignal,interrupt,retsig,Preset,Memory0, Memory1,EX_Mem_in(44 downto 29),Mem_WB_in(50 downto 35),IF_ID_in(15 downto 0) , ldm,PC);
--fetchStageInstance : Fetch_Stage port map(clk,instructionbits,PcWrite,JumpCallControlSig,interrupt,RetFlushSig,reset,Memory0, Memory1, AluValue,DataMemoryValue, PC_Next_Inst, Double_Sized_Inst_flag ); 	

DecodeStageInstance:Decode_stage port map(IF_ID_out(49),clk,reset,IF_ID_out(47 downto 16),Mem_WB_out(52),Mem_WB_out(2 downto 0),writeValue,ID_EX_in(76 downto 61),ID_EX_in(60 downto 45),ID_EX_in(96),ID_EX_in(95 downto 94),ID_EX_in(93),ID_EX_in(92),ID_EX_in(91),ID_EX_in(90),ID_EX_in(89),ID_EX_in(88),ID_EX_in(87),ID_EX_in(86),ID_EX_in(85 downto 84),ID_EX_in(83),ID_EX_in(82 downto 81),ID_EX_in(80),ID_EX_in(79),ID_EX_in(18 downto 16),ID_EX_in(97),R0,R1,R2,R3,R4,R5);
--DecodeStageInstance:Decode_stage port map(clk,'0',InstructionBits,MemWb_Wb,MemWb_RD,Write_value,Fisrt_operand,Second_Operand,Call,CarrySetReset,Jump,MemWrite,MemRead,SpSelect,RetFlush,AddressSelect,MemSrc,RegWrite,AluOp,MemToReg,SpChanger,PortValue,OutPortEnable);

ExecuteStageInstance:Excute_stage port map(clk,reset,ID_EX_out(97),ID_EX_out(80),ID_EX_out(77),ID_EX_out(15 downto 0),inputPort,ID_EX_out(76 downto 61),ID_EX_out(60 downto 45),ID_EX_out(38 downto 35),ALU_Control_Output,EX_Mem_out(44 downto 29),writeValue,ForwardA,ForwardB,FlagRegisterQ(3),FlagRegisterQ(2),FlagRegisterQ(1),FlagRegisterQ(0),ReservedFlagQ(3),ReservedFlagQ(2),ReservedFlagQ(1),ReservedFlagQ(0),FlagRegisterD(3),FlagRegisterD(2),FlagRegisterD(1),FlagRegisterD(0),EX_Mem_in(44 downto 29),outp,ID_EX_out(95 downto 94));
--ExecuteStageInstance:Excute_stage port map(clk,Reset,RTI,portValue,double_sized_flag,Immediate_value,Input_Port,First_operand,Second_operand,Shift_magnitude,Alu_select,EXMEM_Rd,MEMWB_RD,ForwardA,ForwardB,carry_in,Temp_CarryFlag,Temp_OverFlowFlag,Temp_SignFlag,temp_ZeroFlag,CarryFlag,OverFlowFlag,SignFlag,ZeroFlag,Alu_out);

AluControlInstance:ALU_Control_Unit port map(ID_EX_out(85 downto 84),ID_EX_out(41 downto 39),ALU_Control_Output);
--AluControlInstance:ALU_Control_Unit port map(ALU_OP,Func,ALU_Control_Output);

MemoryStageInstance:MemoryStage port map(clk,EX_Mem_out(46),EX_Mem_out(51),EX_Mem_out(55),EX_Mem_out(45),EX_Mem_out(54),EX_Mem_out(48 downto 47),EX_Mem_out(9 downto 0),EX_Mem_out(44 downto 29),EX_Mem_out(28 downto 13),Mem_WB_out(18 downto 3),Mem_WB_in(50 downto 35),Memory0,Memory1,reset,Sp);
--MemoryStageInstance:MemoryStage port map(clk,SPselect,AddressSelect,interrupt,memsrc,memwrite,SPchanger,EA,aluoutput,previouspc,nextpc,memvalue,M0,M1);

HazardUnitInstance:Hazard_Detection_Unit port map (RS_Approval,RD_Approval,ID_EX_out(91),ID_EX_out(18 downto 16),IF_ID_out(28 downto 26),IF_ID_out(25 downto 23),PcWrite,IFID_Enable,ID_EX_out(77)); 
--HazardUnitInstance:Hazard_Detection_Unit port map (RS_Approval,RD_Approval,IDEX_MemRead,IDEX_RD,IFID_RS,IFID_RD,PC_Write,IFID_Enable);

InterruptUnitInstance:InterruptUnit port map( interrupt,IF_ID_out(49),ID_EX_out(78),JumpCallControlSig,EX_Mem_out(52),memPC,decodePC,executePC);
--InterruptUnitInstance:InterruptUnit port map( FetchInterrupt,DecodeInterrupt,ExecuteInterrupt,jumper,retflush,memPC,decodePC,executePC);

ApprovalInstance:Approval  port map ( IF_ID_out(31 downto 29),IF_ID_out(22 downto 20),RS_Approval,RD_Approval);
--ApprovalInstance:Approval is port ( opcode,FnCode,RSapprove,RDapprove);

JumpUnitInstance: Jump_Control_Unit port map(ID_EX_out(41 downto 39),ID_EX_out(93),FlagRegisterQ,Jmp_Approval);
--JumpUnitInstance:Jump_Control_Unit port map(Func,Jmp_Signal,Flag_Registers,Jmp_Approval);

ForwardUnitInstance:Forward_Unit port map( EX_Mem_out(50),Mem_WB_out(52),ID_EX_out(100 downto 98),ID_EX_out(44 downto 42),EX_Mem_out(12 downto 10),Mem_WB_out(2 downto 0),ForwardA,ForwardB);
--ForwardUnitInstance:Forward_Unit port map( ExecMem_RegWrite,MemWB_RegWrite,ID_EX_RS,ID_EX_RD,ExecMem_RD,MemWB_RD,Forward_A,Forward_B);
---------------------------
AluOutput <= EX_Mem_in(44 downto 29);
MemoryOutput <= Mem_WB_in(50 downto 35);

end architecture MicroProcessor_arch;
