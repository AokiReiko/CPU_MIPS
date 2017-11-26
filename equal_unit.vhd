library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity equal_unit is
    Port ( rs_alu: in  STD_LOGIC_VECTOR(15 downto 0);
           rs_mem: in  STD_LOGIC_VECTOR(15 downto 0);
           rs_reg: in  STD_LOGIC_VECTOR(15 downto 0);

           idex_regwrite: in STD_LOGIC_VECTOR(2 downto 0);
           idex_regdist: in STD_LOGIC_VECTOR(2 downto 0);
           exmem_regwrite: in STD_LOGIC_VECTOR(2 downto 0);
           exmem_regdist: in STD_LOGIC_VECTOR(2 downto 0);

           instruction: in  STD_LOGIC_VECTOR(15 downto 0);
           t: in STD_LOGIC;
           pc_src: out  STD_LOGIC_VECTOR(1 downto 0);
           jr_reg: out  STD_LOGIC_VECTOR(15 downto 0));	
end equal_unit;

architecture Behavioral of equal_unit is

begin
  process (instruction, idex_regdist, idex_regwrite, exmem_regdist, exmem_regwrite, rs_alu, rs_mem, rs_reg)
  begin
    if (instruction(15 downto 11) = "11101" and (instruction(7 downto 5) = "000" or instruction(7 downto 5) = "110")) then
      if (idex_regwrite = "001" and idex_regdist = instruction(10 downto 8)) then
        jr_reg <= rs_alu;
      elsif exmem_regwrite = "001" and exmem_regdist = instruction(10 downto 8) then 
        jr_reg <= rs_mem;
      else 
        jr_reg <= rs_reg;
      end if;
    end if;
  end process;

	process (instruction, rs_reg, rs_mem, rs_alu, t) 
	begin
	  case instruction(15 downto 11) is
        when "00010" => -- B
          pc_src <= "01";
        when "00100" => --BEQZ
          if (rs_reg = "0000000000000000") then
            pc_src <= "01";
          else 
            pc_src <= "00";
          end if;
        when "01100" =>  -- BTNEZ????~!!!!!!!!!
          case( instruction(10 downto 8)) is 
            when "000" =>  
              if (t = '1') then
                pc_src <= "01";
              else 
                pc_src <= "00";
              end if;
            when "001" => --BTEQZ
              if (t = '0') then
                pc_src <= "01";
              else 
                pc_src <= "00";
              end if;
            when others => 
              pc_src <="00";
          end case ;
        when "11101" =>
          case( instruction(7 downto 5) ) is 
            when "000" =>  
              pc_src <= "10";
            when "110" =>
              pc_src <= "10";
            when others => 
              pc_src <="00";
            end case ;
        when others => 
          pc_src <= "00";
    end case;
  end process;
end Behavioral;

