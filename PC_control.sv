
module PC_control(
    input clk,
    input rst,
    input [2:0]C,  // ctrlcode in ID
    input [8:0]I, // imm in EX
    input [2:0]F, // flag in MEM
    input [3:0]opcode, // inst in EX
    input branch, // branch in MEM
    input branch_flush,
    input [15:0]PC_in, // pc in IF
    input [15:0]PC_BR_in, // register output 1 in EX, for BR inst
    output [15:0]PC_out, // generated in IF and MEM, to be use as new pc
    output [15:0]PC_plus2, // generated in WB, to be used in WB for PCS write back to register file
    output branchtaken
);  
    
    // F bit functions
    // bit 0 -> sign bit, bit 1 -> overflow, bit 2 -> zero
    wire Z;
    wire V;
    wire N;

    reg branchtaken_reg;
    
    wire [15:0]opcode_padding;
    wire [15:0]mem_opcode_padding;

    wire [15:0]ex_PC_b;
    wire [15:0]mem_PC_b;

    wire [15:0]mem_PC_target;
    wire [15:0]ex_I_ls1;

    reg [15:0]PC_new;

    wire [15:0]if_PC_plus2;
    wire [15:0]id_PC_plus2;
    wire [15:0]ex_PC_plus2;
    wire [15:0]mem_PC_plus2;

    wire [15:0]mem_PC_BR_in;

    wire [3:0]mem_opcode;

    wire [15:0]ex_C;
    wire [15:0]mem_C;

    assign branchtaken = branchtaken_reg;

    Register U_C_reg0 (
        .clk(clk), 
        .rst(rst), 
        .D({13'b0,C}), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(ex_C), 
        .Bitline2()
    );

    Register U_C_reg1 (
        .clk(clk), 
        .rst(rst), 
        .D(ex_C), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(mem_C), 
        .Bitline2()
    );

    assign opcode_padding = {12'b0, opcode};
    assign mem_opcode = mem_opcode_padding[3:0];

    assign PC_out = PC_new;
    
    assign Z = F[2];
    assign V = F[1];
    assign N = F[0];

    assign ex_I_ls1 = I << 1;

    ADDSUB U_ADDSUB_0(
        .a(PC_in),
        .b(16'h2),
        .sub(1'b0),
        .sum(if_PC_plus2),
        .ovfl()
        );

    Register U_PC_plus2_reg0 (
        .clk(clk), 
        .rst(rst), 
        .D(if_PC_plus2), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(id_PC_plus2), 
        .Bitline2()
    );

    Register U_PC_plus2_reg1 (
        .clk(clk), 
        .rst(rst), 
        .D(id_PC_plus2), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(ex_PC_plus2), 
        .Bitline2()
    );

    Register U_PC_plus2_reg2 (
        .clk(clk), 
        .rst(rst), 
        .D(ex_PC_plus2), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(mem_PC_plus2), 
        .Bitline2()
    );

    Register U_PC_plus2_reg3 (
        .clk(clk), 
        .rst(rst), 
        .D(mem_PC_plus2), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(PC_plus2), 
        .Bitline2()
    );

    ADDSUB U_ADDSUB_1(
        .a(ex_PC_plus2),
        .b(ex_I_ls1),
        .sub(1'b0),
        .sum(ex_PC_b),
        .ovfl()
        );

    Register U_PC_b_reg0 (
        .clk(clk), 
        .rst(rst), 
        .D(ex_PC_b), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(mem_PC_b), 
        .Bitline2()
    );

    Register U_PC_BR_in_reg0 (
        .clk(clk), 
        .rst(rst), 
        .D(PC_BR_in), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(mem_PC_BR_in), 
        .Bitline2()
    );

    Register U_opcode_reg0 (
        .clk(clk), 
        .rst(rst | branch_flush), 
        .D(opcode_padding), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(mem_opcode_padding), 
        .Bitline2()
    );

    assign mem_PC_target = (mem_opcode == 4'hc) ? mem_PC_b : ((mem_opcode == 4'hd) ? mem_PC_BR_in : if_PC_plus2);

    always @(*) begin
        case (mem_C[2:0])
            3'b000 : PC_new = (Z == 0) ? mem_PC_target : if_PC_plus2;
            3'b001 : PC_new = (Z == 1) ? mem_PC_target : if_PC_plus2;
            3'b010 : PC_new = (Z == 0 & N == 0) ? mem_PC_target : if_PC_plus2;
            3'b011 : PC_new = (N == 1) ? mem_PC_target : if_PC_plus2;
            3'b100 : PC_new = (Z == 1 | (Z == 0 & N == 0)) ? mem_PC_target : if_PC_plus2;
            3'b101 : PC_new = (Z == 1 | N == 1) ? mem_PC_target : if_PC_plus2;
            3'b110 : PC_new = (V == 1) ? mem_PC_target : if_PC_plus2;
            3'b111 : PC_new = mem_PC_target;
            default : PC_new = if_PC_plus2;
        endcase
    end

    always @(*) begin
        case (mem_C[2:0])
            3'b000 : branchtaken_reg = (Z == 0) & branch;
            3'b001 : branchtaken_reg = (Z == 1) & branch;
            3'b010 : branchtaken_reg = (Z == 0 & N == 0) & branch;
            3'b011 : branchtaken_reg = (N == 1) & branch;
            3'b100 : branchtaken_reg = (Z == 1 | (Z == 0 & N == 0)) & branch;
            3'b101 : branchtaken_reg = (Z == 1 | N == 1) & branch;
            3'b110 : branchtaken_reg = (V == 1) & branch;
            3'b111 : branchtaken_reg = 1'b1 & branch;
            default : branchtaken_reg = 1'b0;
        endcase
    end

endmodule