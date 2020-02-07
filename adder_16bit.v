module adder_16bit(A, B, Cin, Sum, overflow);
input [15:0] A, B;
input Cin;
output [15:0] Sum;
output overflow; //, P, G;

wire [2:0] Couts;
wire [3:0] Gs, Ps;
wire preCout;

//instantiate modules
look_ahead_4bit Bigadder1(.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .Sum(Sum[3:0]), .Cout(Couts[0]), .G(Gs[0]), .P(Ps[0]));
look_ahead_4bit Bigadder2(.A(A[7:4]), .B(B[7:4]), .Cin(Couts[0]), .Sum(Sum[7:4]), .Cout(Couts[1]), .G(Gs[1]), .P(Ps[1]));
look_ahead_4bit Bigadder3(.A(A[11:8]), .B(B[11:8]), .Cin(Couts[1]), .Sum(Sum[11:8]), .Cout(Couts[2]), .G(Gs[2]), .P(Ps[2]));
look_ahead_4bit Bigadder4(.A(A[15:12]), .B(B[15:12]), .Cin(Couts[2]), .Sum(Sum[15:12]), .Cout(preCout), .G(Gs[3]), .P(Ps[3]));
//possibly useless
//adder_logic(.Gs(Gs), .Ps(Ps), .Cin(Cin), .Couts(Couts), .Cout(Cout), .G(G), .P(P));


assign overflow = (~Sum[15] & A[15] & B[15]) ? A[15] :
	      (Sum[15] & ~A[15] & ~B[15]) ? ~A[15]:
	      (A[15] & ~A[15]) ;

endmodule 