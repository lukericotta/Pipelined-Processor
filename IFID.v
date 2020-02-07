module IFID(clk, rst, D, writeReg, Q);
input clk, rst, writeReg;
input [34:0] D;
output [34:0] Q;

// instantiate modules //
//instruction from PC
 dff dff0(.q(Q[0]), .d(D[0]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff1(.q(Q[1]), .d(D[1]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff2(.q(Q[2]), .d(D[2]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff3(.q(Q[3]), .d(D[3]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff4(.q(Q[4]), .d(D[4]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff5(.q(Q[5]), .d(D[5]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff6(.q(Q[6]), .d(D[6]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff7(.q(Q[7]), .d(D[7]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff8(.q(Q[8]), .d(D[8]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff9(.q(Q[9]), .d(D[9]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff10(.q(Q[10]), .d(D[10]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff11(.q(Q[11]), .d(D[11]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff12(.q(Q[12]), .d(D[12]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff13(.q(Q[13]), .d(D[13]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff14(.q(Q[14]), .d(D[14]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff15(.q(Q[15]), .d(D[15]), .wen(writeReg), .clk(clk), .rst(rst)); 

//currInstruction
 dff dff16(.q(Q[16]), .d(D[16]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff17(.q(Q[17]), .d(D[17]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff18(.q(Q[18]), .d(D[18]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff19(.q(Q[19]), .d(D[19]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff20(.q(Q[20]), .d(D[20]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff21(.q(Q[21]), .d(D[21]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff22(.q(Q[22]), .d(D[22]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff23(.q(Q[23]), .d(D[23]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff24(.q(Q[24]), .d(D[24]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff25(.q(Q[25]), .d(D[25]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff26(.q(Q[26]), .d(D[26]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff27(.q(Q[27]), .d(D[27]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff28(.q(Q[28]), .d(D[28]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff29(.q(Q[29]), .d(D[29]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff30(.q(Q[30]), .d(D[30]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff31(.q(Q[31]), .d(D[31]), .wen(writeReg), .clk(clk), .rst(rst)); 

//flag
 dff dff32(.q(Q[32]), .d(D[32]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff33(.q(Q[33]), .d(D[33]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff34(.q(Q[34]), .d(D[34]), .wen(writeReg), .clk(clk), .rst(rst)); 


endmodule 