module cpu(clk, rst_n, hlt, pc);

input clk, rst_n;
output hlt;
output [15:0] pc;

wire Stall_All; //cache thing, moved higher to make it happy
wire [15:0] currInst; //current instruction from instMem at pc
wire rst;  //resets when high

wire [2:0] flagIn,flagOut; //flag register contents to write
 
wire writeFlagReg; //enabled when ADD, SUB, XOR, SLL, SRA, ROR

//register parameters
wire [3:0] SrcReg1;  //assign to this value to pass to register file
wire [3:0] SrcReg2;
wire [15:0] DstData, SrcData1, SrcData2;

//control unit outputs
wire memRead, memWrite, memToReg, ALUsrc, regWrite, branch, regWriteSelect;

//alu unit parameters
wire [15:0] ALUinput1, ALUinput2, ALUoutput, SignExtendedImmediate;


//data memory unit parameters
wire [15:0] data_out, data_in, data_addr, data_writeback;

//pc_control parameters
wire Br, branchTaken;
wire [2:0] smartManBranchFlags;
wire [15:0] pcNext;
wire [15:0] ID_signExtendedPCImmediate;

//forwarding parameters
wire [15:0] ForwardA, ForwardB, ForwardMem;
wire stall;

//stall unit parameters 
wire stallBranch;
wire check_done;

