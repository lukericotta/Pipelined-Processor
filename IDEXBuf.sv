module IDEXBuf (
    input clk,    // Clock
    input rst,  // Asynchronous reset active low
    input stall,
    input flush,
    // wb
    input regdst_in,
    input regwrite_in,
    input [1:0]memtoreg_in,
    // mem
    input memread_in,
    input memwrite_in,
    input branch_in,
    // ex
    input [3:0]aluop_in,
    input alusrc_in,
    // opr
    input [15:0]inst_in,
    input [15:0]reg_1_in,
    input [15:0]reg_2_in,
    input [15:0]imm_in,
    input [3:0]IFIDRegRs_in,
    input [3:0]IFIDRegRt1_in,
    input [3:0]IFIDRegRt2_in,
    input [3:0]IFIDRegRd_in,

    // wb
    output regdst_out,
    output regwrite_out,
    output [1:0]memtoreg_out,
    // mem
    output memread_out,
    output memwrite_out,
    output branch_out,
    // ex
    output [3:0]aluop_out,
    output alusrc_out,
    // opr
    output [15:0]inst_out,
    output [15:0]reg_1_out,
    output [15:0]reg_2_out,
    output [15:0]imm_out,
    output [3:0]IFIDRegRs_out,
    output [3:0]IFIDRegRt1_out,
    output [3:0]IFIDRegRt2_out,
    output [3:0]IFIDRegRd_out
);
    
    wire [15:0]control_in;
    wire [15:0]source_in;
    wire [15:0]control_out;
    wire [15:0]source_out;

    wire [15:0]control_reg_in;
    wire [15:0]reg_1_reg_in;
    wire [15:0]reg_2_reg_in;
    wire [15:0]imm_reg_in;
    wire [15:0]source_reg_in;
    wire [15:0]inst_reg_in;

    assign control_in = {regdst_in, regwrite_in, memtoreg_in, memread_in, memwrite_in, branch_in, aluop_in, alusrc_in};
    assign {regdst_out, regwrite_out, memtoreg_out, memread_out, memwrite_out, branch_out, aluop_out, alusrc_out} = control_out;
    assign source_in = {IFIDRegRs_in, IFIDRegRt1_in, IFIDRegRt2_in, IFIDRegRd_in};
    assign {IFIDRegRs_out, IFIDRegRt1_out, IFIDRegRt2_out, IFIDRegRd_out} = source_out;
    
    assign control_reg_in = stall ? control_out : (flush ? 16'h0 : control_in);
    assign reg_1_reg_in = stall ? reg_1_out : (flush ? 16'h0 : reg_1_in);
    assign reg_2_reg_in = stall ? reg_2_out : (flush ? 16'h0 : reg_2_in);
    assign imm_reg_in = stall ? imm_out : (flush ? 16'h0 : imm_in);
    assign source_reg_in = stall ? source_out : (flush ? 16'h0 : source_in);
    assign inst_reg_in = stall ? inst_out : (flush ? 16'h0 : inst_in);

    Register U_control_reg (
        .clk(clk),  
        .rst(rst), 
        .D(control_reg_in), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(control_out), 
        .Bitline2()
    );

    Register U_reg_1_reg (
        .clk(clk),  
        .rst(rst), 
        .D(reg_1_reg_in), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(reg_1_out), 
        .Bitline2()
    );

    Register U_reg_2_reg (
        .clk(clk),  
        .rst(rst), 
        .D(reg_2_reg_in), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(reg_2_out), 
        .Bitline2()
    );

    Register U_imm_reg (
        .clk(clk),  
        .rst(rst), 
        .D(imm_reg_in), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(imm_out), 
        .Bitline2()
    );

    Register U_source_reg (
        .clk(clk),  
        .rst(rst), 
        .D(source_reg_in), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(source_out), 
        .Bitline2()
    );

    Register U_inst_reg (
        .clk(clk),  
        .rst(rst), 
        .D(inst_reg_in), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(inst_out), 
        .Bitline2()
    );

endmodule // IDEXBuf