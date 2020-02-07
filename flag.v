module flag(clk, rst, D, writeReg, Q);
input clk, rst, writeReg;
input [2:0] D;
output [2:0] Q; //assign output based on matching condition code with flag conditions assuming (Z, V, N).

//instantiate module
 dff dff1(.q(Q[0]), .d(D[0]), .wen(writeReg), .clk(clk), .rst(rst)); //Z
 dff dff2(.q(Q[1]), .d(D[1]), .wen(writeReg), .clk(clk), .rst(rst)); //V
 dff dff3(.q(Q[2]), .d(D[2]), .wen(writeReg), .clk(clk), .rst(rst)); //N

endmodule 