module CLA4bit(
	input [3:0] A,
	input [3:0] B,
	input SUB,
	output [3:0] SUM,
	output Cout);

	wire [4:0] w_carry;
	wire [3:0] w_generate, w_propogate;


	full_adder FA1(.A(A[0]), .B(B[0]), .Cin(w_carry[0]), .Sum(SUM[0]), .Cout());
	full_adder FA2(.A(A[1]), .B(B[1]), .Cin(w_carry[1]), .Sum(SUM[1]), .Cout());
	full_adder FA3(.A(A[2]), .B(B[2]), .Cin(w_carry[2]), .Sum(SUM[2]), .Cout());
	full_adder FA4(.A(A[3]), .B(B[3]), .Cin(w_carry[3]), .Sum(SUM[3]), .Cout());

	assign w_generate[0] = A[0] & B[0];
	assign w_generate[1] = A[1] & B[1];
	assign w_generate[2] = A[2] & B[2];
	assign w_generate[3] = A[3] & B[3];

	assign w_propogate[0] = A[0] | B[0];
	assign w_propogate[1] = A[1] | B[1];
  	assign w_propogate[2] = A[2] | B[2];
  	assign w_propogate[3] = A[3] | B[3];
 
  	assign w_carry[0] = SUB;
  	assign w_carry[1] = w_generate[0] | (w_propogate[0] & w_carry[0]);
  	assign w_carry[2] = w_generate[1] | (w_propogate[1] & w_carry[1]);
  	assign w_carry[3] = w_generate[2] | (w_propogate[2] & w_carry[2]);
  	assign w_carry[4] = w_generate[3] | (w_propogate[3] & w_carry[3]);
   
  	assign Cout = w_carry[4];



endmodule
