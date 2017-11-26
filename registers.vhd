library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity registers is
    Port ( clk : in STD_LOGIC;
           RegWrite : in STD_LOGIC_VECTOR (2 downto 0):= (others => '0');
           RegA: in  STD_LOGIC_VECTOR(3 downto 0);
           RegB: in  STD_LOGIC_VECTOR(2 downto 0);
           RegW: in  STD_LOGIC_VECTOR(2 downto 0);
           WRData: in  STD_LOGIC_VECTOR(15 downto 0);
           outA: out  STD_LOGIC_VECTOR(15 downto 0);
           outB: out  STD_LOGIC_VECTOR(15 downto 0);
           outT: out STD_LOGIC);	
end registers;

architecture Behavioral of registers is

signal R0: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal R1: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal R2: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal R3: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal R4: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal R5: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal R6: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal R7: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

signal SP: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal IH: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal T: STD_LOGIC:= '0';
signal RA: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

signal reg_num: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');

begin
outT <= T;
reg_num <= RegA(2 downto 0);
	process(clk)
	begin
		if (clk'event and clk = '1') then
			if (RegA(3) = '0') then
				case reg_num is
					when "000" => outA <= R0;
					when "001" => outA <= R1;
					when "010" => outA <= R2;
					when "011" => outA <= R3;
					when "100" => outA <= R4;
					when "101" => outA <= R5;
					when "110" => outA <= R6;
					when "111" => outA <= R7;
					when others => outA <= R0;
				end case;
			elsif RegA(3) = '1' then
				case reg_num is
					when "000" => outA <= SP;
					when "001" => outA <= IH;
					when "010" => outA <= RA;
					when "111" => outA <= (others => '0');
					when others => outA <= (others => '0');--输出�
				end case;
			end if; 
		end if;
	end process;

	process(clk)
	begin
		if (clk'event and clk = '1') then
			case RegB is
				when "000" => outB <= R0;
				when "001" => outB <= R1;
				when "010" => outB <= R2;
				when "011" => outB <= R3;
				when "100" => outB <= R4;
				when "101" => outB <= R5;
				when "110" => outB <= R6;
				when "111" => outB <= R7;
				when others => outB <= R0;
			end case;
		end if;
	end process;

	process(clk)--WB阶段的信号赋值需要注�	begin
	begin
		if (clk'event and clk = '1') then
			case RegWrite is
			when "001" =>
				case RegW is
					when "000" => R0 <= WRData;
					when "001" => R1 <= WRData;
					when "010" => R2 <= WRData;
					when "011" => R3 <= WRData;
					when "100" => R4 <= WRData;
					when "101" => R5 <= WRData;
					when "110" => R6 <= WRData;
					when "111" => R7 <= WRData;
					when others => R0 <= R0;
				end case;
			when  "010" =>
				SP <= WRData;
			when "011" =>
				T <= WRData(0);
			when "100" =>
				RA <= WRData;
			when "101" =>
				IH <= WRData;  
			when others => 
				R0 <= R0;
			end case;
		end if;
	end process;
		
end Behavioral;

