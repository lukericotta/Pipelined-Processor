module RegisterNotInFile(clk, rst, wen, D, Q);
input clk, rst, wen;
input [15:0] D;
output [15:0] Q;

//16 flops for data storage
dff dff0(.q(Q[0]), .d(D[0]), .wen(wen), .clk(clk), .rst(rst));
dff dff1(.q(Q[1]), .d(D[1]), .wen(wen), .clk(clk), .rst(rst));
dff dff2(.q(Q[2]), .d(D[2]), .wen(wen), .clk(clk), .rst(rst));
dff dff3(.q(Q[3]), .d(D[3]), .wen(wen), .clk(clk), .rst(rst));
dff dff4(.q(Q[4]), .d(D[4]), .wen(wen), .clk(clk), .rst(rst));
dff dff5(.q(Q[5]), .d(D[5]), .wen(wen), .clk(clk), .rst(rst));
dff dff6(.q(Q[6]), .d(D[6]), .wen(wen), .clk(clk), .rst(rst));
dff dff7(.q(Q[7]), .d(D[7]), .wen(wen), .clk(clk), .rst(rst));
dff dff8(.q(Q[8]), .d(D[8]), .wen(wen), .clk(clk), .rst(rst));
dff dff9(.q(Q[9]), .d(D[9]), .wen(wen), .clk(clk), .rst(rst));
dff dff10(.q(Q[10]), .d(D[10]), .wen(wen), .clk(clk), .rst(rst));
dff dff11(.q(Q[11]), .d(D[11]), .wen(wen), .clk(clk), .rst(rst));
dff dff12(.q(Q[12]), .d(D[12]), .wen(wen), .clk(clk), .rst(rst));
dff dff13(.q(Q[13]), .d(D[13]), .wen(wen), .clk(clk), .rst(rst));
dff dff14(.q(Q[14]), .d(D[14]), .wen(wen), .clk(clk), .rst(rst));
dff dff15(.q(Q[15]), .d(D[15]), .wen(wen), .clk(clk), .rst(rst));

endmodule

