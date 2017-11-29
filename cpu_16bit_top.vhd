library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.my_components.ALL;
--ctrl_clear没有连接

entity cpu_16bit_top is
    Port ( clk : in  STD_LOGIC;
			  clk11: in std_logic;
			  clk50: in std_logic;
           rst : in  STD_LOGIC;
			  
           addr_1: out STD_LOGIC_VECTOR(17 downto 0);
    	   addr_2: out STD_LOGIC_VECTOR(17 downto 0);
    	   data_1: inout STD_LOGIC_VECTOR(15 downto 0);
    	   data_2: inout STD_LOGIC_VECTOR(15 downto 0);
			oe_1: out STD_LOGIC;
			we_1: out STD_LOGIC;
			en_1: out STD_LOGIC;
			oe_2: out STD_LOGIC;
			we_2: out STD_LOGIC;
			en_2: out STD_LOGIC;
			
			wrn: out STD_LOGIC;
    	   rdn: out STD_LOGIC;
			data_ready: in STD_LOGIC;
			tbre: in STD_LOGIC;
			tsre: in STD_LOGIC;
			
			sw: in std_logic_vector(15 downto 0);
			led: out std_logic_vector(15 downto 0);--instruction addr
			dyp0: out std_logic_vector(6 downto 0);
			dyp1: out std_logic_vector(6 downto 0)
			
			);	
end cpu_16bit_top;

architecture Behavioral of cpu_16bit_top is

signal my_clk: std_logic;
--信号命名规则: 前缀（产生信号的周期�部件名称+描述
--IF部分
signal IF_Mux_addr: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal IF_PC_addr: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal IF_Mem_inst: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal IF_Adder_res: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
--ID部分
signal IFID_inst: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal IFID_addr: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

signal ID_Reg_A: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal ID_Reg_B: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal ID_Reg_T: STD_LOGIC := '0';


signal ID_Ctrl_ALUOp: STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal ID_Ctrl_ALUsrc: STD_LOGIC := '0';
signal ID_Ctrl_RegDist: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal ID_Ctrl_MemRead: STD_LOGIC := '0';
signal ID_Ctrl_MemWrite: STD_LOGIC := '0';
signal ID_Ctrl_RegWrite: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal ID_Ctrl_MemtoReg: STD_LOGIC := '0';
signal ID_Ctrl_immediate: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal ID_Ctrl_rega: STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

signal ID_Adder_res: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

--EX部分	
--ALUOp
--ALUsrc
--RegDist
signal IDEX_ALUop: STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal IDEX_ALUsrc: STD_LOGIC := '0';
signal IDEX_MemRead: STD_LOGIC := '0';
signal IDEX_MemWrite: STD_LOGIC := '0';
signal IDEX_MemtoReg: STD_LOGIC := '0';
signal IDEX_RegDist: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal IDEX_RegWrite: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');

signal IDEX_RegA: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal IDEX_RegB: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal IDEX_im: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal IDEX_rs: STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal IDEX_rt: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');

signal EX_Muxa_oprandA: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal EX_Muxb_oprandB: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal EX_muxb_regb: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

signal EX_ALU_res: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

--MEM部分
--MemRead
--MemWrite
signal EXMEM_MemRead: STD_LOGIC := '0';
signal EXMEM_MemWrite: STD_LOGIC := '0';
signal EXMEM_Memtoreg: STD_LOGIC := '0';

signal EXMEM_AluData: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal EXMEM_data: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal EXMEM_regdist: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal EXMEM_regwrite: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');

--WB部分
--RegWrite
--MemtoReg
signal MEMWB_RegWrite: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal MEMWB_MemtoReg: STD_LOGIC := '0';
signal MEMWB_regdist: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal MeMWB_Memdata: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

signal MeMWB_Mux_data: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

--ByPass
signal BP_forwardA: STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
signal BP_forwardB: STD_LOGIC_VECTOR (1 downto 0) := (others => '0');

--Hazard Detection
signal HD_PCWrite: STD_LOGIC := '0';
signal HD_IFIDWrite: STD_LOGIC := '0';
signal HD_Ctrl_Flush: STD_LOGIC := '0';
signal HD_IFFlush: STD_LOGIC := '0';

--Equal Detaction
signal ED_pcsrc: STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
signal Ed_jr_addr: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal mem_nop: STD_LOGIC;

