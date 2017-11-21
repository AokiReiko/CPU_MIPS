library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MEMWB_Reg is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           
           in_RegDist: in STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   in_RegWrite: in STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   in_MemtoReg: in STD_LOGIC := '0';
		   in_aludata: in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   in_memdata: in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		  
		   
		   out_RegDist: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   out_RegWrite: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
  		   out_memdata: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

		   out_data: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0'));
		  
		  
end MEMWB_Reg;

architecture Behavioral of MEMWB_Reg is

begin

	process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			out_RegDist <= in_RegDist;
			temp_MemtoReg <= in_MemtoReg;
			if (in_MemtoReg = '1') then
				out_data <= in_memdata;
			else 
				out_data <= in_aludata;
			end if;
			out_memdata <= in_memdata;
			out_RegWrite <= in_RegWrite;
		end if;	
	end process;
	
end Behavioral;

