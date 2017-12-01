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

signal real_object_regData: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal real_object_TData: STD_LOGIC := '0';


begin
  process (instruction, idex_regdist, idex_regwrite, exmem_regdist, exmem_regwrite, rs_alu, rs_mem, rs_reg)
  begin
    --if (instruction(15 downto 11) = "11101" and (instruction(7 downto 5) = "000" or instruction(7 downto 5) = "110")) then
      if (idex_regwrite = "001" and idex_regdist = instruction(10 downto 8)) then
        jr_reg <= rs_alu;
        real_object_regData <= rs_alu;
      elsif exmem_regwrite = "001" and exmem_regdist = instruction(10 downto 8) then 
        jr_reg <= rs_mem;
        real_object_regData <= rs_mem;
      else 
        jr_reg <= rs_reg;
        real_object_regData <= rs_reg;
      end if;
  end process;

  process (exmem_regwrite, idex_regwrite, exmem_regdist, idex_regdist, t)
  begin
    if (idex_regwrite = "011") then
        real_object_TData <= rs_alu(0);
      elsif exmem_regwrite = "011" then 
        real_object_TData <= rs_mem(0);
      else 
        real_object_TData <= t;
    end if;

  end process;
	process (instruction, real_object_TData, real_object_regData) 
	begin
	  case instruction(15 downto 11) is
        when "00010" => -- B
          pc_src <= "01";
        when "00100" => --BEQZ
          if (real_object_regData = "0000000000000000") then
            pc_src <= "01";
          else 
            pc_src <= "00";
          end if;
        when "00101" => --BNEZ
          if (real_object_regData = "0000000000000000") then
            pc_src <= "00";
          else 
            pc_src <= "01";
          end if;
        when "01100" =>  -- BTNEZ????~!!!!!!!!!
          case( instruction(10 downto 8)) is 
            when "001" =>  
              if (real_object_TData = '1') then
                pc_src <= "01";
              else 
                pc_src <= "00";
              end if;
            when "000" => --BTEQZ
              if (real_object_TData = '0') then
                pc_src <= "01";
              else 
                pc_src <= "00";
              end if;
            when others => 
              pc_src <="00";
          end case ;
        when "11101" =>
          if (instruction(4 downto 0) = "00000") then
            case( instruction(7 downto 5) ) is 
              when "000" =>  
                pc_src <= "10";
              when "110" =>
                pc_src <= "10";
              when others => 
                pc_src <="00";
              end case ;
          else 
            pc_src <= "00";
          end if;
        when others => 
          pc_src <= "00";
    end case;
  end process;
end Behavioral;

