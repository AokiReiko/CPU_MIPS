library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library mypackage;
use mypackage.alu_defination.all;

entity ALU is
    Port ( alu_op: in  STD_LOGIC_VECTOR(3 downto 0);
           input_a: in  STD_LOGIC_VECTOR(15 downto 0);
           input_b: in  STD_LOGIC_VECTOR(15 downto 0);
           fout: out  STD_LOGIC_VECTOR(15 downto 0));	
end ALU;

architecture Behavioral of ALU is
begin
	process (alu_op, srcA, srcB) 
	begin

		case alu_op is
			when op_add => fout <= input_a + input_b;
			when op_sub => fout <= input_a - input_b;
			when op_and => fout <= input_a and input_b;
			when op_or => fout <= input_a or input_b;
			when op_xor => fout <= input_a xor input_b;
			when op_not => fout <= not input_a;
			when op_sll => fout <= to_stdlogicvector(to_bitvector(input_a) sll conv_integer(input_b));
			when op_srl => fout <= to_stdlogicvector(to_bitvector(input_a) srl conv_integer(input_b));
			when op_sra => fout <= to_stdlogicvector(to_bitvector(input_a) sra conv_integer(input_b));
			when op_rol => fout <= to_stdlogicvector(to_bitvector(input_a) rol conv_integer(input_b));
			when op_equal => 
				if (input_a = input_b) then
					fout <= (others => '0');
				else 
					fout <= (others => '1');
				end if;
			when others => fout <= (others => '0');
			when op_nothing => fout <= (others => '0');
		end case;
	end process;
end Behavioral;

