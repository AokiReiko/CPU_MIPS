----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:30:27 11/28/2017 
-- Design Name: 
-- Module Name:    vga - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.std_logic_unsigned.all;
use	ieee.std_logic_arith.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga is
    Port ( clk50 : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           write_enable : in STD_LOGIC;
			  data : in std_logic_vector(15 downto 0);
			  adress : in std_logic_vector(15 downto 0);
           hs : out  STD_LOGIC;
           vs : out  STD_LOGIC;
           r : out  STD_LOGIC_VECTOR (2 downto 0);
           g : out  STD_LOGIC_VECTOR (2 downto 0);
           b : out  STD_LOGIC_VECTOR (2 downto 0)
			  );
end vga;

architecture Behavioral of vga is
	signal r1,g1,b1   : std_logic_vector(2 downto 0);					
	signal hs1,vs1    : std_logic := '0';				
	signal vector_x : std_logic_vector(9 downto 0):= (others => '0');
	signal vector_y : std_logic_vector(9 downto 0):= (others => '0');
	signal clk : std_logic:='0';
	signal vout : std_logic := '0'; 
	
	signal rgb : std_logic_vector(8 downto 0);
	
	--signal data0 : std_logic_vector(559 downto 0):= (6=>'0',5=>'1',4=>'1',3=>'0',2=>'1',1=>'1',0=>'0',others => '0');
	component vga_char
		port( clk50 : in std_logic;
			  
			  write_enable : in STD_LOGIC;
			  data : in std_logic_vector(15 downto 0);
			  adress : in std_logic_vector(15 downto 0);
			  
			  pos_x : in STD_LOGIC_VECTOR(9 downto 0);
			  pos_y : in std_logic_vector(9 downto 0);
           vout : out  STD_LOGIC;
			  rgb : out std_logic_vector(8 downto 0));
	end component;
begin
	
	char: vga_char
	port map(
		clk50 => clk50,
		write_enable => write_enable,
	   data => data,
	   adress => adress,
		pos_x => vector_x,
	   pos_y => vector_y,
      vout =>vout, 
		rgb => rgb
	);
	
	process (clk50)
	begin
	   if (clk50'event and clk50='1') then 
             clk <= not clk;
				-- data <= data0;
		end if;
	end process;
	
	process(clk,reset)
	 begin
	  	if reset='0' then
	   		vector_x <= (others=>'0');
	  	elsif clk'event and clk='1' then
	   		if vector_x=799 then
					vector_x <= (others=>'0');
	   		else
					vector_x <= vector_x + 1;
	   		end if;
				
	  	end if;
	end process;
	
	process(clk,reset)
	 begin
	  	if reset='0' then
	   		vector_y <= (others=>'0');
			--	yy <= (others=>'0');
	  	elsif clk'event and clk='1' then
	  		if vector_x=799 then
				if vector_y=524 then
					vector_y <= (others=>'0');
			--		yy <= (others=>'0');
				else
					vector_y <= vector_y + 1;
			--		yy <= vector_y + 1;
				end if;	
			end if;
	   end if;
		
	end process;
	
	process(clk,reset)
	 begin
		  if reset='0' then
				hs1 <= '1';
		  elsif clk'event and clk='1' then
		   	if vector_x>=656 and vector_x<752 then
					hs1 <= '0';
		   	else
					hs1 <= '1';
		   	end if;
		  end if;
	end process;
	
	process(clk,reset)
	begin
	  	if reset='0' then
	   		vs1 <= '1';
	  	elsif clk'event and clk='1' then
	   		if vector_y>=490 and vector_y<492 then
					vs1 <= '0';
	   		else
					vs1 <= '1';
	   		end if;
	  	end if;
	end process;
	
	process(clk,reset)
	begin
	  	if reset='0' then
	   	hs <= '1';
	  	elsif clk'event and clk='1' then
	   	hs <=  hs1;
	  	end if;
	end process;
	
	process(clk,reset)
	begin
		if reset='0' then
	   		vs <= '1';
	  	elsif clk'event and clk='1' then
	   		vs <=  vs1;
	  	end if;
	end process;

	process(reset,clk,vector_x,vector_y)
	begin
		if reset='0' then
			      r1 <= "000";
					g1	<= "000"; 
					b1	<= "000";
		elsif(clk'event and clk='1')then
			if vector_x > 639 or vector_y > 479 then 
					r1 <= "000";
					g1	<= "000";
					b1	<= "000";
			else
				if vout = '1' then
					r1  <= rgb(8 downto 6);
					g1	<= rgb(5 downto 3);
					b1	<= rgb(2 downto 0);
				else
					r1  <= "000";
					g1	<= "000";
					b1	<= "000";
				end if ;
			end if;
		end if;		 
	end process; 

	process (hs1, vs1, r1, g1, b1)
	begin
		if hs1 = '1' and vs1 = '1' then
			--r <= "000";
			--g <= "000";
			--b <= "111";
			r	<= r1;
			g	<= g1;
			b	<= b1;
		else
			r	<= (others => '0');
			g	<= (others => '0');
			b	<= (others => '0');
		end if;
	end process;

end Behavioral;

