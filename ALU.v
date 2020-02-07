module ALU(ALU_Out, ALU_In1, ALU_In2, Opcode, FLAG);
	
	input [15:0] ALU_In1, ALU_In2;
	input [3:0] Opcode;
	
	//different outputs for different opcodes
	wire [15:0] Add_Out, RED_Out, SLL_Out, SRA_Out, ROR_Out, PADDSB_Out;
	reg [15:0] ALU_r;
	output [15:0] ALU_Out;
	wire OV, PADDSB_OV;
	output [2:0] FLAG;
	
	
	wire positiveAdd, negativeAdd;
	wire [15:0] ALU_In2_not;

	assign ALU_In2_not = (Opcode == 4'b0001) ? ~ALU_In2 : ALU_In2;
	assign positiveAdd = ~ALU_In1[15] & ~ALU_In2_not[15];
	assign negativeAdd = ALU_In1[15] & ALU_In2_not[15];
	
	CLA16bit adder1(.A(ALU_In1), .B(ALU_In2_not), .SUB(Opcode[0]), .SUM(Add_Out), .Cout());

	assign OV = positiveAdd & ALU_Out[15] | negativeAdd & ~ALU_Out[15];	//ASSIGN FLAG BIT
	assign FLAG[2] = ALU_Out[15];
	assign FLAG[1] = OV | PADDSB_OV;
	assign FLAG[0] = (ALU_Out == 16'h0000) ? (1'b1) : (1'b0);
	
	PADDSB PADDSB1(.Sum(PADDSB_Out), .Error(PADDSB_OV), .A(ALU_In1), .B(ALU_In2));
	Red RED1(.rs(ALU_In1), .rt(ALU_In2), .rd(RED_Out));
	sll SLL1(.Shift_Out(SLL_Out), .Shift_In(ALU_In1), .Shift_Val(ALU_In2));
	sra SRA1(.Shift_Out(SRA_Out), .Shift_In(ALU_In1), .Shift_Val(ALU_In2));
	ror ROR1(.Rotate_Out(ROR_Out), .Rotate_In(ALU_In1), .Rotate_Val(ALU_In2));

	always @ (ALU_In1 or ALU_In2 or Opcode) 
	begin
		case (Opcode) 
 			0: begin ALU_r = (OV) ? (positiveAdd ? 16'h7fff : 16'h8000) : Add_Out; end
			1: begin ALU_r = (OV) ? (positiveAdd ? 16'h7fff : 16'h8000) : Add_Out; end
 			2: begin ALU_r = (ALU_In1 ^ ALU_In2); end
			3: begin ALU_r = RED_Out; end
 			4: begin ALU_r = SLL_Out; end
			5: begin ALU_r = SRA_Out; end
 			6: begin ALU_r = ROR_Out; end
			7: begin ALU_r = PADDSB_Out; end
			8: begin ALU_r = (Add_Out & 16'hFFFE); end
			9: begin ALU_r = (Add_Out & 16'hFFFE); end
			10: begin ALU_r = (ALU_In1 & 16'hFF00) | ALU_In2; end
			default: begin ALU_r = (ALU_In1 & 16'h00FF) | (ALU_In2 << 8); end
		endcase 
	end

assign ALU_Out = ALU_r;


endmodule
