library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Muxpc is
    Port ( PCSrc : in  STD_LOGIC_VECTOR(1 downto 0);
           PCNext: in  STD_LOGIC_VECTOR(15 downto 0);
           PCOffset: in  STD_LOGIC_VECTOR(15 downto 0);
           PCJR: in STD_LOGIC_VECTOR(15 downto 0)
           pc_out: out  STD_LOGIC_VECTOR(15 downto 0));	
end Muxpc;

architecture Behavioral of Muxpc is

begin

	process(PCSrc, PCNext, PCOffset)
	begin
		if (PCSrc = "00") then
			pc_out <= PCNext;
		elsif (PCSrc = "01") then 
			pc_out <= PCOffset;
		elsif (PCSrc = "10") then 
			pc_out <= PCJR;
		end if;
	end process;
		
end Behavioral;

