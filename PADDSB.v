module PADDSB (Sum, Error, A, B);
	input signed [15:0] A, B; // Input data values
	output signed [15:0] Sum; // Sum output
	wire [3:0] OV, carry;
	output Error; // To indicate overflows
	wire [15:0] w_Sum;
	wire PA03, PA47, PA811, PA1215, NA03, NA47, NA811, NA1215;
	
	assign PA03 = ~A[3] & ~B[3];
	assign NA03 = A[3] & B[3];
	assign PA47 = ~A[7] & ~B[7];
	assign NA47 = A[7] & B[7];
	assign PA811 = ~A[11] & ~B[11];
	assign NA811 = A[11] & B[11];
	assign PA1215 = ~A[15] & ~B[15];
	assign NA1215 = A[15] & B[15];

	CLA4bit bits03(.A(A[3:0]), .B(B[3:0]), .SUB(1'b0), .SUM(w_Sum[3:0]), .Cout());
	CLA4bit bits47(.A(A[7:4]), .B(B[7:4]), .SUB(1'b0), .SUM(w_Sum[7:4]), .Cout());
	CLA4bit bits811(.A(A[11:8]), .B(B[11:8]), .SUB(1'b0), .SUM(w_Sum[11:8]), .Cout());
	CLA4bit bits1215(.A(A[15:12]), .B(B[15:12]), .SUB(1'b0), .SUM(w_Sum[15:12]), .Cout());
	
	assign OV[0] = PA03 & w_Sum[3] | NA03 & ~w_Sum[3];
	assign OV[1] = PA47 & w_Sum[3] | NA47 & ~w_Sum[3];
	assign OV[2] = PA811 & w_Sum[3] | NA811 & ~w_Sum[3];
	assign OV[3] = PA1215 & w_Sum[3] | NA1215 & ~w_Sum[3];
	
	assign Error = |OV;
	
	assign Sum[3:0] = OV[0] ? (A[3] & B[3]) ? 4'b1000 :
						((~A[3] & ~B[3]) ? 4'b0111 : w_Sum[3:0]) : w_Sum[3:0];
	assign Sum[7:4] = OV[1] ? (A[7] & B[7]) ? 4'b1000 :
						((~A[7] & ~B[7]) ? 4'b0111 : w_Sum[7:4]) : w_Sum[7:4];
	assign Sum[11:8] = OV[2] ? (A[11] & B[11]) ? 4'b1000 :
						((~A[11] & ~B[11]) ? 4'b0111 : w_Sum[11:8]) : w_Sum[11:8];
	assign Sum[15:12] = OV[3] ? (A[15] & B[15]) ? 4'b1000 :
						((~A[15] & ~B[15]) ? 4'b0111 : w_Sum[15:12]) : w_Sum[15:12];
	
endmodule