signal b_register_num: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal sig_pcwrite: STD_LOGIC;

signal temp: STD_LOGIC_VECTOR (17 downto 0) := (others => '0');
signal temp1: STD_LOGIC;
signal temp2: STD_LOGIC;


begin
we_2 <= temp1;
oe_2 <= temp2;
addr_2 <= temp;
led <= temp(15 downto 0);
dyp0 <= temp1&temp2& mem_nop&"0000" ;
dyp1 <=temp1&temp2& mem_nop&"0000" ;
my_clk <= clk;
b_register_num <= IFID_inst(10 downto 8) when IFID_inst(15 downto 11) = "11010" else IFID_inst(7 downto 5);
IF_Mem_inst <= data_2;
sig_pcwrite <= (HD_PCWrite and (not mem_nop));
u1: Muxpc port map(
					PCSrc=>ED_pcsrc,
					PCNext=>IF_Adder_res,
					PCOffset=>ID_Adder_res,
					PCJR=>ED_jr_addr,
					pc_out=>IF_Mux_addr);	
u2: pc port map(
					clk=>clk,
					rst=>rst,
					en=>'1',
					PCWrite=>sig_pcwrite,
					Mux_in=>IF_Mux_addr,
					PC_out=>IF_PC_addr);
u3: IFID_Reg port map(
					clk=>clk,
					rst=>rst,
					IF_Flush=>mem_nop,
					IFIDWrite=>HD_IFIDWrite,
					PCNext=>IF_Adder_res,
					Instruction=>IF_Mem_inst,
					PCNext_out=>IFID_addr,
					Instruction_out=>IFID_inst);
u4: registers port map(
					clk => my_clk,
					RegWrite=>MEMWB_RegWrite,
					RegA=>ID_Ctrl_rega,
					RegB=>b_register_num,
					RegW=>MEMWB_regdist,--!!
					WRData=>MeMWB_Mux_data,
					outA=>ID_Reg_A,
					outB=>ID_Reg_B,
					outT=>ID_Reg_T);
u5: ctrl_unit port map(
					instruction=>IFID_inst,
					pc=>IFID_addr,
					ALUOp=>ID_Ctrl_ALUOp,
					ALUsrc=>ID_Ctrl_ALUsrc,
					RegDist=>ID_Ctrl_RegDist,
					MemRead=>ID_Ctrl_MemRead,
					MemWrite=>ID_Ctrl_MemWrite,
					RegWrite=>ID_Ctrl_RegWrite,
					MemtoReg=>ID_Ctrl_MemtoReg,
					immediate=>ID_Ctrl_immediate,
					rega=>ID_Ctrl_rega);
u12: equal_unit port map(
					instruction=>IFID_inst,
					rs_alu=>EX_ALU_res,
					rs_mem=>data_1,
					rs_reg=>ID_Reg_A,
					idex_regwrite=>IDEX_RegWrite,
					idex_regdist=>IDEX_RegDist,
					exmem_regwrite=>EXMEM_regwrite,
					exmem_regdist=>EXMEM_regdist,
					t=>ID_Reg_T,
					pc_src=>ED_pcsrc,
					jr_reg=>ED_jr_addr);
u6: IDEX_Reg port map(
					clk=>clk,
					rst=>HD_Ctrl_Flush,
					in_ALUOp=>ID_Ctrl_ALUOp,
					in_ALUsrc=>ID_Ctrl_ALUsrc,
					in_RegDist=>ID_Ctrl_RegDist,
					in_MemRead=>ID_Ctrl_MemRead,
					in_MemWrite=>ID_Ctrl_MemWrite,
					in_RegWrite=>ID_Ctrl_RegWrite,
					in_MemtoReg=>ID_Ctrl_MemtoReg,
					in_immediate=>ID_Ctrl_immediate,
					in_rega=>ID_Reg_A,
					in_regb=>ID_Reg_B,
					in_rs=>ID_Ctrl_rega,
					in_rt=>b_register_num,--11-29 error should be b_register_num instead of inst(7 to 5)
					
					out_ALUOp=>IDEX_ALUop,
					out_ALUsrc=>IDEX_ALUsrc,
					out_RegDist=>IDEX_RegDist,
					out_MemRead=>IDEX_MemRead,
					out_MemWrite=>IDEX_MemWrite,
					out_RegWrite=>IDEX_RegWrite,
					out_MemtoReg=>IDEX_MemtoReg,
					out_immediate=>IDEX_im,
					out_rega=>IDEX_RegA,
					out_regb=>IDEX_RegB,
					out_rs=>IDEX_rs,
					out_rt=>IDEX_rt);
