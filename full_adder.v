module full_adder(A, B, Cin, Sum, Cout);
 
	input  A;
	input  B;
	input  Cin;
	output Sum;
	output Cout;
	
	assign Sum = A ^  B ^ Cin;
	assign Cout = (A & B) | (A & Cin) | (B & Cin);


endmodule
