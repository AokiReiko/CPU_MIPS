library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mymemory is
    Port ( clk: in STD_LOGIC;
    	   oe_1: out STD_LOGIC;
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

			-- from keyboard
			ascii_new  : in STD_LOGIC;     --flag indicating new ASCII value
			ascii_code : in STD_LOGIC_VECTOR(6 DOWNTO 0);  --ASCII value

			-- vga
			vga_addr : out STD_LOGIC_VECTOR(15 downto 0);
			vga_data : out STD_LOGIC_VECTOR(15 downto 0);
			vga_enable : out STD_LOGIC;
			vga_led : out STD_LOGIC;

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
signal BF01: std_logic_vector(15 downto 0); -- COM
signal BF0E: std_logic_vector(15 downto 0); -- keyboard ascii code
signal BF0F: std_logic_vector(15 downto 0); -- keyboard dataready
signal ascii_rising_edge : STD_LOGIC := '0'; -- whether keyboard data is new
begin
	BF01 <= "00000000000000" & data_ready & (tbre and tsre);
	BF0E <= "000000000" & ascii_code;
	BF0F <= "00000000000000" & ascii_new & ascii_rising_edge;

	process(ascii_new, memread, addr_in)
	begin
		if (memread = '1' and addr_in = x"BF0E") then
			ascii_rising_edge <= '0';
		elsif (ascii_new'event and ascii_new='1') then
			ascii_rising_edge <= '1';
		end if;
	end process;
	
	process(clk, memread, memwrite, addr_in)
	begin
		if (clk = '0') then 
			if (memread = '1') then
				oe_1 <= '0';
				we_1 <= '1';

				oe_2 <= '0';
				we_2 <= '1';
				en_2 <= '0';

				if (addr_in = x"BF0E" or addr_in = x"BF0F") then
					wrn <= '1';
					rdn <= '1';
					en_1 <= '1';
					vga_enable <= '1';
				else
					vga_enable <= '1';
					case (addr_in) is
						when x"BF01" =>
							wrn <= '1';
							rdn <= '1';
							en_1 <= '1';
						when x"BF00" =>
							wrn <= '1';
							rdn <= '0';
							en_1 <= '1';
						when others =>
							en_1 <= '0';
							wrn <= '1';
							rdn <= '1';
					end case;
				end if ;
			elsif (memwrite = '1') then
				if ( addr_in(15) = '1') then -- ram1
					oe_1 <= '1';
					we_1 <= '0';				
					oe_2 <= '0';
					we_2 <= '1';
					en_2 <= '0';
				else -- ram2
					oe_1 <= '1';
					we_1 <= '1';				
					oe_2 <= '1';
					we_2 <= '0';
					en_2 <= '0';
				end if;
				if ("0"&addr_in >= "0"& x"FFB0") then
					wrn <= '1';
					rdn <= '1';
					en_1 <= '1';
					vga_enable <= '0';
				else
					vga_enable <= '1';
					case addr_in is
						when x"BF01" =>
							wrn <= '1';
							rdn <= '1';
							en_1 <= '1';
						when x"BF00" =>
							wrn <= '0';
							rdn <= '1';
							en_1 <= '1';
						when others =>
							wrn <= '1';
							rdn <= '1';
							en_1 <= '0';
					end case;
				end if;
			else 
				oe_1 <= '1';
				we_1 <= '1';

				oe_2 <= '0';
				we_2 <= '1';
				en_2 <= '0';

				wrn <= '1';
				rdn <= '1';
				en_1 <= '0';
				vga_enable <= '1';

			end if; 
		else 
			oe_1 <= '1';
			we_1 <= '1';
			en_1 <= '0';

			oe_2 <= '0';
			we_2 <= '1';
			en_2 <= '0';

			wrn <= '1';
			rdn <= '1';
			vga_enable <= '1';

		end if;
	end process;
	process(memread, memwrite, addr_in, data_in, pc_addr)
	begin
		if (memread = '1' ) then 
			if addr_in(15) = '1' then-- ram1
				addr_1 <= "00" & addr_in;
				addr_2 <= "00" & pc_addr;
				data_2 <= (others => 'Z');
				if_nop <= '0';
			else 
				addr_1 <= (others => '0');
				addr_2 <= "00" & addr_in;
				data_2 <= (others => 'Z');
				if_nop <= '1';
			end if;
		elsif memwrite = '1' then
			if ( addr_in(15) = '1') then -- ram1
				addr_1 <= "00" & addr_in;
				addr_2 <= "00" & pc_addr;
				data_2 <= (others => 'Z');
				if_nop <= '0';
			else -- ram2
				addr_1 <= (others => '0');
				addr_2 <= "00" & addr_in;
				data_2 <= data_in;
				if_nop <= '1';	
			end if;
		else 
			addr_1 <= (others => '0');
			addr_2 <= "00" & pc_addr;
			data_2 <= (others => 'Z');
			if_nop <= '0';	
		end if;
	end process;
	
	process(memwrite, memread, addr_in, data_in, BF01, BF0E, BF0F, data_in)
	begin
		if (memread = '1') then
			case (addr_in) is
				when x"BF01" =>
					data_1 <= BF01;
				when x"BF00" =>
					data_1 <= (others => 'Z');
				when x"BF0E" =>
					data_1 <= BF0E;
				when x"BF0F" =>
					data_1 <= BF0F;
				when others =>
					data_1 <= (others => 'Z');
				end case;
		elsif (memwrite = '1') then
			if ( "0"&addr_in >= "0"& x"FFB0" ) then
				vga_data <= data_in;
				vga_addr <= addr_in;
				vga_led <= '1';
			else
				data_1 <= data_in;
			end if;
		else
			data_1 <= (others => 'Z');
		end if;
	end process;
end Behavioral;

