library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library mypackage;
use mypackage.alu_defination.all;

entity ctrl_unit is
    Port ( instrunction: in  STD_LOGIC_VECTOR(15 downto 0);
    	   pc: in  STD_LOGIC_VECTOR(15 downto 0);
    	   ctrl_clear: in STD_LOGIC;

    	   ALUOp: out STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
		   ALUsrc: out STD_LOGIC := '0';
		   RegDist: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   MemRead: out STD_LOGIC := '0';
		   MemWrite: out STD_LOGIC := '0'; 
		   RegWrite: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0')
		   MemtoReg: out STD_LOGIC := '0';
		   immediate: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   rega: out STD_LOGIC_VECTOR (3 downto 0) := (others => '0'));	
end ctrl_unit;

architecture Behavioral of ctrl_unit is
signal fifteen_ten: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
begin
	fifteen_ten <= instrunction(15 downto 10);
	process (instrunction, ctrl_clear)
	begin 
	if (ctrl_clear = '1') then
		ALUOp <= op_nothing;
		ALUsrc <= '1';--立即数
		RegDist <= "000";
		MemRead <= '0';
		MemWrite <= '0';
		MemtoReg <= '0';
		RegWrite <= "000";
		rega <= "1111";
		immediate <= (others => '0');
	else
		case fifteen_ten is
		when "01001" => -- ADDIU
			ALUOp <= op_add;
			ALUsrc <= '1';--立即数
			RegDist <= instrunction(10 downto 8);
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "001";
			rega <= "0" & instrunction(10 downto 8);
			if (instrunction(7) = '1') then
				immediate <= "11111111" & instrunction(7 downto 0);
			else 
				immediate <= "00000000" & instrunction(7 downto 0);
			end if;
		when "01000" => -- ADDIU3
			ALUOp <= op_add;
			ALUsrc <= '1';--使用立即数
			RegDist <= instrunction(7 downto 5);
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "001";
			rega <= "0" & instrunction(10 downto 8);
			if (instrunction(3) = '1') then
				immediate <= "111111111111" & instrunction(3 downto 0);
			else 
				immediate <= "000000000000" & instrunction(3 downto 0);
			end if;
		when "11100" => -- SUBU + ADDU
			if instrunction(1 downto 0) = "11" then
				ALUOp <= op_sub;--sub
			elsif instrunction(1 downto 0) = "01" then 
				ALUOp <= op_add;--add
			end if;
			ALUsrc <= '0';--使用寄存器
			RegDist <= instrunction(4 downto 2);--rz
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "001";--写通用寄存器
			immediate <= (others => '0');
			rega <= "0" & instrunction(10 downto 8);--读rx

		when "01100" => -- ADDSP + MTSP + BTEQZ
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			if instrunction(10 downto 8) = "011" then -- ADDSP
				ALUOp <= op_add;
				ALUsrc <= '1';--使用立即数扩展
				RegDist <= (others => '0');--寄存器号无所谓
				if (instrunction(7) = '1') then --符号扩展
					immediate <= "11111111" & instrunction(7 downto 0);
				else 
					immediate <= "00000000" & instrunction(7 downto 0);
				end if;
				RegWrite <= "101";--写SP
				rega <= "1000";--读sp
			elsif instrunction(10 downto 8) = "100" then -- MTSP
				ALUOp <= op_add; -- rx + 0
				ALUsrc <= '1';--使用立即数 0
				RegDist <= (others => '0');--无所谓
				immediate <= (others => '0');
				RegWrite <= "101";--写SP
				rega <= "0" & instrunction(7 downto 5);--读rx
			elsif instrunction(10 downto 8) = "000" then  -- BTEQZ
				ALUOp <= op_nothing; -- return 0
				ALUsrc <= '0';
				if (instrunction(7) = "1") then --符号扩展
					immediate <= "11111111" & instrunction(7 downto 0);
				else 
					immediate <= "00000000" & instrunction(7 downto 0);
				end if;
				RegWrite <= "000";--不写
				rega <= "0000";--不读
				RegDist <= (others => '0');--无所谓
			end if;			
			
		when "11101" => -- AND
			if instrunction(4 downto 0) = "01100" then
				ALUOp <= op_and;--and
				ALUsrc <= '0';--使用寄存器
				rega <= "0" & instrunction(10 downto 8);
			elsif instrunction(4 downto 0) = "01101" then 
				ALUOp <= op_or;--or
				ALUsrc <= '0';--使用寄存器
				rega <= "0" & instrunction(10 downto 8);
			elsif instrunction(4 downto 0 ) = "00000" then 
				ALUOp <= op_add; -- 0 + pc
				ALUsrc <= '1';--使用立即数 pc
				rega <= "1" & "111";--读0
			end if;
			RegDist <= instrunction(10 downto 8);--rz
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "001";--写通用寄存器
			immediate <= pc;
		when "00110" => -- SLL + SRA
			if instrunction(1 downto 0) = "00" then
				ALUOp <= op_sll;
			elsif instrunction(1 downto 0) = "11" then 
				ALUOp <= op_sra;
			end if;
			ALUsrc <= '1';--使用立即数
			RegDist <= instrunction(10 downto 8);--写回寄存器rx
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "001";--写通用
			if (instrunction(4 downto 2) = "000") then --符号扩展
				immediate <= "000000000000" & "1000";
			else 
				immediate <= "0000000000000" & instrunction(4 downto 2);
			end if;
			rega <= "0" & instrunction(10 downto 8);--读rx

		when "11101" => -- CMP
			ALUOp <= op_equal;
			ALUsrc <= '0';--使用寄存器
			RegDist <= (others => '0');--无效
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "011";--写T
			immediate <= (others => '0');
			rega <= "0" & instrunction(10 downto 8);--读rx

		when "01101" => -- LI
			ALUOp <= op_add; -- 0 + immediate
			ALUsrc <= '1';--使用立即数
			RegDist <= instrunction(10 downto 8);--写回rx
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "001";--写通用
			immediate <= "00000000" & instrunction(7 downto 0);
			rega <= "1" & "111";--读全0
		when "11100" => -- LW
		when "11100" => -- SW
		when "11100" => -- LW_SP
		when "11100" => -- SW_SP

		when "11110" => -- MFIH + MTIH
			ALUOp <= op_add; -- IH + 0
			ALUsrc <= '1';--使用立即数 0
			if (instrunction(7 downto 0) = "00000000") then
				rega <= "1" & "001";--读IH
				RegDist <= instrunction(10 downto 8);--写回rx
				RegWrite <= "001";--写通用
			elsif instrunction(7 downto 0) = "00000001" then 
				RegDist <= (others => '0');--无所谓
				RegWrite <= "101";--写IH
				rega <= "0" & instrunction(10 downto 8);--读rx
			end if;
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			immediate <= (others => '0');

		when "00001" => -- NOP
			ALUOp <= op_sll; --sll $0 $0 0
			ALUsrc <= '0';--使用立即数 0 
			RegDist <= (others => '0');--写回rx
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "000";--不写
			immediate <= (others => '0');
			rega <= "0" & "000";--读0
		when "00010" => -- B
			ALUOp <= op_nothing; 
			ALUsrc <= '0';
			RegDist <= (others => '0');
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "000";
			if (instrunction(10) = '1') then--符号扩展
				immediate <= "11111" & instrunction(10 downto 0);
			else 
				immediate <= "00000" & instrunction(10 downto 0);
			end if;
			rega <= "0" & "000";--读0
		when "00100" => -- BEQZ
			ALUOp <= op_nothing; 
			ALUsrc <= '0';
			RegDist <= (others => '0');
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "000";
			if (instrunction(7) = '1') then--符号扩展
				immediate <= "11111111" & instrunction(7 downto 0);
			else 
				immediate <= "00000000" & instrunction(7 downto 0);
			end if;
			rega <= "0" & instrunction(10 downto 8);--读rx

		when "11101" => -- JR + JALR
			RegDist <= (others => '0');
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';	
			rega <= "0" & instrunction(10 downto 8); -- 读rx寄存器
			if (instrunction(7 downto 6) = "00") then
				ALUsrc <= '0';
				ALUOp <= op_nothing; 
				RegWrite <= "000";
				immediate <= (others => '0');	
			elsif instrunction(7 downto 6) = "11" then
				ALUOp <= op_rpc; --pc + 1 
				ALUsrc <= '1';--b选择立即数
				RegWrite <= "100"; -- 写RA
				immediate <= pc;	
			end if; 
		when "11100" => -- JRRA
		when "11100" => -- SLTUI
		when "11100" => -- MOVE
		when "11100" => -- BTNEZ
		end case;
	end if;
	end process;

	--未完成
	ALUOp <=
	ALUsrc <=
	RegDist <=
	MemRead <=
	MemWrite <=
	RegWrite <=
	MemtoReg <=
		
end Behavioral;

