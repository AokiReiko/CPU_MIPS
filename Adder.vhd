library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Adder is
    Port ( OpranA: in  STD_LOGIC_VECTOR(15 downto 0);
           OpranB: in  STD_LOGIC_VECTOR(15 downto 0);
           res: out  STD_LOGIC_VECTOR(15 downto 0));	
end Adder;

architecture Behavioral of Adder is

begin
	res <= OpranA + OpranB;
end Behavioral;

