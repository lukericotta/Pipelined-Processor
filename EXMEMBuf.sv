module EXMEMBuf (
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
    // opr
    input [15:0]alu_out_in,
    input [15:0]alu_src2_in,
    input [3:0]reg_source_in,

    // wb
    output regdst_out,
    output regwrite_out,
    output [1:0]memtoreg_out,
    // mem
    output memread_out,
    output memwrite_out,
    output branch_out,
    // opr
    output [15:0]alu_out_out,
    output [15:0]alu_src2_out,
    output [3:0]reg_source_out
);
    
    wire [15:0]control_in;
    wire [15:0]control_out;

    wire [15:0]control_reg_in;
    wire [15:0]alu_out_reg_in;
    wire [15:0]alu_src2_reg_in;

    assign control_in = {1'b0,regdst_in, regwrite_in, memtoreg_in, memread_in, memwrite_in, branch_in, reg_source_in};
    assign {regdst_out, regwrite_out, memtoreg_out, memread_out, memwrite_out, branch_out, reg_source_out} = control_out[14:0];
    
    assign control_reg_in = stall ? control_out : (flush ? 16'h0 : control_in);
    assign alu_out_reg_in = stall ? alu_out_out : (flush ? 16'h0 : alu_out_in);
    assign alu_src2_reg_in = stall ? alu_src2_out : (flush ? 16'h0 : alu_src2_in);

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

    Register U_alu_out_reg (
        .clk(clk),  
        .rst(rst), 
        .D(alu_out_reg_in), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(alu_out_out), 
        .Bitline2()
    );

    Register U_alu_src2_reg (
        .clk(clk),  
        .rst(rst), 
        .D(alu_src2_reg_in), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(alu_src2_out), 
        .Bitline2()
    );

endmodule // EXMEMBuf