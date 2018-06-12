Library ieee;
Use ieee.std_logic_1164.all;
Entity InterruptUnit is  port
	( FetchInterrupt,DecodeInterrupt,ExecuteInterrupt,jumper,retflush : in std_logic;
	  memPC: out std_logic;
          decodePC,executePC : out std_logic_vector(1 downto 0)); 
end InterruptUnit;
Architecture a_InterruptUnit of InterruptUnit is

begin
	process(retflush,FetchInterrupt,DecodeInterrupt,ExecuteInterrupt,jumper)
	begin
		decodePC<="00";
		executePC<="00";
		memPC<='0';
		if(retflush='1') then
			if(ExecuteInterrupt='1') then
				memPC<='1';
			elsif (DecodeInterrupt='1')then
				executePC<="10";
			elsif(FetchInterrupt='1')then
				decodePC<="10";
			end if;
		elsif(jumper='1') then
			if (DecodeInterrupt='1')then
				executePC<="01";
			elsif(FetchInterrupt='1')then
				decodePC<="01";
			end if;
		end if;
	end process;

end a_InterruptUnit;
