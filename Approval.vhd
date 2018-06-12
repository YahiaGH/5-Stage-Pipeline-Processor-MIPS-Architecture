library ieee;
use  ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;



entity Approval is port ( opcode : in std_logic_vector(2 downto 0);FnCode : in std_logic_vector(2 downto 0);
RSapprove,RDapprove :out std_logic);
end entity Approval;


architecture arch of approval is



begin

process(opcode,FnCode)
begin 

if     opcode = "111"  then 
       RsApprove <= '0';
       RdApprove <= '0'; --NOP
elsif opcode= "000" and fncode ="000" then RsApprove <= '1'; RdApprove <= '0';--Mov
elsif opcode= "000" and fncode ="001" then RsApprove <= '1'; RdApprove <= '1';--add
elsif opcode= "000" and fncode ="010" then RsApprove <= '1'; RdApprove <= '1';--sub
elsif opcode= "000" and fncode ="011" then RsApprove <= '1'; RdApprove <= '1';--and
elsif opcode= "000" and fncode ="100" then RsApprove <= '1'; RdApprove <= '1';--or
elsif opcode= "000" and fncode ="101" then RsApprove <= '1'; RdApprove <= '0';--shl
elsif opcode= "000" and fncode ="110" then RsApprove <= '1'; RdApprove <= '0';--shr


elsif opcode = "001" then RsApprove <= '0' ; RDApprove <= '1' ; --Rlc,rrc,not,neg,inc,dec      
elsif opcode = "010" and fncode /= "011" then RsApprove <= '1'; RdApprove <= '0'; --push,pop,out,jumps
elsif opcode = "010" and fncode  = "011" then RsApprove <= '0'; RdApprove <= '0'; --In


elsif opcode = "011" and fncode /= "000"  then RsApprove <= '0'; RdApprove <= '0';-- Ret,Rti,Stc,clrc
elsif opcode = "011" and fncode  = "000"  then RsApprove <= '1'; RdApprove <= '0'; -- call


elsif opcode ="101" then RsApprove <= '1'; RdApprove <= '0'; --STD
else RsApprove <= '0'; RdApprove <= '0'; --LDM,LDD,others;
end if;







end process ;
 

end architecture arch;


