module BitCell( input clk, input rst, input D, input WriteEnable, input ReadEnable1, input
ReadEnable2, inout Bitline1, inout Bitline2);

wire q;

//instantiate flip flop
dff dff1(.q(q), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));

assign Bitline1 = (ReadEnable1 == 1'b1) ? q : 1'bz;

assign Bitline2 = (ReadEnable2 == 1'b1) ? q : 1'bz;

endmodule
