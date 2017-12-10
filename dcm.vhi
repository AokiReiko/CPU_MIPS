
-- VHDL Instantiation Created from source file dcm.vhd -- 15:57:29 12/10/2017
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT dcm
	PORT(
		CLKIN_IN : IN std_logic;          
		CLKFX_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic
		);
	END COMPONENT;

	Inst_dcm: dcm PORT MAP(
		CLKIN_IN => ,
		CLKFX_OUT => ,
		CLK0_OUT => 
	);


