module MEMWBBuf (
    input clk,    // Clock
    input rst,  // Asynchronous reset active low
    input stall,
    input flush,
    // wb
    input regdst_in,
    input regwrite_in,
    input [1:0]memtoreg_in,
    // opr
    input [15:0]alu_out_in,
    input [15:0]mem_out_in,
    input [3:0]reg_source_in,

    // wb
    output regdst_out,
    output regwrite_out,
    output [1:0]memtoreg_out,
    // opr
    output [15:0]alu_out_out,
    output [15:0]mem_out_out,
    output [3:0]reg_source_out
);

    wire [15:0]control_in;
    wire [15:0]control_out;

    wire [15:0]control_reg_in;
    wire [15:0]alu_out_reg_in;
    wire [15:0]mem_out_reg_in;

    assign control_in = {8'b0,regdst_in, regwrite_in, memtoreg_in, reg_source_in};
    assign {regdst_out, regwrite_out, memtoreg_out, reg_source_out} = control_out[7:0];

    assign control_reg_in = stall ? control_out : (flush ? 16'h0 : control_in);
    assign alu_out_reg_in = stall ? alu_out_out : (flush ? 16'h0 : alu_out_in);
    assign mem_out_reg_in = stall ? mem_out_out : (flush ? 16'h0 : mem_out_in);

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

    Register U_mem_out_reg (
        .clk(clk),  
        .rst(rst), 
        .D(mem_out_reg_in), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(mem_out_out), 
        .Bitline2()
    );

endmodule // MEMWBBuf