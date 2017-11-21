library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity PC is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en  : in  STD_LOGIC;
           PCWrite : in  STD_LOGIC;
           Mux_in: in  STD_LOGIC_VECTOR(15 downto 0);
           PC_out: out  STD_LOGIC_VECTOR(15 downto 0));	
end PC;

architecture Behavioral of PC is

begin

	process(clk, rst, en, PCWrite)
	begin
		if (rst = '0') then
			PC_out <= (others => '0');
		elsif (clk'event and clk = '1' and en = '1') then
			if (PCWrite = '1') then
				PC_out <= Mux_in;
			else 
				PC_out <= PC_out;
			end if;
		end if;
	end process;
		
end Behavioral;