u7: Muxa port map(
					reg=>IDEX_RegA,
					alu=>EXMEM_AluData,
					mem=>MeMWB_Mux_data,
					
					forward=>BP_forwardA,
					src_out=>EX_Muxa_oprandA);
u8: Muxb port map(
					reg=>IDEX_RegB,
					alu=>EXMEM_AluData,
					mem=>MeMWB_Mux_data,
					immediate=>IDEX_im,
					
					forward=>BP_forwardB,
					alu_src=>IDEX_ALUsrc,
					reg_out=>EX_muxb_regb,
					src_out=>EX_Muxb_oprandB);
u9: EXMEM_Reg port map(
					clk=>clk,
					rst=>rst,
					
					in_RegDist=>IDEX_RegDist,
					in_MemRead=>IDEX_MemRead,
					in_MemWrite=>IDEX_MemWrite,
					in_RegWrite=>IDEX_RegWrite,
					in_MemtoReg=>IDEX_MemtoReg,
					in_regdata=>EX_muxb_regb,
					in_alu_data=>EX_ALU_res,

					out_alu_data => EXMEM_AluData,
					out_RegDist=>EXMEM_regdist,
					out_MemRead=>EXMEM_MemRead,
					out_MemWrite=>EXMEM_MemWrite,
					out_RegWrite=>EXMEM_regwrite,
					out_MemtoReg=>EXMEM_Memtoreg,
					out_regdata=>EXMEM_data);
u13: MEMWB_Reg port map(
					clk=>clk,
					rst=>rst,
					
					in_RegDist=>EXMEM_regdist,
					in_RegWrite=>EXMEM_regwrite,
					in_MemtoReg=>EXMEM_Memtoreg,
					in_aludata=>EXMEM_AluData,
					in_memdata=>data_1,
					
					out_data=>MeMWB_Mux_data,
					out_RegDist=>MEMWB_regdist,
					out_RegWrite=>MEMWB_RegWrite,
					out_memdata=>MeMWB_Memdata);
u14: bypass_unit port map(
					rs=>IDEX_rs,
					rt=>IDEX_rt,
					ALUsrc=>IDEX_ALUsrc,
					exmem_rd=>EXMEM_regdist,
					exmem_regwrite=>EXMEM_regwrite,
					memwb_rd=>MEMWB_regdist,
					memwb_regwrite=>memwb_regwrite,
					forwarda=>BP_forwardA,
					forwardb=>BP_forwardB);
u10: hazard_unit port map(--这里存疑
					idex_memread=>IDEX_MemRead,
					idex_rt=>IDEX_rt,
					alu_src=>ID_Ctrl_ALUsrc,
					rega=>ID_Ctrl_rega,
					ifid_rt=>b_register_num, --11-29 error
					ifid_write=>HD_IFIDWrite,
					pc_write=>HD_PCWrite,
					ctrl_clear=>HD_Ctrl_Flush);

memory0: mymemory port map(
					oe_1=>oe_1,
					we_1=>wE_1,
					en_1=>en_1,
					oe_2=>temp2,
					we_2=>temp1,
					en_2=>en_2,
					addr_1=>addr_1,
					addr_2=>temp,
					data_1=>data_1,
					data_2=>data_2,
					
					wrn=>wrn,
					rdn=>rdn,
					tbre=>tbre,
					tsre=>tsre,
					data_ready=>data_ready,
					memread=>EXMEM_MemRead,
					memwrite=>EXMEM_MemWrite,

					addr_in=>EXMEM_AluData,
					data_in=>EXMEM_data,
					pc_addr=>IF_PC_addr,
					if_nop=>mem_nop);
u15: alu port map(
					alu_op=>IDEX_ALUop,
					input_a=>EX_Muxa_oprandA,
					input_b=>EX_Muxb_oprandB,
					fout=>EX_ALU_res);
u16_pcnext: Adder port map(
					opranA=>IF_PC_addr,
					opranB=>x"0001",
					res=>IF_Adder_res);
u17_pcoffset: Adder port map(
					opranA=>IFID_addr,
					opranB=>ID_Ctrl_immediate,
					res=>ID_Adder_res);					
end Behavioral;

