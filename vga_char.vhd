----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:18:16 11/28/2017 
-- Design Name: 
-- Module Name:    vga_char - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.constants.all;
use work.my_components.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_char is
    Port ( 
			  clk50 : in std_logic;
			  
			  write_enable : in STD_LOGIC;
			  data : in std_logic_vector(15 downto 0);
			  adress : in std_logic_vector(15 downto 0);
			  
			  pos_x : in STD_LOGIC_VECTOR(9 downto 0);
			  pos_y : in std_logic_vector(9 downto 0);
           vout : out  STD_LOGIC;
			  rgb : out std_logic_vector(8 downto 0)
		--	  wordout : out std_logic_vector (5 downto 0)
		);
end vga_char;

architecture Behavioral of vga_char is
	--GRam
	
    signal addr_a :  STD_LOGIC_VECTOR(11 DOWNTO 0);
    signal din_a :  STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '1');
    signal dout_a :  STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal addr_b :  STD_LOGIC_VECTOR(11 DOWNTO 0);
    signal din_b :  STD_LOGIC_VECTOR(15 DOWNTO 0);
	 signal dout_b :  STD_LOGIC_VECTOR(15 DOWNTO 0);
	 
	 signal delta_x : integer range 0 to 8 := 0;
	 signal delta_y : integer range 0 to 16 := 0;
	
begin
	rgb <= dout_b(15 downto 7);
	u0: GRam 
	port map(
	 clka => clk50,
    wea => "1",
    addra => addr_a,
    dina => din_a,
    douta => dout_a,
    clkb => clk50,
    web => "0",
    addrb => addr_b,
    dinb => (others => 'Z'),
    doutb => dout_b
	);
	
	process (write_enable, data, adress)
		variable temp :  STD_LOGIC_VECTOR(15 DOWNTO 0);
		--variable bgn : integer range 0 to 200:= 0;
	begin
		if(write_enable'event and write_enable = '0' and "0"&adress >= "0"& x"F6A0") then
			din_a <= data;
			temp := adress - x"F6A0";
			addr_a <= temp(11 downto 0);
			--bgn := conv_integer("0"&adress - "01111111110110000"); -- FFB0
			--data0(bgn*7+6 downto bgn*7) <= data(6 downto 0);
		end if;
	end process;
	
	process(pos_x, pos_y)
		variable x : integer range 0 to 80 := 0;
		variable y : integer range 0 to 30:= 0;
		variable result : integer range 0 to 2400:= 0;
	begin
		x := conv_integer(to_stdlogicvector(to_bitvector(pos_x) srl 3));
		y := conv_integer(to_stdlogicvector(to_bitvector(pos_y) srl 4));
		delta_y <= conv_integer(pos_y) - y * 16;
		delta_x <= conv_integer(pos_x) - x * 8;
		
		result := y * 80 + x;
		addr_b <=  conv_std_logic_vector(result, 12);
	end process;
	
	
	process(delta_x, delta_y)
		variable Char : STD_LOGIC_VECTOR(127 downto 0);
	begin
		case dout_b(6 downto 0) is
			when "0110000" => Char := Char_0;
			when "0110001" => Char := Char_1;
			when "0110010" => Char := Char_2;
			when "0110011" => Char := Char_3;
			when "0110100" => Char := Char_4;
			when "0110101" => Char := Char_5;
			when "0110110" => Char := Char_6;
			when "0110111" => Char := Char_7;
			when "0111000" => Char := Char_8;
			when "0111001" => Char := Char_9;
			when "1100001" => Char := Char_a;
			when "1100010" => Char := Char_b;
			when "1100011" => Char := Char_c;
			when "1100100" => Char := Char_d;
			when "1100101" => Char := Char_e;
			when "1100110" => Char := Char_f;
			when "1100111" => Char := Char_g;
			when "1101000" => Char := Char_h;
			when "1101001" => Char := Char_i;
			when "1101010" => Char := Char_j;
			when "1101011" => Char := Char_k;
			when "1101100" => Char := Char_l;
			when "1101101" => Char := Char_m;
			when "1101110" => Char := Char_n;
			when "1101111" => Char := Char_o;
			when "1110000" => Char := Char_p;
			when "1110001" => Char := Char_q;
			when "1110010" => Char := Char_r;
			when "1110011" => Char := Char_s;
			when "1110100" => Char := Char_t;
			when "1110101" => Char := Char_u;
			when "1110110" => Char := Char_v;
			when "1110111" => Char := Char_w;
			when "1111000" => Char := Char_x;
			when "1111001" => Char := Char_y;
			when "1111010" => Char := Char_z;
			when others => Char := Char_space;
		end case;
		
		vout <= Char(127-delta_y*8-delta_x);
	end process;

end Behavioral;

