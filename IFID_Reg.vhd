library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity IFID_Reg is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           IF_Flush: in  STD_LOGIC;
           IFIDWrite: in  STD_LOGIC;

           PCNext: in  STD_LOGIC_VECTOR(15 downto 0);
           Instruction: in  STD_LOGIC_VECTOR(15 downto 0);
           PCNext_out: out  STD_LOGIC_VECTOR(15 downto 0);
           Instruction_out: out  STD_LOGIC_VECTOR(15 downto 0));	
end IFID_Reg;

architecture Behavioral of IFID_Reg is

begin

	process(clk, rst, IF_Flush)
	begin
		if (IF_Flush = '1') then
			Instruction_out <= (others => '0');
			PCNext_out <= (others => '0');
		elsif (clk'event and clk = '1' and IFIDWrite = '1') then
			Instruction_out <= Instruction;
			PCNext_out <= PCNext; 
		end if;
	end process;
		
end Behavioral;

