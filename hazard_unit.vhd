library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity hazard_unit is
    Port ( idex_memread: in  STD_LOGIC;
          alu_src: in STD_LOGIC;
          rega: in STD_LOGIC_VECTOR(3 downto 0);
          idex_rt: in  STD_LOGIC_VECTOR(2 downto 0); --regdist
          ifid_rt: in  STD_LOGIC_VECTOR(2 downto 0);

          ifid_write: out  STD_LOGIC;
          pc_write: out  STD_LOGIC;--�          
			 ctrl_clear: out STD_LOGIC);	
end hazard_unit;
 
architecture Behavioral of hazard_unit is
begin
	process (idex_memread, rega, idex_rt, alu_src, ifid_rt) 
	begin--只有指令需要读寄存器的时候才检测冲�    
	if (idex_memread = '1' and (rega(3) = '0' and rega(2 downto 0) = idex_rt)) then
      ifid_write <= '0';
      pc_write <= '0';
      ctrl_clear <= '1';
    elsif (idex_memread = '1' and (ifid_rt = idex_rt)) then 
      ifid_write <= '0';
      pc_write <= '0';
      ctrl_clear <= '1';
    else 
      ifid_write <= '1';
      pc_write <= '1';
      ctrl_clear <= '0';
    end if;
  end process;
end Behavioral;

