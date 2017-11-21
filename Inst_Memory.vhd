library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Inst_Memory is
    Port ( en  : in  STD_LOGIC;
           we  : in  STD_LOGIC;
           oe  : in  STD_LOGIC;
           PC: in  STD_LOGIC_VECTOR(15 downto 0);
           instruction: inout  STD_LOGIC_VECTOR(15 downto 0) := (others => 'Z'));	
end Inst_Memory;

architecture Behavioral of Inst_Memory is

begin
		
end Behavioral;

