module HazardDetectUnit (
    input clk,
    input rst,
    input [3:0]opcode, // inst in ID
    input prebranch, // branch EX
    input preprebranch, // branch in MEM
    input mem_branchtaken, // branch taken in MEM
    input [3:0]ifidRegRs,
    input [3:0]ifidRegRt,
    input idexMemRead,

    input ifidMemWrite,
    
    input [3:0]idexRegRt,
    output branch_flush, // branch flush is branch taken, only working on EXMEMBuf. due to IFID can be flush
    output loaduse_stall_flush,
    output halt_stall_pc, // stall inst after asserted
    output halt // stop entire cpu after asserted, if halt is after branch and if not taken, should be deasserted.
);
    

    wire branch_flush_d;
    wire branch_flush_2d;
    wire branch_flush_3d;
    wire branch_flush_4d;
    wire branch_flush_5d;

    wire branch_flush_3c;
    wire branch_flush_4c;
    wire branch_flush_5c;

    wire dataDet;
    wire dataDet_d;
    wire dataDet_2d;
    wire dataDet_3d;

    wire is_halt;
    wire halt_d;
    wire halt_2d;

    // Control hazard, branch

    dff U_dff0_branch(.q(branch_flush_d), .d(mem_branchtaken), .wen(1'b1), .clk(clk), .rst(rst));
    dff U_dff1_branch(.q(branch_flush_2d), .d(branch_flush_d), .wen(1'b1), .clk(clk), .rst(rst));
    dff U_dff2_branch(.q(branch_flush_3d), .d(branch_flush_2d), .wen(1'b1), .clk(clk), .rst(rst));
    dff U_dff3_branch(.q(branch_flush_4d), .d(branch_flush_3d), .wen(1'b1), .clk(clk), .rst(rst));
    dff U_dff4_branch(.q(branch_flush_5d), .d(branch_flush_4d), .wen(1'b1), .clk(clk), .rst(rst));

    assign branch_flush_3c = mem_branchtaken | branch_flush_d | branch_flush_2d;
    // assign branch_flush_5c = branch_flush | branch_flush_d | branch_flush_2d | branch_flush_3d | branch_flush_4d;

    assign branch_flush = branch_flush_3c;
    // assign branch_flush = (opcode == 4'b1100) ? 1'b1 : // B
    //                     (opcode == 4'b1101) ? 1'b1 : // BR
    //                                           1'b0;

    // Data hazard, loaduse hazard
    // assign dataDet = ((ifidRegRs == idexRegRt) & idexMemRead) ? 1'b1 :
    //                  ((ifidRegRt == idexRegRt) & idexMemRead) ? 1'b1 :
    //                                                             1'b0;

    // Data hazard, loaduse hazard, excluding load-store stall, which is mem-to-mem forwarding
    // Rt is used as the reg in both store and load
    assign dataDet = ((ifidRegRs == idexRegRt) & idexMemRead & ~ifidMemWrite) ? 1'b1 :
                     ((ifidRegRt == idexRegRt) & idexMemRead) ? 1'b1 :
                                                                                1'b0;

    dff U_dff0_loaduse(.q(dataDet_d), .d(dataDet), .wen(1'b1), .clk(clk), .rst(rst));
    dff U_dff1_loaduse(.q(dataDet_2d), .d(dataDet_d), .wen(1'b1), .clk(clk), .rst(rst));
    dff U_dff2_loaduse(.q(dataDet_3d), .d(dataDet_2d), .wen(1'b1), .clk(clk), .rst(rst));
    assign loaduse_stall_flush = dataDet;// | dataDet_d | dataDet_2d; // | dataDet_3d;

    // halt stall
    // assign is_halt = (opcode == 4'b1111) & ~prebranch & ~preprebranch;
    assign is_halt = (opcode == 4'b1111);
    dff U_dff0_halt(.q(halt_d), .d(1'b1), .wen(is_halt), .clk(clk), .rst(rst | mem_branchtaken));
    dff U_dff1_halt(.q(halt_2d), .d(1'b1), .wen(halt_d), .clk(clk), .rst(rst | mem_branchtaken));
    dff U_dff4_halt(.q(halt), .d(1'b1), .wen(halt_2d), .clk(clk), .rst(rst | mem_branchtaken));

    // assign halt_stall_pc = is_halt | halt_d;
    assign halt_stall_pc = (is_halt | halt_d) & ~mem_branchtaken;

endmodule