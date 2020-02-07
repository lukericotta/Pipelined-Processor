module PSA_16bit (Sum, Error, A, B);
input [15:0] A, B;  	// Input data values 
output [15:0] Sum;  // Sum output 
output Error;  	// To indicate overflows
wire [3:0] overflow_4; 

//instantiate adders
addsub_4bit add_1(.Sum(Sum[3:0]), .Ovfl(overflow_4[0]), .A(A[3:0]), .B(B[3:0]), .sub(1'b0));
addsub_4bit add_2(.Sum(Sum[7:4]), .Ovfl(overflow_4[1]), .A(A[7:4]), .B(B[7:4]), .sub(1'b0));
addsub_4bit add_3(.Sum(Sum[11:8]), .Ovfl(overflow_4[2]), .A(A[11:8]), .B(B[11:8]), .sub(1'b0));
addsub_4bit add_4(.Sum(Sum[15:12]), .Ovfl(overflow_4[3]), .A(A[15:12]), .B(B[15:12]), .sub(1'b0));

assign Error = |overflow_4;

endmodule 
