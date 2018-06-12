Library ieee;
Use ieee.std_logic_1164.all;

Entity my_SP is
Generic ( n : integer := 16);
port( Clk,Rst : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end my_SP;

Architecture a_my_SP of my_SP is
begin

Process (Clk,Rst)
begin
	if Rst = '1' then
		q <= "0000001111111111";
	elsif rising_edge(Clk) then
		q <= d;
	end if;
end process;
end a_my_SP;

