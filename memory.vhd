library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mymemory is
    Port ( oe_1: out STD_LOGIC;
    	   we_1: out STD_LOGIC;
    	   en_1: out STD_LOGIC;
    	   oe_2: out STD_LOGIC;
    	   we_2: out STD_LOGIC;
    	   en_2: out STD_LOGIC;
			
			wrn: out STD_LOGIC;
    	   rdn: out STD_LOGIC;
			tbre: in STD_LOGIC;
    	   tsre: in STD_LOGIC;
			data_ready: in STD_LOGIC;
    	   addr_1: out STD_LOGIC_VECTOR(17 downto 0);
    	   addr_2: out STD_LOGIC_VECTOR(17 downto 0);
    	   data_1: inout STD_LOGIC_VECTOR(15 downto 0);
    	   data_2: inout STD_LOGIC_VECTOR(15 downto 0);

    	   memread: in STD_LOGIC;
    	   memwrite: in STD_LOGIC;

    	   addr_in: in STD_LOGIC_VECTOR(15 downto 0);
    	   data_in: in STD_LOGIC_VECTOR(15 downto 0);
			pc_addr: in STD_LOGIC_VECTOR(15 downto 0);
			
			if_nop: out STD_LOGIC);	
end mymemory;

architecture Behavioral of mymemory is
signal BF01: std_logic_vector(15 downto 0);
begin
	BF01 <= "00000000000000" & data_ready & (tbre and tsre);
	process(memread, memwrite, addr_in, data_in)
	begin
		if (memread = '1') then 
			if (addr_in > x"7999") then -- ram1
				oe_1 <= '0';
				we_1 <= '1';
				
				oe_2 <= '0';
				we_2 <= '1';
				en_2 <= '0';
				addr_1 <= "00" & addr_in;
				addr_2 <= "00" & pc_addr;
				data_2 <= (others => 'Z');
				if_nop <= '0';
			end if;
		elsif memwrite = '1' then
			if (addr_in > x"7fff") then -- ram1
				oe_1 <= '1';
				we_1 <= '0';				
				oe_2 <= '0';
				we_2 <= '1';
				en_2 <= '0';
				addr_1 <= "00" & addr_in;
				addr_2 <= "00" & pc_addr;
				data_1 <= data_in;
				data_2 <= (others => 'Z');
				if_nop <= '0';
			else -- ram2
				oe_1 <= '1';
				we_1 <= '1';				
				oe_2 <= '1';
				we_2 <= '0';
				en_2 <= '0';
				addr_1 <= (others => '0');
				addr_2 <= "00" & addr_in;
				data_1 <= (others => 'Z');
				data_2 <= data_in;
				if_nop <= '1';	
			end if;
		end if;
	end process;
	
	process(memwrite, memread, addr_in, data_in)
	begin
		if (memread = '1') then
			case (addr_in) is
				when x"BF01" =>
					data_1 <= BF01;
					wrn <= '1';
					rdn <= '1';
					en_1 <= '1';
				when x"BF00" =>
					data_1 <= (others => 'Z');
					wrn <= '1';
					rdn <= '0';
					en_1 <= '1';
				when others =>
					data_1 <= (others => 'Z');
					en_1 <= '0';
					wrn <= '1';
					rdn <= '1';
				end case;
			elsif (memwrite = '1') then
				case addr_in is
				when x"BF01" =>
					data_1 <= BF01;
					wrn <= '1';
					rdn <= '1';
					en_1 <= '1';
				when x"BF00" =>
					data_1 <= data_in;
					wrn <= '0';
					rdn <= '1';
					en_1 <= '1';
				when others =>
					data_1 <= data_in;
					wrn <= '1';
					rdn <= '1';
					en_1 <= '0';
			end case;
		end if;
	end process;
end Behavioral;

