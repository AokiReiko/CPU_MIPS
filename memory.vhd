library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mymemory is
    Port ( oe_1: out STD_LOGIC;
    	   we_1: out STD_LOGIC;
    	   en_1: out STD_LOGIC;
    	   oe_2: out STD_LOGIC;
    	   we_2: out STD_LOGIC;
    	   en_2: out STD_LOGIC;
    	   addr_1: out STD_LOGIC_VECTOR(17 downto 0);
    	   addr_2: out STD_LOGIC_VECTOR(17 downto 0);
    	   data_1: inout STD_LOGIC_VECTOR(15 downto 0);
    	   data_2: inout STD_LOGIC_VECTOR(15 downto 0);

    	   memread: in STD_LOGIC;
    	   memwrite: in STD_LOGIC;

    	   addr_in: in STD_LOGIC_VECTOR(15 downto 0);
    	   data_in: in STD_LOGIC_VECTOR(15 downto 0));	
end mymemory;

architecture Behavioral of mymemory is

begin
	oe_1 <= '1';
	we_1 <= '1';
	en_1 <= '1';
	
	oe_2 <= '1';
	we_2 <= '1';
	en_2 <= '1';
	addr_1 <= (others => '0');
	addr_2 <= (others => '0');
	data_1 <= (others => '0');
	data_2 <= (others => '0');
end Behavioral;

