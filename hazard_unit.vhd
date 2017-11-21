library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity hazard_unit is
    Port ( idex_memread: in  STD_LOGIC;
          idex_rt: in  STD_LOGIC_VECTOR(2 downto 0); --regdist
          ifid_rs: in  STD_LOGIC_VECTOR(2 downto 0);
          ifid_rt: in  STD_LOGIC_VECTOR(2 downto 0);
          ifid_write: out  STD_LOGIC;
          pc_write: out  STD_LOGIC);	
end hazard_unit;

architecture Behavioral of hazard_unit is
begin
	process (idex_memread, idex_rt, ifid_rs, ifid_rt) 
	begin
    if (idex_memread = '1' and (idex_rt = ifid_rt or idex_rt = ifid_rs)) then
      ifid_write <= '0';
      pc_write <= '0';
    else 
      ifid_write <= '1';
      pc_write <= '1';
    end if;
  end process;
end Behavioral;

