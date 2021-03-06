library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity bypass_unit is
    Port ( rs: in  STD_LOGIC_VECTOR(3 downto 0);
         alusrc: in STD_LOGIC;
    	   rt: in  STD_LOGIC_VECTOR(2 downto 0);
    	   exmem_rd: in  STD_LOGIC_VECTOR(2 downto 0);
    	   exmem_regwrite: in  STD_LOGIC_VECTOR(2 downto 0);
    	   memwb_rd: in  STD_LOGIC_VECTOR(2 downto 0);
    	   memwb_regwrite: in  STD_LOGIC_VECTOR(2 downto 0);
         forwarda: out  STD_LOGIC_VECTOR(1 downto 0);
         forwardb: out  STD_LOGIC_VECTOR(1 downto 0));	
end bypass_unit;

architecture Behavioral of bypass_unit is
begin
	process (rs, exmem_regwrite, exmem_rd, memwb_regwrite, memwb_rd) 
	begin
		if ((exmem_regwrite = "001" and exmem_rd = rs(2 downto 0) and rs(3) = '0') or (exmem_regwrite = "010" and rs = "1000"))then
			forwarda <= "01";
    elsif ((memwb_regwrite = "001" and memwb_rd = rs(2 downto 0) and rs(3) = '0') or (memwb_regwrite = "010" and rs = "1000") ) then 
      forwarda <= "10";
    else 
      forwarda <= "00";
		end if;
	end process;
  process (rt, exmem_regwrite, exmem_rd, memwb_regwrite, memwb_rd, alusrc) 
  begin
    if (exmem_regwrite = "001" and exmem_rd = rt ) then--and alusrc = '0') then
      forwardb <= "01";
    elsif (memwb_regwrite = "001" and memwb_rd = rt ) then--and alusrc = '0') then 
      forwardb<= "10";
    else 
      forwardb <= "00";
    end if;
  end process;
end Behavioral;

