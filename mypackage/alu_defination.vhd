--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package operation is

	constant op_add : std_logic_vector(3 downto 0) := "0000";
	constant op_sub : std_logic_vector(3 downto 0) := "0001";
	constant op_and : std_logic_vector(3 downto 0) := "0010";
	constant op_or : std_logic_vector(3 downto 0) := "0011";
	constant op_xor : std_logic_vector(3 downto 0) := "0100";
	constant op_not : std_logic_vector(3 downto 0) := "0101";
	constant op_sll : std_logic_vector(3 downto 0) := "0110";
	constant op_srl : std_logic_vector(3 downto 0) := "0111";
	constant op_sra : std_logic_vector(3 downto 0) := "1000";
	constant op_rol : std_logic_vector(3 downto 0) := "1001";
	constant op_equal: std_logic_vector(3 downto 0) := "1010"
	constant op_nothing: std_logic_vector(3 downto 0) := "1011";

end operation;
