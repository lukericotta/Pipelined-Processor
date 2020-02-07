module MEMWB(clk, rst, D, writeReg, Q);
input clk, rst, writeReg;
input [59:0] D;
output [59:0] Q; //assign output based on matching condition code with flag conditions assuming (Z, V, N).


//flag
 dff dff1(.q(Q[0]), .d(D[0]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff2(.q(Q[1]), .d(D[1]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff3(.q(Q[2]), .d(D[2]), .wen(writeReg), .clk(clk), .rst(rst));

//ALUout/MemSrc1
 dff dff4(.q(Q[3]), .d(D[3]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff5(.q(Q[4]), .d(D[4]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff6(.q(Q[5]), .d(D[5]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff7(.q(Q[6]), .d(D[6]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff8(.q(Q[7]), .d(D[7]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff9(.q(Q[8]), .d(D[8]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff10(.q(Q[9]), .d(D[9]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff11(.q(Q[10]), .d(D[10]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff12(.q(Q[11]), .d(D[11]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff13(.q(Q[12]), .d(D[12]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff14(.q(Q[13]), .d(D[13]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff15(.q(Q[14]), .d(D[14]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff16(.q(Q[15]), .d(D[15]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff17(.q(Q[16]), .d(D[16]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff18(.q(Q[17]), .d(D[17]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff19(.q(Q[18]), .d(D[18]), .wen(writeReg), .clk(clk), .rst(rst));
 
//MemOut
 dff dff20(.q(Q[19]), .d(D[19]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff21(.q(Q[20]), .d(D[20]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff22(.q(Q[21]), .d(D[21]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff23(.q(Q[22]), .d(D[22]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff24(.q(Q[23]), .d(D[23]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff25(.q(Q[24]), .d(D[24]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff26(.q(Q[25]), .d(D[25]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff27(.q(Q[26]), .d(D[26]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff28(.q(Q[27]), .d(D[27]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff29(.q(Q[28]), .d(D[28]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff30(.q(Q[29]), .d(D[29]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff31(.q(Q[30]), .d(D[30]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff32(.q(Q[31]), .d(D[31]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff33(.q(Q[32]), .d(D[32]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff34(.q(Q[33]), .d(D[33]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff35(.q(Q[34]), .d(D[34]), .wen(writeReg), .clk(clk), .rst(rst));
 
 //output of mux for writeback
 dff dff36(.q(Q[35]), .d(D[35]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff37(.q(Q[36]), .d(D[36]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff38(.q(Q[37]), .d(D[37]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff39(.q(Q[38]), .d(D[38]), .wen(writeReg), .clk(clk), .rst(rst));
 
 //MemToReg control signal
 dff dff40(.q(Q[39]), .d(D[39]), .wen(writeReg), .clk(clk), .rst(rst));
 
 //regWrite control singal
 dff dff41(.q(Q[40]), .d(D[40]), .wen(writeReg), .clk(clk), .rst(rst));
 
 //RegWriteSelect control singal
 dff dff42(.q(Q[41]), .d(D[41]), .wen(writeReg), .clk(clk), .rst(rst));

dff dff420(.q(Q[42]), .d(D[42]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff43(.q(Q[43]), .d(D[43]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff44(.q(Q[44]), .d(D[44]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff45(.q(Q[45]), .d(D[45]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff46(.q(Q[46]), .d(D[46]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff47(.q(Q[47]), .d(D[47]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff48(.q(Q[48]), .d(D[48]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff49(.q(Q[49]), .d(D[49]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff50(.q(Q[50]), .d(D[50]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff51(.q(Q[51]), .d(D[51]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff52(.q(Q[52]), .d(D[52]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff53(.q(Q[53]), .d(D[53]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff54(.q(Q[54]), .d(D[54]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff55(.q(Q[55]), .d(D[55]), .wen(writeReg), .clk(clk), .rst(rst)); 
 dff dff56(.q(Q[56]), .d(D[56]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff57(.q(Q[57]), .d(D[57]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff58(.q(Q[58]), .d(D[58]), .wen(writeReg), .clk(clk), .rst(rst));
 dff dff59(.q(Q[59]), .d(D[59]), .wen(writeReg), .clk(clk), .rst(rst));
endmodule 