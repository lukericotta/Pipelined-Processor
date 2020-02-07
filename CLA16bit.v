module CLA16bit(
	input [15:0] A,
	input [15:0] B,
	input SUB,
	output [15:0] SUM,
	output Cout);

	wire [16:0] w_carry;
	wire [15:0] w_generate, w_propogate;


	full_adder FA1(.A(A[0]), .B(B[0]), .Cin(w_carry[0]), .Sum(SUM[0]), .Cout());
	full_adder FA2(.A(A[1]), .B(B[1]), .Cin(w_carry[1]), .Sum(SUM[1]), .Cout());
	full_adder FA3(.A(A[2]), .B(B[2]), .Cin(w_carry[2]), .Sum(SUM[2]), .Cout());
	full_adder FA4(.A(A[3]), .B(B[3]), .Cin(w_carry[3]), .Sum(SUM[3]), .Cout());
	
	full_adder FA5(.A(A[4]), .B(B[4]), .Cin(w_carry[4]), .Sum(SUM[4]), .Cout());
	full_adder FA6(.A(A[5]), .B(B[5]), .Cin(w_carry[5]), .Sum(SUM[5]), .Cout());
	full_adder FA7(.A(A[6]), .B(B[6]), .Cin(w_carry[6]), .Sum(SUM[6]), .Cout());
	full_adder FA8(.A(A[7]), .B(B[7]), .Cin(w_carry[7]), .Sum(SUM[7]), .Cout());

	full_adder FA9(.A(A[8]), .B(B[8]), .Cin(w_carry[8]), .Sum(SUM[8]), .Cout());
	full_adder FA10(.A(A[9]), .B(B[9]), .Cin(w_carry[9]), .Sum(SUM[9]), .Cout());
	full_adder FA11(.A(A[10]), .B(B[10]), .Cin(w_carry[10]), .Sum(SUM[10]), .Cout());
	full_adder FA12(.A(A[11]), .B(B[11]), .Cin(w_carry[11]), .Sum(SUM[11]), .Cout());
	
	full_adder FA13(.A(A[12]), .B(B[12]), .Cin(w_carry[12]), .Sum(SUM[12]), .Cout());
	full_adder FA14(.A(A[13]), .B(B[13]), .Cin(w_carry[13]), .Sum(SUM[13]), .Cout());
	full_adder FA15(.A(A[14]), .B(B[14]), .Cin(w_carry[14]), .Sum(SUM[14]), .Cout());
	full_adder FA16(.A(A[15]), .B(B[15]), .Cin(w_carry[15]), .Sum(SUM[15]), .Cout());

	
	
	assign w_generate[0] = A[0] & B[0];
	assign w_generate[1] = A[1] & B[1];
	assign w_generate[2] = A[2] & B[2];
	assign w_generate[3] = A[3] & B[3];
	
	assign w_generate[4] = A[4] & B[4];
	assign w_generate[5] = A[5] & B[5];
	assign w_generate[6] = A[6] & B[6];
	assign w_generate[7] = A[7] & B[7];
	
	assign w_generate[8] = A[8] & B[8];
	assign w_generate[9] = A[9] & B[9];
	assign w_generate[10] = A[10] & B[10];
	assign w_generate[11] = A[11] & B[11];
	
	assign w_generate[12] = A[12] & B[12];
	assign w_generate[13] = A[13] & B[13];
	assign w_generate[14] = A[14] & B[14];
	assign w_generate[15] = A[15] & B[15];
	
	

	assign w_propogate[0] = A[0] | B[0];
	assign w_propogate[1] = A[1] | B[1];
  	assign w_propogate[2] = A[2] | B[2];
  	assign w_propogate[3] = A[3] | B[3];
	
	assign w_propogate[4] = A[4] | B[4];
	assign w_propogate[5] = A[5] | B[5];
  	assign w_propogate[6] = A[6] | B[6];
  	assign w_propogate[7] = A[7] | B[7];
	
	assign w_propogate[8] = A[8] | B[8];
	assign w_propogate[9] = A[9] | B[9];
  	assign w_propogate[10] = A[10] | B[10];
  	assign w_propogate[11] = A[11] | B[11];
	
	assign w_propogate[12] = A[12] | B[12];
	assign w_propogate[13] = A[13] | B[13];
  	assign w_propogate[14] = A[14] | B[14];
  	assign w_propogate[15] = A[15] | B[15];
 
 
 
  	assign w_carry[0] = SUB;
  	assign w_carry[1] = w_generate[0] | (w_propogate[0] & w_carry[0]);
  	assign w_carry[2] = w_generate[1] | (w_propogate[1] & w_carry[1]);
  	assign w_carry[3] = w_generate[2] | (w_propogate[2] & w_carry[2]);
  	assign w_carry[4] = w_generate[3] | (w_propogate[3] & w_carry[3]);
	
  	assign w_carry[5] = w_generate[4] | (w_propogate[4] & w_carry[4]);
  	assign w_carry[6] = w_generate[5] | (w_propogate[5] & w_carry[5]);
  	assign w_carry[7] = w_generate[6] | (w_propogate[6] & w_carry[6]);
  	assign w_carry[8] = w_generate[7] | (w_propogate[7] & w_carry[7]);
	
  	assign w_carry[9] = w_generate[8] | (w_propogate[8] & w_carry[8]);
  	assign w_carry[10] = w_generate[9] | (w_propogate[9] & w_carry[9]);
  	assign w_carry[11] = w_generate[10] | (w_propogate[10] & w_carry[10]);
  	assign w_carry[12] = w_generate[11] | (w_propogate[11] & w_carry[11]);
	
  	assign w_carry[13] = w_generate[12] | (w_propogate[12] & w_carry[12]);
  	assign w_carry[14] = w_generate[13] | (w_propogate[13] & w_carry[13]);
  	assign w_carry[15] = w_generate[14] | (w_propogate[14] & w_carry[14]);
  	assign w_carry[16] = w_generate[15] | (w_propogate[15] & w_carry[15]);
	

   
  	assign Cout = w_carry[16];



endmodule
