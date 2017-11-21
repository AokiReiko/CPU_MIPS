library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity cpu_16bit_top is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC);	
end cpu_16bit_top;

architecture Behavioral of cpu_16bit_top is
--信号命名规则: 前缀（产生信号的周期）+部件名称+描述
--IF部分
signal IF_Mux_addr: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal IF_PC_addr: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal IF_Mem_inst: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal IF_Adder_res: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
--ID部分
signal IFID_inst: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal IFID_instruction: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
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


signal ID_Mux_Ctrl_ALUOp: STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal ID_Mux_Ctrl_ALUsrc: STD_LOGIC := '0';
signal ID_Mux_Ctrl_RegDist: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal ID_Mux_Ctrl_MemRead: STD_LOGIC := '0';
signal ID_Mux_Ctrl_MemWrite: STD_LOGIC := '0';
signal ID_Mux_Ctrl_RegWrite: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal ID_Mux_Ctrl_MemtoReg: STD_LOGIC := '0';

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
signal IDEX_rs: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal IDEX_rt: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');

signal EX_Muxa_oprandA: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal EX_Muxb_oprandB: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal EX_ALU_res: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal EX_ALU_zero: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');--ID阶段已经检测,存疑
signal EX_Muxc_regdist: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');

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
signal MEM_Mem_out: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

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


begin

u1: Muxpc port map(
					PCSrc=>ED_pcsrc,
					PCNext=>IF_Adder_res,
					PCOffset=>ID_Adder_res,
					PCJR=>ID_Reg_A,
					pc_out=>IF_Mux_addr);	
u2: pc port map(
					clk=>clk,
					rst=>rst,
					en=>'1',
					PCWrite=>HD_PCWrite,
					Mux_in=>IF_Mux_addr,
					PC_out=>IF_PC_addr);
u3: IFID_Reg port map(
					clk=>clk,
					rst=>rst,
					IF_Flush=>'0',
					IFIDWrite=>HD_IFIDWrite,
					PCNext=>IF_PC_addr,
					Instruction=>IF_Mem_inst,
					PCNext_out=>IFID_addr,
					Instruction_out=>IFID_inst);
u4: registers port map(
					RegWrite=>MEMWB_RegWrite,
					RegA=>ID_Ctrl_rega,
					RegB=>IFID_inst(7 downto 5),
					RegW=>MEMWB_regdist,--!!
					WRData=>MeMWB_Mux_data,
					outA=>ID_Reg_A,
					outB=>ID_Reg_B);
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
u5: equal_unit port map(
					rs_alu=>,
					rs_mem=>,
					rs_reg=>,
					rpc=>,
					idex_regwrite=>,
					idex_regdist=>,
					t=>,
					pc_src=>);
u6: IDEX_Reg port map(
					clk=>,
					rst=>,
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
					in_rs=>Instruction(10 downto 8),
					in_rt=>Instruction(7 downto 5),

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
					mem=>MeMWB_Memdata,
					forward=>BP_forwardA,
					src_out=>EX_Muxa_oprandA);
u7: Muxb port map(
					reg=>IDEX_RegA,
					alu=>EXMEM_AluData,
					mem=>MeMWB_Memdata,
					immediate=>IDEX_im,
					forward=>BP_forwardB,
					alu_src=>IDEX_ALUsrc,
					src_out=>EX_Muxb_oprandB);
u9: EXMEM_Reg port map(
					clk=>,
					rst=>,
					
					in_RegDist=>IDEX_RegDist,
					in_MemRead=>IDEX_MemRead,
					in_MemWrite=>IDEX_MemWrite,
					in_RegWrite=>IDEX_RegWrite,
					in_MemtoReg=>IDEX_MemtoReg,
					in_regdata=>,

					out_RegDist=>EXMEM_regdist,
					out_MemRead=>EXMEM_MemRead,
					out_MemWrite=>EXMEM_MemWrite,
					out_RegWrite=>EXMEM_regwrite,
					out_MemtoReg=>EXMEM_Memtoreg,
					out_regdata=>EXMEM_data);
u8: MEMWB_Reg port map(
					clk=>,
					rst=>,
					
					in_RegDist=>EXMEM_regdist,
					in_RegWrite=>EXMEM_regwrite,
					in_MemtoReg=>EXMEM_Memtoreg,
					in_aludata=>EXMEM_AluData,

					out_RegDist=>MEMWB_regdist,
					out_RegWrite=>MEMWB_RegWrite,
					out_MemtoReg=>MEMWB_MemtoReg,
					out_memdata=>MeMWB_Memdata,
					out_regdata=>MeMWB_Mux_data);
u9: bypass_unit port map(
					rs=>IDEX_rs,
					rt=>IDEX_rt,
					exmem_rd=>EXMEM_regdist,
					exmem_regwrite=>EXMEM_regwrite,
					memwb_rd=>MEMWB_regdist,
					memwb_regwrite=>memwb_regwrite,
					forwarda=>BP_forwardA,
					forwardb=>BP_forwardB);
u10: hazard_unit port map(--这里存疑
					idex_memread=>IDEX_MemRead,
					idex_rt=>IDEX_rt,
					ifid_rs=>,
					ifid_rt=>,
					ifid_write=>HD_IFIDWrite,
					pc_write=>HD_PCWrite);


	
end Behavioral;

