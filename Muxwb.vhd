library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Muxwb is
    Port ( memtoreg : in  STD_LOGIC;
           reg: in  STD_LOGIC_VECTOR(15 downto 0);
           mem: in  STD_LOGIC_VECTOR(15 downto 0);
           data_out: out  STD_LOGIC_VECTOR(15 downto 0));	
end Muxwb;

architecture Behavioral of Muxwb is

begin

	data_out <= mem when memtoreg = '1' else reg;
		
end Behavioral;

