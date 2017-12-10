----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:46:54 12/09/2017 
-- Design Name: 
-- Module Name:    my_dcm - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_dcm is
    Port ( clk200 : in  STD_LOGIC;
           clkout : out  STD_LOGIC);
end my_dcm;

architecture Behavioral of my_dcm is

signal count: std_logic_vector(1 downto 0):="00";
signal clk: std_logic:='0';
begin
clkout <= clk;
	process(clk200)
	begin
	if clk200'event and clk200 = '1' then
		if (clk = '1') then
			if count = "10" then 
				clk <= not clk;
				count <= "00";
			else
				count <= count + 1;
			end if;
		else 
			if count = "11" then 
				clk <= not clk;
				count <= "00";
			else
				count <= count + 1;
			end if;
		end if;
	end if;
	end process;
end Behavioral;