//IF wires and IFID Instantiation
wire [34:0] IFIDout, IFIDin, IFIDin_Super;  //DOLATER
wire [15:0] IF_currInst; //DOLATER
wire [2:0] IF_flags;
wire IFIDflush;
wire [2:0] WB_flags; 
assign IF_currInst = currInst;
assign IF_flags = WB_flags; //HAZARD
IFID IFID1(.clk(clk), .rst(rst), .D(IFIDin_Super), .writeReg(1'b1), .Q(IFIDout));
// IFIDin layout:               {pcNext, IF_currInst, IF_flags}
			  //    [34:19]  [18:3]       [2:0]



//ID wires and IDEX Instantiation
wire IDEXflushed;
wire [87:0] IDEXout, IDEXin, IDEXin_Super;
wire [15:0] ID_pc, ID_currInst;
wire[2:0] ID_flags;
wire [3:0] ID_DstReg;
wire [3:0] ID_SrcReg1, ID_SrcReg2, ID_ALUop;
assign ID_currInst = IFIDout[18:3];
assign ID_ALUop = IFIDout[18:15];
assign ID_SrcReg1 = SrcReg1; //handled below, used for forwarding only
assign ID_SrcReg2 = SrcReg2; // handled below, used for forwarding only
assign ID_DstReg = IFIDout[14:11];
assign ID_pc = IFIDout[34:19];
assign ID_flags = IFIDout[2:0];
IDEX IDEX1(.clk(clk), .rst(rst), .D(IDEXin_Super), .writeReg(1'b1), .Q(IDEXout));
				//{ IDEXflushed, ID_ALUop,ID_SrcReg1, ID_SrcReg2, ID_DstReg, ID_pc, SrcData1, SrcData2, SignExtendedImmediate, memRead, memWrite, memToReg, ALUsrc, regWrite, writeFlagReg, regWriteSelect}
				//  [87]         [86:83]     [82:79]   [78:75]    [74:71]   [70:55] [54:39]   [38:23]     [22:7]                  [6]    [5]        [4]       [3]     [2]      [1]              [0]




//EX wires and EXMEM Instantiation
wire EX_hlt;
wire [66:0] EXMEMout, EXMEMin, EXMEMin_Super;
wire EXMEMflushed;
wire EX_memRead, EX_memWrite, EX_memToReg, EX_ALUsrc, EX_regWrite, EX_writeFlagReg, EX_regWriteSelect;
wire [3:0] EX_DstReg, EX_ALUop, EX_SrcReg2, EX_SrcReg1;
wire [15:0] EX_SrcData2, EX_immediate;
wire [15:0] EX_PC;
assign EXMEMflushed = IDEXout[87];
assign EX_immediate = IDEXout[22:7];
assign EX_SrcReg1 = IDEXout[82:79];
assign EX_SrcReg2 = IDEXout[78:75];
assign EX_ALUop = IDEXout[86:83];
assign EX_hlt = (EX_ALUop == 4'b1111) ? 1'b1 : 1'b0;
assign EX_PC = IDEXout[70:55];
assign EX_SrcData2 = IDEXout[38:23];
assign EX_DstReg = IDEXout[74:71];
assign EX_memRead = IDEXout[6];
assign EX_memWrite = IDEXout[5];
assign EX_memToReg = IDEXout[4];
assign EX_ALUsrc = IDEXout[3];
assign EX_regWrite = IDEXout[2];
assign EX_writeFlagReg = IDEXout[1];
assign EX_regWriteSelect = IDEXout[0];
EXMEM EXMEM1(.clk(clk), .rst(rst), .D(EXMEMin_Super), .writeReg(1'b1), .Q(EXMEMout));
				//        [66]         [65]   [64:61]    [60:45][44:42] [41:26]    [ 25:10]      [9:6]       [5]        [4]                [3]        [2]          [1]            [0]
									    // ^ was ForwardB
assign EXMEMin = {EXMEMflushed, EX_hlt, EX_SrcReg2, EX_PC, flagIn, ALUoutput,EX_SrcData2 ,EX_DstReg, EX_memRead, EX_memWrite, EX_memToReg, EX_regWrite, EX_writeFlagReg, EX_regWriteSelect};
               //    [66]         [65]   [64:61]    [60:45][44:42] [41:26]    [ 25:10]      [9:6]       [5]        [4]                [3]        [2]          [1]            [0]
									    // ^ was ForwardB
//MEM wires and MEMWB Instantiation
wire [59:0] MEMWBout, MEMWBin, MEMWBin_Super;
wire MEMWBflushed;
wire MEM_hlt;
wire [2:0] MEM_flags;
wire [3:0] MEM_DstReg, MEM_SrcReg2;
wire [15:0] MEM_data_addr, MEM_PC, MEM_ALUoutput;
assign MEMWBflushed = EXMEMout[66];
assign MEM_hlt = EXMEMout[65];
assign MEM_SrcReg2 = EXMEMout[64:61];
assign MEM_ALUoutput = EXMEMout[41:26];
assign MEM_PC = EXMEMout[60:45];
assign MEM_memRead = EXMEMout[5];
assign MEM_memWrite = EXMEMout[4];
assign MEM_memToReg = EXMEMout[3];
assign MEM_regWrite = EXMEMout[2];
assign MEM_writeFlagReg = EXMEMout[1];
assign MEM_regWriteSelect = EXMEMout[0];

assign MEM_flags = EXMEMout[44:42];
assign MEM_DstReg = EXMEMout[9:6];
assign MEM_data_addr = EXMEMout[41:26];
MEMWB MEMWB1(.clk(clk), .rst(rst), .D(MEMWBin_Super), .writeReg(1'b1), .Q(MEMWBout));
assign MEMWBin = {MEMWBflushed, MEM_hlt, MEM_PC, MEM_flags, MEM_data_addr, data_out, MEM_DstReg, MEM_memToReg, MEM_regWrite, MEM_regWriteSelect};
	               // [59]       [58]   [57:42] [41:39]    [38:23]       [22:7]     [6:3]        [2]              [1]              [0]
//WB phase stuff
wire[15:0] WB_PC;
wire [3:0] WB_DstReg;
wire flushedOUT;
wire WB_memToReg, WB_regWrite, WB_regWriteSelect, WB_hlt;
assign flushedOUT = MEMWBout[59];
assign WB_hlt = MEMWBout[58];
assign WB_memToReg = MEMWBout[2];
assign WB_regWrite = MEMWBout[1];
assign WB_regWriteSelect = MEMWBout[0];
assign WB_DstReg = MEMWBout[6:3];
assign WB_PC = MEMWBout[57:42];
assign WB_flags = MEMWBout[41:39];

//halt/stall stuff
wire [15:0] PCwithHLT;
assign PCwithHLT = 	(Stall_All) ? pc : 						//Stall for cache fill	
					(branch & branchTaken) ? (pcNext) :     //branch taken
					(currInst[15:12] == 4'b1111) ? pc :     //halt
					pcNext; 								//increment PC

// **** instantiate modules **** //
//PC control                            
PC_control pc_control1(.branch(branch),.C(IFIDout[14:12]), .I(ID_signExtendedPCImmediate), .F(smartManBranchFlags), .PC_in(pc) , .PC_out(pcNext), .Br(Br), .Stall(stall), .branchTaken(branchTaken), .Flush(IFIDflush)); 
//PC register
RegisterNotInFile pcReg(.clk(clk), .rst(rst), .wen(1'b1), .D(PCwithHLT), .Q(pc));
//flag register instantiation - this happens in each big register
flag flag1(.clk(clk), .rst(rst), .D(flagIn), .writeReg(EX_writeFlagReg), .Q(flagOut));
//Control unit
control control1(.opCode(ID_ALUop), .memRead(memRead), .memWrite(memWrite), .memToReg(memToReg), .ALUsrc(ALUsrc), .regWrite(regWrite), .branch(branch), .writeFlag(writeFlagReg), .regWriteSelect(regWriteSelect));
//ALU 
ALU ALU1(.ALU_Out(ALUoutput), .FLAG(flagIn), .ALU_In1(ForwardA), .ALU_In2(ForwardB), .Opcode(EX_ALUop));
//RegisterFile
RegisterFile registers(.clk(clk), .rst(rst), .SrcReg1(SrcReg1), .SrcReg2(SrcReg2), .DstReg(WB_DstReg), .WriteReg(WB_regWrite), .DstData(DstData), .SrcData1(SrcData1), .SrcData2(SrcData2));


//******** CACHE MODULES *************//
wire miss_detected;
wire miss_detected_instruction;
wire miss_detected_data;
wire [15:0] miss_address;	//output of case statement, so this is a reg
wire fsm_busy;
wire write_data_array;
wire write_tag_array;
wire [15:0] memory_address;
wire [15:0] memory_data_out;
wire memory_data_valid;
wire instruction_write_even;
wire instruction_write_odd;
wire [127:0] instruction_block_enable_even;
wire [127:0] instruction_block_enable_odd;
wire [5:0] instruction_block_bits;
wire [6:0] instruction_block_bits_decode_even;
wire [6:0] instruction_block_bits_decode_odd;
wire [7:0] instruction_word_enable;
wire [2:0] instruction_word_bits;
wire [5:0] instruction_tag_bits;
wire [15:0] currInst_even;
wire [15:0] currInst_odd;
wire [7:0] instruction_metadata_in;
wire [127:0] data_block_enable_even;
wire [127:0] data_block_enable_odd;
wire [5:0] data_block_bits;
wire [6:0] data_block_bits_decode_even;
wire [6:0] data_block_bits_decode_odd;
wire [7:0] data_word_enable;
wire [2:0] data_word_bits;
wire [5:0] data_tag_bits;
wire [15:0] data_out_even;
wire [15:0] data_out_odd;
wire [7:0] data_metadata_in;
wire [7:0] data_metadata_in_even;
wire [7:0] data_metadata_in_odd;
wire [7:0] data_metadata_out_even;
wire [7:0] data_metadata_out_odd;
wire [5:0] data_metadata_out_tag_even;
wire [5:0] data_metadata_out_tag_odd;
wire data_metadata_out_valid_odd;
wire data_metadata_out_valid_even;
wire data_metadata_out_LRU_odd;
wire data_metadata_out_LRU_even;
wire write_data_metadata_even;
wire write_data_metadata_odd; 
wire write_instruction_metadata_even;
wire write_instruction_metadata_odd;
wire [7:0] instruction_metadata_out_even;
wire [7:0] instruction_metadata_out_odd;
wire [7:0] instruction_metadata_in_even;
wire [7:0] instruction_metadata_in_odd;
wire [7:0] data_metadata_in_inv ;
wire [7:0] instruction_metadata_in_inv;
wire instruction_metadata_out_valid_even;
wire instruction_metadata_out_valid_odd;
wire [5:0]instruction_metadata_out_tag_even;
wire [5:0]instruction_metadata_out_tag_odd;
wire miss_detected_instruction_odd;
wire miss_detected_instruction_even;
wire miss_detected_data_odd;
wire miss_detected_data_even;
wire instruction_metadata_out_LRU_even;
wire instruction_metadata_out_LRU_odd;
wire memory_enable;
wire [2:0] counter;
wire multiMemWrite;
wire [15:0] combined_memory_address;
/* reg miss_detected_instruction_odd;
reg miss_detected_instruction_even;
reg miss_detected_data_odd;
reg miss_detected_data_even; */
//Cache fill FSM
cache_fill_FSM cache_fill_FSM1(.clk(clk), .rst_n(rst), .miss_detected(miss_detected), .miss_address(miss_address), .fsm_busy(fsm_busy), .write_data_array(write_data_array),
.write_tag_array(write_tag_array),.memory_address(memory_address), .memory_data(memory_data_out), .memory_data_valid(memory_data_valid), .memory_enable(memory_enable), .counter2(counter));

//handle writes

//Instruction cache
DataArray instruction_cache_even(.clk(clk), .rst(rst), .DataIn(memory_data_out), .Write(instruction_write_even), .BlockEnable(instruction_block_enable_even), .WordEnable(instruction_word_enable), .DataOut(currInst_even));
DataArray instruction_cache_odd(.clk(clk), .rst(rst), .DataIn(memory_data_out), .Write(instruction_write_odd), .BlockEnable(instruction_block_enable_odd), .WordEnable(instruction_word_enable), .DataOut(currInst_odd));
//Instruction metadata
MetaDataArray instruction_metadata_even(.clk(clk), .rst(rst), .DataIn(instruction_metadata_in_even), .Write(write_instruction_metadata_even), .BlockEnable(instruction_block_enable_even), .DataOut(instruction_metadata_out_even)); //always write because reads/writes gotta update LRU block?
MetaDataArray instruction_metadata_odd(.clk(clk), .rst(rst), .DataIn(instruction_metadata_in_odd), .Write(write_instruction_metadata_odd), .BlockEnable(instruction_block_enable_odd), .DataOut(instruction_metadata_out_odd)); //always write because reads/writes gotta update LRU block?
//instruction block decoder
CacheDecoder_7_128 instruction_block_even(.RegId(instruction_block_bits_decode_even), .WriteReg(1'b1), .Wordline(instruction_block_enable_even)); //write reg does nothing in this 
CacheDecoder_7_128 instruction_block_odd(.RegId(instruction_block_bits_decode_odd), .WriteReg(1'b1), .Wordline(instruction_block_enable_odd)); //write reg does nothing in this 
//instruction word decoder
WordDecoder_3_8 instruction_word(.RegId(instruction_word_bits), .WriteReg(1'b1), .Wordline(instruction_word_enable));

//Data cache
DataArray data_cache_even(.clk(clk), .rst(rst), .DataIn(memory_data_out), .Write(data_write_even), .BlockEnable(data_block_enable_even), .WordEnable(data_word_enable), .DataOut(data_out_even));
DataArray data_cache_odd(.clk(clk), .rst(rst), .DataIn(memory_data_out), .Write(data_write_odd), .BlockEnable(data_block_enable_odd), .WordEnable(data_word_enable), .DataOut(data_out_odd));
//Data metadata
MetaDataArray data_metadata_even(.clk(clk), .rst(rst), .DataIn(data_metadata_in_even), .Write(write_data_metadata_even), .BlockEnable(data_block_enable_even), .DataOut(data_metadata_out_even)); //always write because reads/writes gotta update LRU block? 
MetaDataArray data_metadata_odd(.clk(clk), .rst(rst), .DataIn(data_metadata_in_odd), .Write(write_data_metadata_odd), .BlockEnable(data_block_enable_odd), .DataOut(data_metadata_out_odd)); //always write because reads/writes gotta update LRU block? 
//data block decoder
CacheDecoder_7_128 data_block_even(.RegId(data_block_bits_decode_even), .WriteReg(1'b1), .Wordline(data_block_enable_even));
CacheDecoder_7_128 data_block_odd(.RegId(data_block_bits_decode_odd), .WriteReg(1'b1), .Wordline(data_block_enable_odd));
//data word decoder
WordDecoder_3_8 data_word(.RegId(data_word_bits), .WriteReg(1'b1), .Wordline(data_word_enable));

//Main memory  ------ NEEDS WORK ------ address will have to change from memory_address for writes 
memory4c main_memory(.data_out(memory_data_out), .data_in(ForwardMem), .addr(combined_memory_address), .enable(memory_enable), .wr(multiMemWrite), .clk(clk), .rst(rst), .data_valid(memory_data_valid)); //hook enable/wr up to cache_fill_fsm somehow? 
																							            				//MEM_memWrite		

//**** old modules ****//
//instruction memory
//memory1c instMem(.data_out(currInst), .data_in(16'hzzzz), .addr(pc), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(rst));
//data memory
//memory1c2 dataMem(.data_out(data_out), .data_in(ForwardMem), .addr(data_addr), .enable(1'b1), .wr(MEM_memWrite), .clk(clk), .rst(rst));


//**** comb-for-cache *****//
//instruction bits and metadata
assign instruction_block_bits = pc[9:4];
assign instruction_tag_bits = pc[15:10];
assign instruction_block_bits_decode_even = {instruction_block_bits, 1'b0};
assign instruction_block_bits_decode_odd = {instruction_block_bits, 1'b1};
assign instruction_metadata_in = {instruction_tag_bits, 1'b1 , 1'b1}; //tag + valid + LRU
assign instruction_metadata_in_inv = {instruction_tag_bits, 1'b0 , 1'b0}; //tag + valid + LRU
assign instruction_metadata_out_tag_even = instruction_metadata_out_even[7:2];
assign instruction_metadata_out_tag_odd = instruction_metadata_out_odd[7:2];
assign instruction_metadata_out_valid_even = instruction_metadata_out_even[1];
assign instruction_metadata_out_valid_odd = instruction_metadata_out_odd[1];
assign instruction_metadata_out_LRU_even = instruction_metadata_out_even[0];
assign instruction_metadata_out_LRU_odd = instruction_metadata_out_odd[0];
//data bits and metadata 
assign data_block_bits = data_addr[9:4];
assign data_tag_bits = data_addr[15:10];
assign data_block_bits_decode_even = {data_block_bits, 1'b0};
assign data_block_bits_decode_odd = {data_block_bits, 1'b1};
assign data_metadata_in = {data_tag_bits, 1'b1, 1'b1}; //tag + valid + LRU 
assign data_metadata_in_inv = {data_tag_bits, 1'b0, 1'b0}; //tag + valid + LRU 
assign data_metadata_out_tag_even = data_metadata_out_even[7:2];
assign data_metadata_out_tag_odd = data_metadata_out_odd[7:2];
assign data_metadata_out_valid_even = data_metadata_out_even[1];
assign data_metadata_out_valid_odd = data_metadata_out_odd[1];
assign data_metadata_out_LRU_even = data_metadata_out_even[0];
assign data_metadata_out_LRU_odd = data_metadata_out_odd[0];
//assign word enable based on count of 		write_data_array singals 
assign instruction_word_bits = (Stall_All) ? counter : pc[3:1];
assign data_word_bits = (Stall_All) ? counter : data_addr[3:1];
 
//miss detection
assign miss_detected = miss_detected_instruction | miss_detected_data;
//instruction misses
assign miss_detected_instruction_odd = ((instruction_tag_bits != instruction_metadata_out_tag_odd)| (instruction_metadata_out_valid_odd == 1'b0)); 
assign miss_detected_instruction_even = ((instruction_tag_bits != instruction_metadata_out_tag_even) | (instruction_metadata_out_valid_even == 1'b0));
assign miss_detected_instruction = miss_detected_instruction_odd & miss_detected_instruction_even;
//data misses
assign miss_detected_data_odd = (((data_tag_bits != data_metadata_out_tag_odd)| (data_metadata_out_valid_odd == 1'b0)) & (MEM_memRead | MEM_memWrite)); 
assign miss_detected_data_even = (((data_tag_bits != data_metadata_out_tag_even) | (data_metadata_out_valid_even == 1'b0))& (MEM_memRead | MEM_memWrite));
assign miss_detected_data = miss_detected_data_odd & miss_detected_data_even;



//hit detection
assign data_out = (~miss_detected_data_odd) ? data_out_odd :
					(~miss_detected_data_even) ? data_out_even : 
					16'h0000;	// ((data_metadata_out_tag_even == data_tag_bits) && data_metadata_out_valid_even == 1'b1) 
assign currInst = (~miss_detected_instruction_odd) ? currInst_odd :
					(~miss_detected_instruction_even) ? currInst_even : 
					16'h0000;	// ((data_metadata_out_tag_even == data_tag_bits) && data_metadata_out_valid_even == 1'b1) 
//LRU metadata swap
assign instruction_metadata_in_even =   (~miss_detected_instruction_even) ? instruction_metadata_in :  ///{instruction_metadata_out_tag_even ,  instruction_metadata_out_valid_even, 1'b1}
										(Stall_All) ? instruction_metadata_in :   //write valid when filling cache
										(~miss_detected_instruction_odd) ? {instruction_metadata_out_tag_even, instruction_metadata_out_valid_even, 1'b0} :
										instruction_metadata_in_inv;
assign instruction_metadata_in_odd = (~miss_detected_instruction_odd) ? instruction_metadata_in : 
										(Stall_All) ? instruction_metadata_in :   //write valid when filling cache
										(~miss_detected_instruction_even) ? {instruction_metadata_out_tag_odd, instruction_metadata_out_valid_odd, 1'b0} :
										instruction_metadata_in_inv;
assign data_metadata_in_even = (~miss_detected_data_even) ? data_metadata_in : 
								(Stall_All) ? data_metadata_in :   //write valid when filling cache
								(~miss_detected_data_odd) ? {data_metadata_out_tag_even, data_metadata_out_valid_even, 1'b0} :
								data_metadata_in_inv;
assign data_metadata_in_odd = (~miss_detected_data_odd) ? data_metadata_in: 
								(Stall_All) ? data_metadata_in :   //write valid when filling cache
								(~miss_detected_data_even) ? {data_metadata_out_tag_odd, data_metadata_out_valid_odd, 1'b0} :
								data_metadata_in_inv;
//assign Pipe registers when stall for cache fill
assign Stall_All = fsm_busy;
assign IFIDin_Super = (Stall_All) ? IFIDout : IFIDin;
assign IDEXin_Super = (Stall_All) ? IDEXout : IDEXin;
assign EXMEMin_Super = (Stall_All) ? EXMEMout : EXMEMin;
assign MEMWBin_Super = (Stall_All) ? MEMWBout : MEMWBin;
//assign write signals for caches
assign instruction_write_even = ( miss_detected_instruction & write_data_array & (instruction_metadata_out_LRU_even == 1'b0)) ? 1'b1 : 1'b0;
assign instruction_write_odd = (miss_detected_instruction & write_data_array & (instruction_metadata_out_LRU_odd == 1'b0)) ? 1'b1 : 1'b0;
assign data_write_even = (miss_detected_data & write_data_array & (data_metadata_out_LRU_even == 1'b0)) ? 1'b1 : //handles cache misses
			(~miss_detected_data_even & MEM_memWrite) ? 1'b1 :		//handles writes after cache filled, possible that more condition check needed
			 1'b0;
assign data_write_odd = (miss_detected_data & write_data_array & (data_metadata_out_LRU_odd == 1'b0)) ? 1'b1 : //handles cache misses
			(~miss_detected_data_odd & MEM_memWrite) ? 1'b1 :		//handles writes after cache filled, possible that more condition check needed
			 1'b0;
//assign metadata write signals
assign write_instruction_metadata_odd = (~miss_detected_instruction & ~fsm_busy & ~rst) ? 1'b1 :  
									(miss_detected_instruction & write_tag_array & (instruction_metadata_out_LRU_odd == 1'b0)) ? 1'b1 :
 									1'b0;
assign write_instruction_metadata_even = (~miss_detected_instruction & ~fsm_busy & ~rst) ? 1'b1 :  
									(miss_detected_instruction & write_tag_array & (instruction_metadata_out_LRU_even == 1'b0)& (instruction_metadata_out_LRU_odd == 1'b0)) ? 1'b0 :
									(miss_detected_instruction & write_tag_array & (instruction_metadata_out_LRU_even == 1'b0))  ? 1'b1 :
 									1'b0;
									
//assign write_instruction_metadata_odd = (~miss_detected_instruction & ~fsm_busy & ~rst) ? 1'b1 :  
	//								(miss_detected_instruction & write_tag_array & (instruction_metadata_out_LRU_odd == 1'b0)) ? 1'b1 :
 		//							1'b0;
//assign write_instruction_metadata_even = (~miss_detected_instruction & ~fsm_busy & ~rst) ? 1'b1 :  
	//								(miss_detected_instruction & write_tag_array & (instruction_metadata_out_LRU_even == 1'b0)) ? 1'b1 :
 		//							1'b0;									
									
//only write metadata for data metadata cache when memory is actually accessed
assign write_data_metadata_odd = (~fsm_busy & (MEM_memRead | MEM_memWrite)) ? 1'b1 :  
									(miss_detected_data & write_tag_array & (data_metadata_out_LRU_odd == 1'b0)) ? 1'b1 :
 									1'b0;
assign write_data_metadata_even = (~fsm_busy & (MEM_memRead | MEM_memWrite)) ? 1'b1 :  
									(miss_detected_data & write_tag_array & (data_metadata_out_LRU_even == 1'b0)& (data_metadata_out_LRU_odd == 1'b0)) ? 1'b0 :
									(miss_detected_data & write_tag_array & (data_metadata_out_LRU_even == 1'b0))? 1'b1:
 									1'b0;

									//assign write_data_metadata_even = (~fsm_busy & (MEM_memRead | MEM_memWrite)) ? 1'b1 :  
									//(miss_detected_data & write_tag_array & (data_metadata_out_LRU_even == 1'b0)) ? 1'b1 :
 									//1'b0;
assign miss_address = (miss_detected_data) ? data_addr :  //forwardMem
						(miss_detected_instruction) ? pc :
						16'h0000;
						
assign combined_memory_address = (miss_detected) ? (memory_address) : 
									data_addr;
//writing to data cache
assign multiMemWrite = (MEM_memWrite & (~miss_detected_data)) ? 1'b1 : 1'b0;

							
									
									

//****** combinational logic   ********//
assign rst = ~rst_n;  //turn reset to positive
//  assign DstReg = currInst[11:8]; //assign rd <------ handled above where we have ID_DstReg etc
assign SrcReg1 = (IFIDout[18:16] == 3'b101)? IFIDout[14:11] : IFIDout[10:7]; //assign rs (assigns rd for LHB and LLB)
assign SrcReg2 = (memWrite == 1'b1)? IFIDout[14:11] : IFIDout[6:3];	//assign rt (whether or not its used) ([11:8] for store instruction only)
assign ALUinput1 = IDEXout[54:39]; //connect reg out to alu in
assign ALUinput2 = (EX_ALUsrc == 1) ? EX_SrcData2 : EX_immediate;  //choose ALU in from SrcData2 or immediate
assign SignExtendedImmediate = (IFIDout[18:17] == 2'b01) ? {{12{1'b0}}, IFIDout[6:3]} :  //immediate for SLL, SRA, ROR
			       (IFIDout[18:16] == 3'b100) ? {{11{IFIDout[6]}}, IFIDout[6:3], 1'b0} : //immediate for load or store
			       (IFIDout[18:17] == 2'b11) ? {{6{IFIDout[11]}},IFIDout[11:3], 1'b0} :  //immediate for B
			       (IFIDout[18:16] == 3'b101) ? {{8{1'b0}},IFIDout[10:3]} :
					    16'h0000;
assign data_writeback = (WB_memToReg) ? MEMWBout[22:7] : MEMWBout[38:23] ; //determines if Memory or ALU result is sent back to registers
assign data_addr = EXMEMout[41:26];
assign data_in = EXMEMout[25:10]; //assign write data to be rs ::::: Handled above because it needs to get piped
assign DstData = (WB_regWriteSelect) ? data_writeback : WB_PC ; //choose to write either writeback value or PC (PCS instruction) --  regWriteSelect signal
assign ID_signExtendedPCImmediate = (IFIDout[15] == 0) ? SignExtendedImmediate : SrcData1; //choose either immediate or value in rs for pc_control
assign Br = IFIDout[15];





//****** forwarding logic chunk *******//
//  Stall for MEM-EX Forward(modifications to IFID happen in PC_control )
assign stall = ((((ID_SrcReg1 == EX_DstReg) | (ID_SrcReg2 == EX_DstReg & ID_ALUop != 4'b1001)) & (IDEXout[86:83] == 4'b1000)) | (stallBranch)) ? 1'b1:
				1'b0;

assign IDEXin = (stall) ? {IDEXflushed, {87{1'b0}}} :
		{IDEXflushed, ID_ALUop,ID_SrcReg1, ID_SrcReg2, ID_DstReg, ID_pc, SrcData1, SrcData2, SignExtendedImmediate, memRead, memWrite, memToReg, ALUsrc, regWrite, writeFlagReg, regWriteSelect};
		//    [87]      [86:83]     [82:79]   [78:75]    [74:71]   [70:55] [54:39]   [38:23]     [22:7]                  [6]    [5]        [4]       [3]     [2]      [1]              [0]

//  EX to EX forward and MEM to EX forward
assign ForwardA =    ((MEM_regWrite == 1'b1)& (MEM_memToReg == 1'b0) & (MEM_regWriteSelect == 1'b1)& ( MEM_DstReg != 4'b0000) & (MEM_DstReg == EX_SrcReg1))? MEM_ALUoutput:    //select ALUoutput for EX to EX <-- compare regWrite, memToReg and maybe regWriteSelect
		     ((MEM_regWrite == 1'b1)& (MEM_memToReg == 1'b0) & (MEM_regWriteSelect == 1'b0)& ( MEM_DstReg != 4'b0000) & (MEM_DstReg == EX_SrcReg1))? MEM_PC:    //select PC for EX to EX when PCS instruction used
		     ((WB_regWrite == 1'b1) & (WB_DstReg != 4'b0000) & (WB_DstReg == EX_SrcReg1)) ? DstData :          //select Data Memory for MEM to EX <--- compare regWrite, memToReg and maybe regWriteSelect
		     (ALUinput1);	 //select data memory for MEM to MEM......otherwise choose regular returned value from WB
assign ForwardB =    ((EX_ALUop == 4'b1001) | (EX_ALUop == 4'b1000)|((EX_ALUop == 4'b1001) & (MEM_regWrite == 1'b1)& (MEM_memToReg == 1'b0) & (MEM_regWriteSelect == 1'b1)& ( MEM_DstReg != 4'b0000) & (MEM_DstReg == EX_SrcReg2))) ? ALUinput2: //forwarding cancelled for store for this register
			(EX_ALUop[3:1] == 3'b101) ? ALUinput2 : //dont forward a register to ForwardB if instruction is LLB or LHB
		     ((MEM_regWrite == 1'b1)& (MEM_memToReg == 1'b0) & (MEM_regWriteSelect == 1'b1)& ( MEM_DstReg != 4'b0000) & (MEM_DstReg == EX_SrcReg2))? MEM_ALUoutput:    //select ALUoutput for EX to EX <-- compare regWrite, memToReg and maybe regWriteSelect
		     ((MEM_regWrite == 1'b1)& (MEM_memToReg == 1'b0) & (MEM_regWriteSelect == 1'b0)& ( MEM_DstReg != 4'b0000) & (MEM_DstReg == EX_SrcReg2))? MEM_PC:    //select PC for EX to EX when PCS instruction used
		     ((WB_regWrite == 1'b1) & (WB_DstReg != 4'b0000) & (WB_DstReg == EX_SrcReg2)) ? DstData :          //select Data Memory for MEM to EX <--- compare regWrite, memToReg and maybe regWriteSelect
		     (ALUinput2);	 //select data memory for MEM to MEM......otherwise choose regular returned value from WB

//  Branch 
assign smartManBranchFlags = (EX_writeFlagReg == 1'b1) ? flagIn :    //forwards new flags from ALU to PC_control if they would update the flag register
						flagOut;	//otherwise just read the flag register
assign IFIDflush = (branchTaken)? 1'b1 : 1'b0;  //make signal easier to understand

assign IFIDin = (IFIDflush & ~stallBranch)?  {35{1'b0}}    : 
		(stall) ? IFIDout: 
			    {pcNext, IF_currInst, IF_flags};
//branch Stall

assign IDEXflushed = (ID_ALUop[3:1] == 3'b110) & (IFIDout[14:12] != 3'b111);
assign stallBranch = (((ID_ALUop[3:1] == 3'b110) & (IFIDout[14:12] != 3'b111)) & ~check_done) ? 1'b1 : 
			1'b0;

assign check_done = flushedOUT;


//  MEM to MEM forward
assign ForwardMem = ((MEM_memWrite == 1'b1) & (WB_regWrite == 1'b1) & (WB_DstReg != 4'b0000) & (WB_DstReg == MEM_SrcReg2)) ? MEMWBout[22:7]: ///if value to be loaded is being stored next, forward that
			data_in;   //otherwise write whatever value from register


// ***** fully handles hlt instruction ***** //
assign hlt = WB_hlt;

endmodule
