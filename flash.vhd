library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity flash is
	port(
		clk : in std_logic;
		rst : in std_logic;

		sram2_addr : out std_logic_vector(17 downto 0); 	--sram2地址总线
		sram2_data : out std_logic_vector(15 downto 0);--sram2数据总线
				
		sram2_en : out std_logic;		--sram2使能，='1'禁止，永远等于'0'
		sram2_oe : out std_logic;		--sram2读使能，='1'禁止
		sram2_we : out std_logic;		--sram2写使能，='1'禁止
		
		flash_finished : out std_logic := '0';
		
		--Flash
		flash_addr : out std_logic_vector(22 downto 0);		--flash地址线
		flash_data : inout std_logic_vector(15 downto 0);	--flash数据线
		
		flash_byte : out std_logic := '1';	--flash操作模式，常置'1'
		flash_vpen : out std_logic := '1';	--flash写保护，常置'1'
		flash_rp : out std_logic := '1';		--'1'表示flash工作，常置'1'
		flash_ce : out std_logic:= '0';		--flash使能
		flash_oe : out std_logic := '1';		--flash读使能，'0'有效，每次读操作后置'1'
		flash_we : out std_logic := '1'		--flash写使能
		);
end flash;

architecture bhv of flash is

	signal flash_finished_signal : std_logic := '0';
	signal flash_state : std_logic_vector(2 downto 0) := "001";
	signal current_addr : std_logic_vector(15 downto 0) := (others => '0');	--flash当前要读的地址
	
begin
	process(clk, rst)
	begin
	
		if (rst = '0') then
			sram2_oe <= '1';
			sram2_we <= '1';
			sram2_addr <= (others => '0');
			flash_state <= "001";
			flash_finished_signal <= '0';
			current_addr <= (others => '0');
			
		elsif (clk'event and clk = '1') then 
			if (flash_finished_signal = '1') then			--从flash载入kernel指令到sram2已完成
				flash_byte <= '1';
				flash_vpen <= '1';
				flash_rp <= '1';
				flash_ce <= '1';	--禁止flash
				sram2_en <= '0';
				sram2_addr(17 downto 16) <= "00";
				sram2_oe <= '1';
				sram2_we <= '1';
				
			else				--从flash载入kernel指令到sram2尚未完成，则继续载入
				case flash_state is
					when "001" =>		--WE置0
						sram2_en <= '0';
						sram2_we <= '0';
						sram2_oe <= '1';
						
						flash_we <= '0';
						flash_oe <= '1';
							
						flash_byte <= '1';
						flash_vpen <= '1';
						flash_rp <= '1';
						flash_ce <= '0';
							
						flash_state <= "010";
							
					when "010" =>
						flash_data <= x"00FF";
						flash_state <= "011";
							
					when "011" =>
						flash_we <= '1';
						flash_state <= "100";
							
					when "100" =>
						flash_addr <= "000000" & current_addr & '0';
						flash_data <= (others => 'Z');
						flash_oe <= '0';
						flash_state <= "101";							
					when "101" =>
						flash_oe <= '1';
						sram2_we <= '0';
						sram2_addr <= "00" & current_addr;
						sram2_data <= flash_data;	
						flash_state <= "110";
						
					when "110" =>
						sram2_we <= '1';
						current_addr <= current_addr + '1';
						flash_state <= "001";
						
					when others =>
						flash_state <= "001";
						
				end case;
					
				if (current_addr > x"0224") then
					flash_byte <= '1';
					flash_vpen <= '1';
					flash_rp <= '1';
					flash_ce <= '1';	--禁止flash
					sram2_en <= '0';
					sram2_addr(17 downto 16) <= "00";
					sram2_oe <= '1';
					sram2_we <= '1';
					flash_finished_signal <= '1';
					sram2_data <= (others => 'Z');
				end if;
			
			end if;	--flash finished or not
			
		end if;	--rst/clk_raise
		
	end process;
	
	flash_finished <= flash_finished_signal;
	
	
end bhv;