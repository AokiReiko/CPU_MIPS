library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity EXMEM_Reg is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           
           in_RegDist: in STD_LOGIC_VECTOR (2 downto 0);
		   in_MemRead: in STD_LOGIC;
		   in_MemWrite: in STD_LOGIC ;
		   in_RegWrite: in STD_LOGIC_VECTOR (2 downto 0);
		   in_MemtoReg: in STD_LOGIC;
		   in_regdata: in STD_LOGIC_VECTOR (15 downto 0);
			in_alu_data: in std_logic_vector(15 downto 0);
		   
		   out_RegDist: out STD_LOGIC_VECTOR (2 downto 0);
		   out_MemRead: out STD_LOGIC;
		   out_MemWrite: out STD_LOGIC ;
		   out_RegWrite: out STD_LOGIC_VECTOR (2 downto 0);
		   out_MemtoReg: out STD_LOGIC;
		   out_regdata: out STD_LOGIC_VECTOR (15 downto 0);
			out_alu_data: out std_logic_vector(15 downto 0));
		  
end EXMEM_Reg;

architecture Behavioral of EXMEM_Reg is

begin

	process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			out_RegDist <= in_RegDist;
			out_MemRead <= in_MemRead;
			out_MemWrite <= in_MemWrite;
			out_RegWrite <= in_RegWrite;
			out_MemtoReg <= in_MemtoReg;
			out_regdata <= in_regdata;
			out_alu_data <= in_alu_data;
		end if;
	end process;
		
end Behavioral;

