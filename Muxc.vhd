library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Muxc is
    Port ( rega: in  STD_LOGIC_VECTOR(15 downto 0);
    	   regb: in  STD_LOGIC_VECTOR(15 downto 0);
    	   wirteA: in  STD_LOGIC;
           data_out: out  STD_LOGIC_VECTOR(15 downto 0));	
end Muxc;

architecture Behavioral of Muxc is

begin

	data_out <= rega when writeA = '1' else regb;
		
end Behavioral;

