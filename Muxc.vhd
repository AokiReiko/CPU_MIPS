library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Muxc is
    Port ( data_1: in  STD_LOGIC_VECTOR(15 downto 0);
    	   data_2: in  STD_LOGIC_VECTOR(15 downto 0);
    	   addr: in  STD_LOGIC_VECTOR(15 downto 0);
           data_out: out  STD_LOGIC_VECTOR(15 downto 0));	
end Muxc;

architecture Behavioral of Muxc is

begin

	process(data_2,data_1,addr)
	begin
		if (addr(15) = '1') then
			data_out <= data_1;
		else 
			data_out <= data_2;
		end if;
	end process;
		
end Behavioral;

