module IFIDBuf (
    input clk,    // Clock
    input rst,  // Asynchronous reset active low
    input stall,
    input flush,
    input [15:0]pc_in,
    input [15:0]inst_in,
    output [15:0]pc_out,
    output [15:0]inst_out
);
    
    wire [15:0]pc_reg_in;
    wire [15:0]inst_reg_in;

    assign pc_reg_in = stall ? pc_out : (flush ? 16'h0 : pc_in);
    assign inst_reg_in = stall ? inst_out : (flush ? 16'h0 : inst_in);

    Register U_pc_reg (
        .clk(clk),  
        .rst(rst), 
        .D(pc_reg_in), 
        .WriteReg(1'b1), 
        .ReadEnable1(1'b1), 
        .ReadEnable2(1'b0), 
        .Bitline1(pc_out), 
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

endmodule // IFIDBuf