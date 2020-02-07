module CLA8bit(
	input [7:0] A,
	input [7:0] B,
	input SUB,
	output [7:0] SUM,
	output Cout);

	wire [8:0] w_carry;
	wire [7:0] w_generate, w_propogate;


	full_adder FA1(.A(A[0]), .B(B[0]), .Cin(w_carry[0]), .Sum(SUM[0]), .Cout());
	full_adder FA2(.A(A[1]), .B(B[1]), .Cin(w_carry[1]), .Sum(SUM[1]), .Cout());
	full_adder FA3(.A(A[2]), .B(B[2]), .Cin(w_carry[2]), .Sum(SUM[2]), .Cout());
	full_adder FA4(.A(A[3]), .B(B[3]), .Cin(w_carry[3]), .Sum(SUM[3]), .Cout());
	
	full_adder FA5(.A(A[4]), .B(B[4]), .Cin(w_carry[4]), .Sum(SUM[4]), .Cout());
	full_adder FA6(.A(A[5]), .B(B[5]), .Cin(w_carry[5]), .Sum(SUM[5]), .Cout());
	full_adder FA7(.A(A[6]), .B(B[6]), .Cin(w_carry[6]), .Sum(SUM[6]), .Cout());
	full_adder FA8(.A(A[7]), .B(B[7]), .Cin(w_carry[7]), .Sum(SUM[7]), .Cout());

	
	
	assign w_generate[0] = A[0] & B[0];
	assign w_generate[1] = A[1] & B[1];
	assign w_generate[2] = A[2] & B[2];
	assign w_generate[3] = A[3] & B[3];
	
	assign w_generate[4] = A[4] & B[4];
	assign w_generate[5] = A[5] & B[5];
	assign w_generate[6] = A[6] & B[6];
	assign w_generate[7] = A[7] & B[7];
	
	

	assign w_propogate[0] = A[0] | B[0];
	assign w_propogate[1] = A[1] | B[1];
  	assign w_propogate[2] = A[2] | B[2];
  	assign w_propogate[3] = A[3] | B[3];
	
	assign w_propogate[4] = A[4] | B[4];
	assign w_propogate[5] = A[5] | B[5];
  	assign w_propogate[6] = A[6] | B[6];
  	assign w_propogate[7] = A[7] | B[7];
 
 
 
  	assign w_carry[0] = SUB;
  	assign w_carry[1] = w_generate[0] | (w_propogate[0] & w_carry[0]);
  	assign w_carry[2] = w_generate[1] | (w_propogate[1] & w_carry[1]);
  	assign w_carry[3] = w_generate[2] | (w_propogate[2] & w_carry[2]);
  	assign w_carry[4] = w_generate[3] | (w_propogate[3] & w_carry[3]);
	
  	assign w_carry[5] = w_generate[4] | (w_propogate[4] & w_carry[4]);
  	assign w_carry[6] = w_generate[5] | (w_propogate[5] & w_carry[5]);
  	assign w_carry[7] = w_generate[6] | (w_propogate[6] & w_carry[6]);
  	assign w_carry[8] = w_generate[7] | (w_propogate[7] & w_carry[7]);
	

   
  	assign Cout = w_carry[8];



endmodule
