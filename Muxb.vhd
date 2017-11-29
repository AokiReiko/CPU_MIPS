library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Muxb is
    Port ( reg: in  STD_LOGIC_VECTOR(15 downto 0);
    	   alu: in  STD_LOGIC_VECTOR(15 downto 0);
    	   mem: in  STD_LOGIC_VECTOR(15 downto 0);
    	   immediate: in  STD_LOGIC_VECTOR(15 downto 0);
    	   alu_src: in  STD_LOGIC;
    	   forward: in  STD_LOGIC_VECTOR(1 downto 0);
    	   reg_out: out  STD_LOGIC_VECTOR(15 downto 0);
           src_out: out  STD_LOGIC_VECTOR(15 downto 0));	
end Muxb;

architecture Behavioral of Muxb is

begin

	process(reg, alu, mem, forward, alu_src, immediate)
	begin
		if (alu_src = '0') then
			case forward is
				when "00" => src_out <= reg;
				when "01" => src_out <= alu;
				when "10" => src_out <= mem;
				when others => src_out <= reg;
			end case;
		elsif (alu_src = '1') then
			src_out <= immediate;
		end if; 
	end process;
	process(reg, alu, mem, forward)
	begin
		case forward is
			when "00" => reg_out <= reg;
			when "01" => reg_out <= alu;
			when "10" => reg_out <= mem;
			when others => reg_out <= reg;
		end case;
	end process;
		
end Behavioral;

