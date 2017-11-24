library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.operation.all;

entity ctrl_unit is
    Port ( instruction: in  STD_LOGIC_VECTOR(15 downto 0);
    	   pc: in  STD_LOGIC_VECTOR(15 downto 0);

    	   ALUOp: out STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
		   ALUsrc: out STD_LOGIC := '0';
		   RegDist: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   MemRead: out STD_LOGIC := '0';
		   MemWrite: out STD_LOGIC := '0'; 
		   RegWrite: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   MemtoReg: out STD_LOGIC := '0';
		   immediate: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   rega: out STD_LOGIC_VECTOR (3 downto 0) := (others => '0'));	
end ctrl_unit;

architecture Behavioral of ctrl_unit is
signal fifteen_ten: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
begin
	fifteen_ten <= instruction(15 downto 11);
	process (instruction)
	begin 
		case fifteen_ten is
		when "01001" => -- ADDIU
			ALUOp <= op_add;
			ALUsrc <= '1';--立即�			RegDist <= instruction(10 downto 8);
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "001";
			rega <= "0" & instruction(10 downto 8);
			if (instruction(7) = '1') then
				immediate <= "11111111" & instruction(7 downto 0);
			else 
				immediate <= "00000000" & instruction(7 downto 0);
			end if;
		when "01000" => -- ADDIU3
			ALUOp <= op_add;
			ALUsrc <= '1';--使用立即�			RegDist <= instruction(7 downto 5);
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "001";
			rega <= "0" & instruction(10 downto 8);
			if (instruction(3) = '1') then
				immediate <= "111111111111" & instruction(3 downto 0);
			else 
				immediate <= "000000000000" & instruction(3 downto 0);
			end if;
		when "11100" => -- SUBU + ADDU
			if instruction(1 downto 0) = "11" then
				ALUOp <= op_sub;--sub
			elsif instruction(1 downto 0) = "01" then 
				ALUOp <= op_add;--add
			end if;
			ALUsrc <= '0';--使用寄存�			
			RegDist <= instruction(4 downto 2);--rz
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "001";--写通用寄存�			
			immediate <= (others => '0');
			rega <= "0" & instruction(10 downto 8);--读rx

		when "01100" => -- ADDSP + MTSP + BTEQZ
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			case( instruction(10 downto 8) ) is 
				when "001" => --BTNEZ 
					ALUOp <= op_nothing;
					ALUsrc <= '0';
					RegDist <= "000";
					RegWrite <= "000";
					if (instruction(7) = '1') then--符号扩展
						immediate <= "11111111" & instruction(7 downto 0);
					else 
						immediate <= "00000000" & instruction(7 downto 0);
					end if;
					rega <= "1111";
				when "011" => --ADDSP
					ALUOp <= op_add;
					ALUsrc <= '1';--使用立即数扩�					
					RegDist <= (others => '0');--�Ĵ���������ν
					if (instruction(7) = '1') then --������չ
						immediate <= "11111111" & instruction(7 downto 0);
					else 
						immediate <= "00000000" & instruction(7 downto 0);
					end if;
					RegWrite <= "101";--写SP
					rega <= "1000";--读sp
				when "100" => --MTSP
					ALUOp <= op_add; -- rx + 0
					ALUsrc <= '1';--使用立即�0
					RegDist <= (others => '0');--无所�					
					immediate <= (others => '0');
					RegWrite <= "101";--写SP
					rega <= "0" & instruction(7 downto 5);--读rx
				when "000" => --BTEQZ
					ALUOp <= op_nothing; -- return 0
					ALUsrc <= '0';
					if (instruction(7) = '1') then --符号扩展
						immediate <= "11111111" & instruction(7 downto 0);
					else 
						immediate <= "00000000" & instruction(7 downto 0);
					end if;
					RegWrite <= "000";--不写
					rega <= "1111";--不读
					RegDist <= (others => '0');--无所�				
					when others => 
				end case ;
		when "11101" => -- AND
			case( instruction(4 downto 0) ) is --AND
			when "01100" =>  
				ALUOp <= op_and;--and
				ALUsrc <= '0';--使用寄存�				
				RegWrite <= "001";--写通用寄存�				
				rega <= "0" & instruction(10 downto 8);
				immediate <= (others => '0');
			when "01101" => --OR
				ALUOp <= op_or;--or
				ALUsrc <= '0';--使用寄存�				
				RegWrite <= "001";--写通用寄存�				
				rega <= "0" & instruction(10 downto 8);
				immediate <= (others => '0');
			when "01010"=> --CMP
				ALUOp <= op_equal;
				ALUsrc <= '0';--使用寄存�				
				RegWrite <= "011";--写T
				immediate <= (others => '0');
				rega <= "0" & instruction(10 downto 8);--读rx
			when "00000" =>
				case( instruction(7 downto 5) ) is 
					when "000" =>  --JR
						rega <= "0" & instruction(10 downto 8);
						ALUsrc <= '0';
						ALUOp <= op_nothing; 
						RegWrite <= "000";
						immediate <= (others => '0');	
					when "110" => -- JALR
						rega <= "0" & instruction(10 downto 8);
						ALUsrc <= '1';
						ALUOp <= op_rpc; -- input_b + 1 
						RegWrite <= "100"; -- 写sp
						immediate <= (others => '0');	
					when "010" => -- MFPC
						ALUOp <= op_add; -- 0 + pc
						ALUsrc <= '1';--使用立即�pc
						RegWrite <= "001"; -- 写通用
						immediate <= pc;
						rega <= "1" & "111";--�
					when "001" => -- JRRA
						rega <= "1010"; -- 读RA
						ALUsrc <= '0';
						ALUOp <= op_nothing; 
						RegWrite <= "000";
						immediate <= (others => '0');	
					when others => 
				end case ;
			when others => 
			end case ;
			RegDist <= instruction(10 downto 8);--rz
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
		when "00110" => -- SLL + SRA
			if instruction(1 downto 0) = "00" then
				ALUOp <= op_sll;
			elsif instruction(1 downto 0) = "11" then 
				ALUOp <= op_sra;
			end if;
			ALUsrc <= '1';--使用立即�			
			RegDist <= instruction(10 downto 8);--写回寄存器rx
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "001";--写通用
			if (instruction(4 downto 2) = "000") then --符号扩展
				immediate <= "000000000000" & "1000";
			else 
				immediate <= "0000000000000" & instruction(4 downto 2);
			end if;
			rega <= "0" & instruction(10 downto 8);--读rx

			

		when "01101" => -- LI
			ALUOp <= op_add; -- 0 + immediate
			ALUsrc <= '1';--使用立即�			
			RegDist <= instruction(10 downto 8);--写回rx
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "001";--写通用
			immediate <= "00000000" & instruction(7 downto 0);
			rega <= "1" & "111";--读全0
		when "10011" => -- LW
			ALUOp <= op_add; -- 0 + immediate
			ALUsrc <= '1';--使用立即�			
			RegDist <= instruction(7 downto 5);--写回ry
			MemRead <= '1';
			MemWrite <= '0';
			MemtoReg <= '1';
			RegWrite <= "001";--写通用
			if(instruction(4) = '0') then
				immediate <= "00000000000" & instruction(4 downto 0);
			else 
				immediate <= "11111111111" & instruction(4 downto 0);
			end if;
			rega <= "1" & "111";--读全0
		when "11011" => -- SW
			ALUOp <= op_add; -- 0 + immediate
			ALUsrc <= '1';--使用立即�			
			RegDist <= instruction(10 downto 8);--写回rx
			MemRead <= '0';
			MemWrite <= '1';
			MemtoReg <= '0';
			RegWrite <= "000";--不写
			if(instruction(4) = '0') then
				immediate <= "00000000000" & instruction(4 downto 0);
			else 
				immediate <= "11111111111" & instruction(4 downto 0);
			end if;
			rega <= "1" & "111";--读全0
		when "10010" => -- LW_SP
			ALUOp <= op_add; -- 0 + immediate
			ALUsrc <= '1';--使用立即�			
			RegDist <= instruction(10 downto 8);--写回rx
			MemRead <= '1';
			MemWrite <= '0';
			MemtoReg <= '1';
			RegWrite <= "001";--写通用
			if(instruction(7) = '0') then
				immediate <= "00000000" & instruction(7 downto 0);
			else 
				immediate <= "11111111" & instruction(7 downto 0);
			end if;
			rega <= "1" & "111";--读全0
		when "11010" => -- SW_SP
			ALUOp <= op_add; -- 0 + immediate
			ALUsrc <= '1';--使用立即�			
			RegDist <= instruction(10 downto 8);--写回rx
			MemRead <= '0';
			MemWrite <= '1';
			MemtoReg <= '0';
			RegWrite <= "000";--不写
			if(instruction(7) = '0') then
				immediate <= "00000000" & instruction(7 downto 0);
			else 
				immediate <= "11111111" & instruction(7 downto 0);
			end if;
			rega <= "1" & "111";--读全0
		when "11110" => -- MFIH + MTIH
			ALUOp <= op_add; -- IH + 0
			ALUsrc <= '1';--使用立即�0
			if (instruction(7 downto 0) = "00000000") then
				rega <= "1" & "001";--读IH
				RegDist <= instruction(10 downto 8);--写回rx
				RegWrite <= "001";--写通用
			elsif instruction(7 downto 0) = "00000001" then 
				RegDist <= (others => '0');--无所�				
				RegWrite <= "101";--写IH
				rega <= "0" & instruction(10 downto 8);--读rx
			end if;
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			immediate <= (others => '0');

		when "00001" => -- NOP
			ALUOp <= op_sll; --sll $0 $0 0
			ALUsrc <= '0';--使用立即�0 
			RegDist <= (others => '0');--写回rx
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "000";--不写
			immediate <= (others => '0');
			rega <= "0" & "000";--�
		when "00010" => -- B
			ALUOp <= op_nothing; 
			ALUsrc <= '0';
			RegDist <= (others => '0');
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "000";
			if (instruction(10) = '1') then--符号扩展
				immediate <= "11111" & instruction(10 downto 0);
			else 
				immediate <= "00000" & instruction(10 downto 0);
			end if;
			rega <= "0" & "000";--�
		when "00100" => -- BEQZ
			ALUOp <= op_nothing; 
			ALUsrc <= '0';
			RegDist <= (others => '0');
			MemRead <= '0';
			MemWrite <= '0';
			MemtoReg <= '0';
			RegWrite <= "000";
			if (instruction(7) = '1') then--符号扩展
				immediate <= "11111111" & instruction(7 downto 0);
			else 
				immediate <= "00000000" & instruction(7 downto 0);
			end if;
			rega <= "0" & instruction(10 downto 8);--读rx

		when "01011" => -- SLTUI
			ALUOp <= op_lt;
			ALUsrc <= '1';
			RegDist <= "000";
			MemRead <= '0';
			MemWrite <= '0';
			RegWrite <= "011";
			MemtoReg <= '0';
			immediate <= "00000000" & instruction(7 downto 0);
			rega <= "0" & instruction(10 downto 8);
		when "01111" => -- MOVE
			ALUOp <= op_add;
			ALUsrc <= '0';
			RegDist <= instruction(10 downto 8);
			MemRead <= '0';
			MemWrite <= '0';
			RegWrite <= "001";
			MemtoReg <= '0';
			immediate <= (others => '0');
			rega <= "1111";
		when others =>
			ALUOp <= op_nothing;
			ALUsrc <= '0';
			RegDist <= "000";
			MemRead <= '0';
			MemWrite <= '0';
			RegWrite <= "000";
			MemtoReg <= '0';
			immediate <= (others => '0');
			rega <= "1111";
		end case;
	end process;
		
end Behavioral;

