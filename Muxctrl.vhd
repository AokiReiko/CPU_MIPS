library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Muxctrl is
    Port ( ctrl_flush: in STD_LOGIC := '0';

           in_ALUOp: in STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
		   in_ALUsrc: in STD_LOGIC := '0';
		   in_RegDist: in STD_LOGIC := '0';
		   in_MemRead: in STD_LOGIC := '0';
		   in_MemWrite: in STD_LOGIC := '0';
		   in_RegWrite: in STD_LOGIC := '0';
		   in_MemtoReg: in STD_LOGIC := '0';

		   out_ALUOp: out STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
		   out_ALUsrc: out STD_LOGIC := '0';
		   out_RegDist: out STD_LOGIC := '0';
		   out_MemRead: out STD_LOGIC := '0';
		   out_MemWrite: out STD_LOGIC := '0';
		   out_RegWrite: out STD_LOGIC := '0';
		   out_MemtoReg: out STD_LOGIC := '0');	
end Muxctrl;

architecture Behavioral of Muxctrl is

begin

	process(ctrl_flush, 
			in_ALUsrc, 
			in_ALUOp, 
			in_MemtoReg, 
			in_RegWrite, 
			in_MemWrite, 
			in_MemRead, 
			in_RegDist)
	begin
		if (ctrl_flush = '0') then
			out_ALUsrc <= in_ALUsrc;
			out_ALUOp <= in_ALUOp;
			out_MemtoReg <= in_MemtoReg;
			out_RegWrite <= in_RegWrite;
			out_MemWrite <= in_MemWrite;
			out_MemRead <= in_MemRead;
			out_MemRead <= in_RegDist;
		elsif (ctrl_flush = '1') then--控制信号如何清空存疑，不一定是0
		 	out_ALUsrc <= '0';
			out_ALUOp <= '0';
			out_MemtoReg <= '0';
			out_RegWrite <= '0';
			out_MemWrite <= '0';
			out_MemRead <= '0';
			out_MemRead <= '0';
		end if;
	end process;
		
end Behavioral;

