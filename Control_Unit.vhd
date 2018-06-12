Library ieee;
Use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.numeric_std.all;

entity Control_Unit is 
port
( int:in std_logic;OpCode : in std_logic_vector(2 downto 0); FunctionCode : in std_logic_vector(2 downto 0); Call : out std_logic ;
  CarrySetReset : out std_logic_vector(1 downto 0) ; Jump : out std_logic ; MemWrite : out std_logic ; MemRead : out std_logic ;  
  SpSelect : out std_logic ;  RetFlush : out std_logic ; AddressSelect : out std_logic ; MemSrc : out std_logic ;
  RegWrite : out std_logic ;  AluOp : out std_logic_vector(1 downto 0) ;  MemToReg : out std_logic ; 
  SpChanger : out std_logic_vector(1 downto 0) ; PortValue : out std_logic ; OutPortEnable : out std_logic;ldd,rti :out std_logic );
 
-- MemToReg -- > For Write Back '0' for memory value and '1' for alu result value.
end entity;


architecture Control_Unit_imp of Control_Unit is
begin


process (OpCode,FunctionCode)
begin

	        Call <= '0'; -- intialize all as if it were a NOP inst.
		CarrySetReset <= "00";
		Jump <= '0';
		MemWrite <= '0';
		MemRead <= '0';
		SpSelect <= '0';
		RetFlush <= '0';
		AddressSelect <= '0';
		MemSrc <= '0';
		AluOp <= "00";
		RegWrite <= '0' ;
		MemToReg <= '0' ;
  		SpChanger <= "00";
		PortValue <= '0';
		OutPortEnable <= '0';
		ldd<='0';
		rti<='0';
		-- then change values according to Function and opcode -- > overwrite values.

	if(int='1') then
		SpChanger <= "01";
		AluOp <= "10";
		MemWrite <= '1';
	elsif(OpCode = "001") then -- RLC, Not, Neg ..
			
	 	AluOp <= "01";
		RegWrite <= '1' ;
		MemToReg <= '1' ;

	elsif(OpCode = "000") then -- Add,Sub,SHL,OR ..
		
	 		if ( FunctionCode = "000") then -- MOV
				AluOp <= "10";
			else
				AluOp <= "11";
			end if;
		        RegWrite <= '1' ;
		        MemToReg <= '1' ;

	elsif(OpCode = "010") then -- Pop, Push, Out ,IN ,Jumps ..

	 		if ( FunctionCode = "011") then -- IN
				PortValue <= '1';
				AluOp <= "10";
				MemToReg <= '1' ;
				RegWrite <= '1' ;
				
			elsif ( FunctionCode = "010" ) then -- OUT
				OutPortEnable <= '1';
			else -- to avoid latch.
			end if;

			if ( FunctionCode = "000") then -- Push
				SpChanger <= "01";
				AluOp <= "10";
				MemWrite <= '1';

			elsif ( FunctionCode = "001" ) then -- Pop
				SpChanger <= "10";
				RegWrite <= '1' ;
				MemRead <= '1';
				SpSelect <= '1';
			else -- to avoid latch.
			end if;

			if (FunctionCode(2) = '1') then -- JUMPS
				Jump <= '1';
				AluOp <= "10";
			else
				Jump <= '0';
			end if;

	elsif(OpCode = "011") then -- Call,Ret , RTI , SETC, CLRC .... 

	 		if ( FunctionCode = "000") then -- Call
				MemSrc <= '1';
				AluOp <= "10";
				Call <= '1' ;
				MemWrite <= '1' ;
				SpChanger <= "01";
				
			elsif ( FunctionCode = "001" or FunctionCode = "010" ) then -- RET, RTI
				SpChanger <= "10";
				RetFlush <= '1' ;
				SpSelect <= '1';
				if(FunctionCode = "010") then
					rti<='1';
				end if;
			elsif ( FunctionCode = "011") then -- SETC
				CarrySetReset <= "01";

			elsif ( FunctionCode = "100") then -- CLRC
				CarrySetReset <= "10";
			else -- to avoid latch.
			end if;
	
	elsif(OpCode = "110") then -- LDM .

			AluOp <= "10";
			MemToReg <= '1' ;
			RegWrite <= '1' ;

	elsif(OpCode = "100") then -- LDD .

		AddressSelect <= '1';
	        MemRead <= '1';
		RegWrite <= '1' ;
		ldd<='1';
	elsif(OpCode = "101") then -- STD .
		
		AddressSelect <= '1';
		MemWrite <= '1';
		AluOp <= "10";

	else -- NOP its deafult as we assumed from first intialization.
		
	end if;

end process;

end Control_Unit_imp;