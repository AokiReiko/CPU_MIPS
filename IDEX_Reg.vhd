library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity IDEX_Reg is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           
           in_ALUOp: in STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
		   in_ALUsrc: in STD_LOGIC := '0';
		   in_RegDist: in STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   in_MemRead: in STD_LOGIC := '0';
		   in_MemWrite: in STD_LOGIC := '0';
		   in_RegWrite: in STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   in_MemtoReg: in STD_LOGIC := '0';
		   in_immediate: in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   in_rega: in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   in_regb: in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   in_rs: in STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
		   in_rt: in STD_LOGIC_VECTOR (2 downto 0) := (others => '0');

		   out_ALUOp: out STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
		   out_ALUsrc: out STD_LOGIC := '0';
		   out_RegDist: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   out_MemRead: out STD_LOGIC := '0';
		   out_MemWrite: out STD_LOGIC := '0';
		   out_RegWrite: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   out_MemtoReg: out STD_LOGIC := '0';
		   out_immediate: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   out_rega: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   out_regb: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   out_rs: out STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
		   out_rt: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0'));


end IDEX_Reg;

architecture Behavioral of IDEX_Reg is

begin

	process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			out_ALUOp <= in_ALUOp;
			out_ALUsrc <= in_ALUsrc;
			out_RegDist <= in_RegDist;
			out_MemRead <= in_MemRead;
			out_MemWrite <= in_MemWrite;
			out_RegWrite <= in_RegWrite;
			out_MemtoReg <= in_MemtoReg;
			out_immediate <= in_immediate;
			out_rega <= in_rega;
			out_regb <= in_regb;
			out_rs <= in_rs;
			out_rt <= in_rt;
		end if;
	end process;
		
end Behavioral;

