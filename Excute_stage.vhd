 library ieee;
use  ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity Excute_stage is port (clk,Reset,RTI,portValue,double_sized_flag :in std_logic;Immediate_value,Input_Port :in std_logic_vector(15 downto 0);
First_operand,Second_operand : in std_logic_vector(15 downto 0);Shift_magnitude,Alu_select:in std_logic_vector(3 downto 0);
EXMEM_Rd,MEMWB_RD : in std_logic_vector(15 downto 0); ForwardA,ForwardB :in std_logic_vector(1 downto 0);carry_in,overflow_in,sign_in,zero_in :in std_logic;Temp_CarryFlag,Temp_OverFlowFlag,Temp_SignFlag,temp_ZeroFlag:in std_logic;
Final_Carry_Flag,OverFlowFlag,SignFlag,ZeroFlag:out std_logic;
Alu_out,outp:out std_logic_vector(15 downto 0);carry_set_reset :std_logic_vector(1 downto 0));

end entity; 


architecture Excute_stage_imp of Excute_stage is 


component ALU is 
port(A :in std_logic_vector (15 downto 0);b :in std_logic_vector (15 downto 0);S : in std_logic_vector (3 downto 0);
cin,Overflow_in,sign_in,zero_in  : in std_logic ;Shift_magnitude: in std_logic_vector(3 downto 0); F :out std_logic_vector (15 downto 0); CarryFlag,OverFlowFlag,SignFlag,ZeroFlag :out std_logic);
end component ALU;

signal A,B,double_sized_flag_Mux_Out,portvalue_Mux_Out :std_logic_vector(15 downto 0);
signal CarryFlag_aux,OverFlowFlag_aux,SignFlag_aux,ZeroFlag_aux:std_logic;
signal carryflag :std_logic;
begin

AlU_instance : Alu port map(A,B,alu_select,carry_in,Overflow_in,sign_in,zero_in ,Shift_magnitude,Alu_out,CarryFlag_aux,OverFlowFlag_aux,SignFlag_aux,ZeroFlag_aux);
outp<=double_sized_flag_Mux_Out;
with double_sized_flag select 
               
      			     A <= Immediate_value     when '1',
                                  portvalue_Mux_Out       when  '0',
                                  (others=>'0')       when others;
 

with Portvalue select 

    portvalue_Mux_Out <= double_sized_flag_Mux_Out when '0',
                         Input_Port                when '1',
                         (others=>'0')  when others;

with forwardA select
                   
     double_sized_flag_Mux_Out <=  first_operand     when "00",
           			   EXMEM_Rd          when "01",
		                   MEMWB_RD          when "10",
		                  (others=>'0')      when others;
with forwardB select 
      B <=  second_operand    when "00",
            EXMEM_Rd          when "01",
            MEMWB_RD          when "10",
            (others=>'0')     when others;

with RTI select 
     CarryFlag    <= carryflag_aux        when '0',
                  temp_carryflag          when others;
with RTI select 
     OverFlowFlag <=OverFlowFlag_aux      when '0',
                  temp_OverFlowFlag       when others;
with RTI select 
     SignFlag    <= SignFlag_aux         when '0',
                  temp_SignFlag           when others;
 with RTI select 
     ZeroFlag <= ZeroFlag_aux            when '0',
                  temp_ZeroFlag           when others;
 
with carry_set_reset select
  Final_carry_flag <= carryflag when "00",
                      '1'       when "01",
                      '0' when others;
 
end architecture Excute_stage_imp;