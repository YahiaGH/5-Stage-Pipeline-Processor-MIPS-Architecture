Library ieee;
Use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.numeric_std.all;

entity PC_Unit is 
port
( CLK,rst : in std_logic ; CountEnable : in std_logic ; OpCodeCheck : in std_logic_vector(2 downto 0) ; 
  JumpCallControlSig : in std_logic  ; Interrupt : in std_logic  ;  RetFlushSig : in std_logic  ; Reset : in std_logic  ;
  Memory0 : in std_logic_vector(15 downto 0); Memory1 : in std_logic_vector(15 downto 0); AluValue : in std_logic_vector(15 downto 0); 
  DataMemoryValue : in std_logic_vector(15 downto 0); 
  AddressValue : out std_logic_vector(9 downto 0); PC_Next_Inst : out std_logic_vector(15 downto 0); 
  Double_Sized_Inst : out std_logic );
end entity;

-- OpCodeCheck -- > to check whether increment value will be 2(32 bit) or 1(16 bit) in Case of [Load Immediate Value] checking on 
-- OpCode comes form  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>(instruction memory).

-- JumpCallControlSig -- > comes from the Jump Control or CALL. comes from OR (Call with JUMP)
-- Memory0 and Memory1 -- > represents M[0] and M[1].
-- AluValue -- > its responsible for latching PC with the RD value for CALL Operations.
-- DataMemoryValue -- > Data which comes out from data memory for poping value of stack.
-- RetFlushSig -- > for selecting value of data memory which is popped.
-- PC_Next_Inst --> the incremented PC Needed to reserved and pushed in Stack.
-- Double_Sized_Inst --> The Result of The And Gate needed to fetch 32-bit for LDM (for the immedeiate value 16-bit).


architecture PC_Unit_imp of PC_Unit is

Component PC is
port( Clk,Reset,CountEnable : in std_logic;
DataIN : in std_logic_vector(15 downto 0);
CountOut : out std_logic_vector(15 downto 0));
end Component;

signal Increment_Result : std_logic_vector(1 downto 0) ; -- value decided by the OpCheck to decide whether to add 2 or 1.
signal Incremented_Value : std_logic_vector(15 downto 0):="0000000000000000"  ; -- value resulted after Addition took place.
signal JumpCallControlMux_Value : std_logic_vector(15 downto 0):="0000000000000000"  ; -- value determined with JumpControlSig on mux.
signal RetFlushSigMux_Value : std_logic_vector(15 downto 0) :="0000000000000000" ; -- value determined with RetFlushSig on mux.
signal InterruptMux_Value : std_logic_vector(15 downto 0) :="0000000000000000" ; -- value determined with Interrupt on mux.
signal ResetMux_Value : std_logic_vector(15 downto 0) := "0000000000000000" ; -- value determined with Reset on mux.
signal temp : std_logic_vector(15 downto 0) := "0000000000000000" ;       
signal PC_OutValue : std_logic_vector(15 downto 0) ; -- the output of the PC entity.

--signal rst : std_logic := '1';
begin

-- TAKE CARE when sending OpCheck MSB -- LSB.
with OpCodeCheck select Increment_Result <= "10" when "110", -- add 1 or 2
				            "01" when others ; -- result of the and gate.
Incremented_Value <= std_logic_vector(unsigned(Increment_Result) + unsigned(temp)); -- Adding Addresses.
temp <= PC_OutValue;
AddressValue <= PC_OutValue (9 downto 0); 
-- sending out the Address needed for INSTRUCTION MEMORY 1024 Address value 10-Bits and taking the LSB.

Double_Sized_Inst <= Increment_Result(1); -- if you look at the Increment_Result you will notice that MSB will be = '1' at the 
-- Condition when the AND = TRUE and else it will be = '0'.

with JumpCallControlSig select JumpCallControlMux_Value <=  Incremented_Value when '0', -- '0' choose the value Addition.
				                            AluValue when '1', -- '1' choose Value From ALU.
							    (others =>'0') when others ; 

with RetFlushSig select RetFlushSigMux_Value <=  JumpCallControlMux_Value when '0', -- '0' choose the value determined 
											   --with JumpControlSig on mux..
				                 DataMemoryValue when '1', -- '1' choose Value From DataMemory.
					         (others =>'0') when others ;

with Interrupt select InterruptMux_Value <=  RetFlushSigMux_Value when '0', -- '0' choose the value determined 
											   --with RetFlushSig on mux..
				             Memory1 when '1', -- '1' choose Value From M[1].
					     (others =>'0') when others ;

with Reset select ResetMux_Value <=  InterruptMux_Value when '0', -- '0' choose the value determined 
									       --with Interrupt on mux..
				     Memory0 when '1', -- '1' choose Value From M[0].
			             (others =>'0') when others ;

--with PC_OutValue select rst <= '1' when "XXXXXXXXXXXXXXXX",
--				 '0' when others;			
PC_Next_Inst <= ResetMux_Value;
-- >> The ResetMux_Value Contains Finally The Data Needed To Be Latched To The PC ---> DataIN.

PC_Address : PC port map (CLK,rst,CountEnable,ResetMux_Value,PC_OutValue);

end PC_Unit_imp;
