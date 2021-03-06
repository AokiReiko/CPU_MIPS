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

package my_components is
	
	component GRam
	PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
	end component;
	
	component flash
	port(
		clk : in std_logic;
		rst : in std_logic;

		sram2_addr : out std_logic_vector(17 downto 0); 	
		sram2_data : out std_logic_vector(15 downto 0);
				
		sram2_en : out std_logic;		
		sram2_oe : out std_logic;		
		sram2_we : out std_logic;		
		
		flash_finished : out std_logic;
		
		--Flash
		flash_addr : out std_logic_vector(22 downto 0);		
		flash_data : inout std_logic_vector(15 downto 0);	
		
		flash_byte : out std_logic;	
		flash_vpen : out std_logic;	
		flash_rp : out std_logic;		
		flash_ce : out std_logic;		
		flash_oe : out std_logic;		
		flash_we : out std_logic		
	);
	end component;
	
	component vga 
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
	end component;
	
  component ps2_keyboard_to_ascii IS
  GENERIC(
      clk_freq                  : INTEGER;  --system clock frequency in Hz
      ps2_debounce_counter_size : INTEGER);  --set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)
  PORT(
      clk        : IN  STD_LOGIC;                     --system clock input
      ps2_clk    : IN  STD_LOGIC;                     --clock signal from PS2 keyboard
      ps2_data   : IN  STD_LOGIC;                     --data signal from PS2 keyboard
      ascii_new  : OUT STD_LOGIC;                     --output flag indicating new ASCII value
      ascii_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)); --ASCII value
  end component;

	component IFID_Reg is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           IF_Flush: in  STD_LOGIC;
           IFIDWrite: in  STD_LOGIC;

           PCNext: in  STD_LOGIC_VECTOR(15 downto 0);
           Instruction: in  STD_LOGIC_VECTOR(15 downto 0);
           PCNext_out: out  STD_LOGIC_VECTOR(15 downto 0);
           Instruction_out: out  STD_LOGIC_VECTOR(15 downto 0));	
	end component;

	component registers is
    Port ( clk : in STD_LOGIC;
           RegWrite : in STD_LOGIC_VECTOR (2 downto 0):= (others => '0');
           RegA: in  STD_LOGIC_VECTOR(3 downto 0);
           RegB: in  STD_LOGIC_VECTOR(2 downto 0);
           RegW: in  STD_LOGIC_VECTOR(2 downto 0);
           WRData: in  STD_LOGIC_VECTOR(15 downto 0);
           outA: out  STD_LOGIC_VECTOR(15 downto 0);
           outB: out  STD_LOGIC_VECTOR(15 downto 0);
           outT: out STD_LOGIC);	
	end component;
	component PC is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           int  : in  STD_LOGIC;
           PCWrite : in  STD_LOGIC;
           Mux_in: in  STD_LOGIC_VECTOR(15 downto 0);
           PC_out: out  STD_LOGIC_VECTOR(15 downto 0));	
	end component;
	
	component Muxpc is
    Port ( PCSrc : in  STD_LOGIC_VECTOR(1 downto 0);
           PCNext: in  STD_LOGIC_VECTOR(15 downto 0);
           PCOffset: in  STD_LOGIC_VECTOR(15 downto 0);
           PCJR: in STD_LOGIC_VECTOR(15 downto 0);
           pc_out: out  STD_LOGIC_VECTOR(15 downto 0));	
	end component;
	component Muxb is
    Port ( reg: in  STD_LOGIC_VECTOR(15 downto 0);
    	   alu: in  STD_LOGIC_VECTOR(15 downto 0);
    	   mem: in  STD_LOGIC_VECTOR(15 downto 0);
    	   immediate: in  STD_LOGIC_VECTOR(15 downto 0);
    	   alu_src: in  STD_LOGIC;
    	   forward: in  STD_LOGIC_VECTOR(1 downto 0);
         reg_out: out  STD_LOGIC_VECTOR(15 downto 0);
           src_out: out  STD_LOGIC_VECTOR(15 downto 0));	
	end component;
	component Muxa is
    Port ( reg: in  STD_LOGIC_VECTOR(15 downto 0);
    	   alu: in  STD_LOGIC_VECTOR(15 downto 0);
    	   mem: in  STD_LOGIC_VECTOR(15 downto 0);
    	   forward: in  STD_LOGIC_VECTOR(1 downto 0);
           src_out: out  STD_LOGIC_VECTOR(15 downto 0));	
	end component;
	component MEMWB_Reg is
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
	end component;
	component mymemory is
    Port ( 
         clk: in STD_LOGIC;
         oe_1: out STD_LOGIC;
    	   we_1: out STD_LOGIC;
    	   en_1: out STD_LOGIC;
    	   oe_2: out STD_LOGIC;
    	   we_2: out STD_LOGIC;
    	   en_2: out STD_LOGIC;
    	   addr_1: out STD_LOGIC_VECTOR(17 downto 0);
    	   addr_2: out STD_LOGIC_VECTOR(17 downto 0);
    	   data_1: inout STD_LOGIC_VECTOR(15 downto 0);
    	   data_2: inout STD_LOGIC_VECTOR(15 downto 0);

			wrn: out STD_LOGIC;
    	   rdn: out STD_LOGIC;
			tbre: in STD_LOGIC;
    	   tsre: in STD_LOGIC;
			data_ready: in STD_LOGIC;

      ascii_new  : in STD_LOGIC;     --flag indicating new ASCII value
      ascii_code : in STD_LOGIC_VECTOR(6 DOWNTO 0);  --ASCII value
      
      vga_addr : out STD_LOGIC_VECTOR(15 downto 0);
      vga_data : out STD_LOGIC_VECTOR(15 downto 0);
      vga_enable : out STD_LOGIC;
      vga_led: out STD_LOGIC;

    	   memread: in STD_LOGIC;
    	   memwrite: in STD_LOGIC;

    	   addr_in: in STD_LOGIC_VECTOR(15 downto 0);
    	   data_in: in STD_LOGIC_VECTOR(15 downto 0);
			pc_addr:in STD_LOGIC_VECTOR(15 downto 0);
			if_nop: out STD_LOGIC);	
	end component;
	
	component IDEX_Reg is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           
           in_ALUOp: in STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
		   in_ALUsrc: in STD_LOGIC := '0';
		   in_RegDist: in STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   in_MemRead: in STD_LOGIC := '0';
		   in_MemWrite: in STD_LOGIC := '0';
		   in_RegWrite: in STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   in_MemtoReg: in STD_LOGIC := '0';
		   in_immediate: in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   in_rega: in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   in_regb: in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   in_rs: in STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
		   in_rt: in STD_LOGIC_VECTOR (2 downto 0) := (others => '0');

		   out_ALUOp: out STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
		   out_ALUsrc: out STD_LOGIC := '0';
		   out_RegDist: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   out_MemRead: out STD_LOGIC := '0';
		   out_MemWrite: out STD_LOGIC := '0';
		   out_RegWrite: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   out_MemtoReg: out STD_LOGIC := '0';
		   out_immediate: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   out_rega: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   out_regb: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   out_rs: out STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
		   out_rt: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0'));
	end component;
	component hazard_unit is
    Port ( idex_memread: in  STD_LOGIC;
          alu_src: in STD_LOGIC;
          rega: in STD_LOGIC_VECTOR(3 downto 0);
          idex_rt: in  STD_LOGIC_VECTOR(2 downto 0); --regdist
          ifid_rt: in  STD_LOGIC_VECTOR(2 downto 0);

          ifid_write: out  STD_LOGIC;
          pc_write: out  STD_LOGIC;--�          
			 ctrl_clear: out STD_LOGIC);	
	end component;
	component EXMEM_Reg is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           
           in_RegDist: in STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   in_MemRead: in STD_LOGIC := '0';
		   in_MemWrite: in STD_LOGIC := '0';
		   in_RegWrite: in STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   in_MemtoReg: in STD_LOGIC := '0';
		   in_regdata: in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   in_alu_data: in std_logic_vector(15 downto 0);
			
		   out_alu_data: out std_logic_vector(15 downto 0);
		   out_RegDist: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   out_MemRead: out STD_LOGIC := '0';
		   out_MemWrite: out STD_LOGIC := '0';
		   out_RegWrite: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   out_MemtoReg: out STD_LOGIC := '0';
		   out_regdata: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0'));	  
	end component;
	component equal_unit is
    Port ( rs_alu: in  STD_LOGIC_VECTOR(15 downto 0);
           rs_mem: in  STD_LOGIC_VECTOR(15 downto 0);
           rs_reg: in  STD_LOGIC_VECTOR(15 downto 0);

           idex_regwrite: in STD_LOGIC_VECTOR(2 downto 0);
           idex_regdist: in STD_LOGIC_VECTOR(2 downto 0);
           exmem_regwrite: in STD_LOGIC_VECTOR(2 downto 0);
           exmem_regdist: in STD_LOGIC_VECTOR(2 downto 0);

           instruction: in  STD_LOGIC_VECTOR(15 downto 0);
           t: in STD_LOGIC;
           pc_src: out  STD_LOGIC_VECTOR(1 downto 0);
           jr_reg: out  STD_LOGIC_VECTOR(15 downto 0));	
	end component;
	component ctrl_unit is
    Port ( instruction: in  STD_LOGIC_VECTOR(15 downto 0);
    	   pc: in  STD_LOGIC_VECTOR(15 downto 0);

    	   ALUOp: out STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
		   ALUsrc: out STD_LOGIC := '0';
		   RegDist: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   MemRead: out STD_LOGIC := '0';
		   MemWrite: out STD_LOGIC := '0'; 
		   RegWrite: out STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		   MemtoReg: out STD_LOGIC := '0';
		   immediate: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		   rega: out STD_LOGIC_VECTOR (3 downto 0) := (others => '0'));	
	end component;
	component bypass_unit is
    Port ( rs: in  STD_LOGIC_VECTOR(3 downto 0);
         alusrc: in STD_LOGIC;
    	   rt: in  STD_LOGIC_VECTOR(2 downto 0);
    	   exmem_rd: in  STD_LOGIC_VECTOR(2 downto 0);
    	   exmem_regwrite: in  STD_LOGIC_VECTOR(2 downto 0);
    	   memwb_rd: in  STD_LOGIC_VECTOR(2 downto 0);
    	   memwb_regwrite: in  STD_LOGIC_VECTOR(2 downto 0);
         forwarda: out  STD_LOGIC_VECTOR(1 downto 0);
         forwardb: out  STD_LOGIC_VECTOR(1 downto 0));	
	end component;
	component Adder is
    Port ( OpranA: in  STD_LOGIC_VECTOR(15 downto 0);
           OpranB: in  STD_LOGIC_VECTOR(15 downto 0);
           res: out  STD_LOGIC_VECTOR(15 downto 0));	
	end component;
	component ALU is
    Port ( alu_op: in  STD_LOGIC_VECTOR(3 downto 0);
           input_a: in  STD_LOGIC_VECTOR(15 downto 0);
           input_b: in  STD_LOGIC_VECTOR(15 downto 0);
           fout: out  STD_LOGIC_VECTOR(15 downto 0));	
	end component;
  component Muxc is
    Port ( data_1: in  STD_LOGIC_VECTOR(15 downto 0);
         data_2: in  STD_LOGIC_VECTOR(15 downto 0);
         addr: in  STD_LOGIC_VECTOR(15 downto 0);
           data_out: out  STD_LOGIC_VECTOR(15 downto 0)); 
end component;
COMPONENT dcm is
  PORT(
    CLKIN_IN : IN std_logic;          
    CLKFX_OUT : OUT std_logic;
    CLK0_OUT : OUT std_logic
    );
END COMPONENT;
  component my_dcm is
    Port ( clk200 : in  STD_LOGIC;
           clkout : out  STD_LOGIC);
end component;

end my_components;



	
