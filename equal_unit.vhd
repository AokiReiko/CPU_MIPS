library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity equal_unit is
    Port ( rs_alu: in  STD_LOGIC_VECTOR(15 downto 0);
           rs_mem: in  STD_LOGIC_VECTOR(15 downto 0);
           rs_reg: in  STD_LOGIC_VECTOR(15 downto 0);
           rpc: in  STD_LOGIC_VECTOR(15 downto 0);

           idex_regwrite: in STD_LOGIC_VECTOR(2 downto 0);
           idex_regdist: in STD_LOGIC_VECTOR(15 downto 0);
           instruction: in  STD_LOGIC_VECTOR(15 downto 0);
           t: in STD_LOGIC;
           pc_src: out  STD_LOGIC_VECTOR;	
end equal_unit;

architecture Behavioral of equal_unit is
signal fifteen_ten: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');

begin
  fifteen_ten <= instruction(15 downto 11)
 

	process (instruction, rs_reg, rs_mem, rs_alu, t) 
	begin
	  case fifteen_ten is
        when "00010" => -- B
          pc_src <= "01";
        when "00100" => --BEQZ
          if (rs_reg = "0000000000000000") then
            pc_src <= "01";
          else 
            pc_src <= "00";
          end if;
        when "01100" => 
          if (instruction(10 downto 8) = "000" and t = '1') then
            pc_src <= "01";
          else 
            pc_src <= "00";
          end if;
        when others => 
          pc_src <= "00";
    end case;
  end process;
end Behavioral;

