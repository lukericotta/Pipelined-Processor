module PC_control(branch, C, I, F, PC_in , PC_out, Br, Stall, branchTaken, Flush);
input branch, Br;
input Flush;
input [2:0] C, F;
input [15:0] I;
input [15:0] PC_in;
input Stall;
output [15:0] PC_out;
output branchTaken;

//wire [15:0] addToPc;
wire [15:0] incPC;
wire [15:0] noAdd2PC;
wire [15:0] PCandI;
wire [15:0] prePC_out;
wire overflow1, overflow2, takebranch;


//instantiate adder to compute PC + 2
adder_16bit addPC2(.A(PC_in), .B(16'h0002), .Cin(1'b0), .Sum(incPC), .overflow(overflow1));
//instantiate adder to compute I + (PC + 2)
adder_16bit addPCI(.A(noAdd2PC), .B(I), .Cin(1'b0), .Sum(PCandI), .overflow(overflow2));

assign noAdd2PC = (Flush) ? PC_in : incPC;


//assign output based on matching condition code with flag conditions assuming (Z, V, N).  Z == LSB, N == MSB
//assigning to 1 bit to act as mux for decoder to select between adding 2 or immediate value, instead
//of assigning that value, in order to stop from having 2 adders
assign takebranch = ((C == 3'b000) & (F[0] == 1'b0)) ? 1'b1 :
		    ((C == 3'b001) & (F[0] == 1'b1)) ? 1'b1 :
		    ((C == 3'b010) & (F[0] == 1'b0) & (F[2] == 1'b0)) ? 1'b1 :
		    ((C == 3'b011) & (F[2] == 1'b1)) ? 1'b1 :
		    ((C == 3'b100) & ((F[0] == 1'b1) | ((F[0] == 1'b0) & (F[2] == 1'b0)))) ? 1'b1 :
		    ((C == 3'b101) & ((F[0] == 1'b1) | (F[2] == 1'b1))) ? 1'b1 :
		    ((C == 3'b110) & (F[1] == 1'b1)) ? 1'b1 :
		    (C == 3'b111) ? 1'b1 :
	            1'b0;

assign prePC_out = ((branch == 1'b1) & (takebranch == 1'b1)) ? ( (Br == 1'b1) ? I : PCandI ):
		incPC;

//add Stall
assign PC_out = (Stall) ? PC_in : prePC_out ;
assign branchTaken = ((takebranch == 1'b1) & (branch == 1'b1)) ? 1'b1 : 1'b0;

endmodule
