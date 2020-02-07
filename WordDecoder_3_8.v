module WordDecoder_3_8(input [2:0] RegId, input WriteReg, output [7:0] Wordline);

assign Wordline = (WriteReg == 1'b1) ? (
		  (RegId == 3'b000) ? 8'h01 :
		  (RegId == 3'b001) ? 8'h02 :
		  (RegId == 3'b010) ? 8'h04 :
		  (RegId == 3'b011) ? 8'h08 :
		  (RegId == 3'b100) ? 8'h10 :
		  (RegId == 3'b101) ? 8'h20 :
		  (RegId == 3'b110) ? 8'h40 :
		  (RegId == 3'b111) ? 8'h80 :
					8'h000) 
						: 8'h000;

endmodule
