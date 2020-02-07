module control(opCode, memRead, memWrite, memToReg, ALUsrc, regWrite, branch, writeFlag, regWriteSelect);
input wire [3:0] opCode ;
output reg memRead; //1 if mem should be read, 0 if not
output reg memWrite; //1 if memWrite enabled
output reg memToReg; //1 if mem should be read from ALU supplied address, 0 if ALU value passed back
output reg ALUsrc;   //1 is Rt (from inst[3:0]) , 0 is sign extended immediate (inst [3:0] or however big immediate is)
output reg regWrite; //1 if reg should be written, 0 if not
output reg branch; // 1 if branch logic should be checked, 0 if not
output reg writeFlag; //1 if flag values should be updated based on ALU result, 0 if not
output reg regWriteSelect; //select between (0)PC data and (1) alu/memory data to write to reg

//case statement to assign outputs for each possible opcode
always@* case(opCode)

4'b0000 : begin //ADD
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 1;
regWrite = 1;
branch = 0;
writeFlag = 1;
regWriteSelect = 1;
end

4'b0001 : begin //SUB
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 1;
regWrite = 1;
branch = 0;
writeFlag = 1;
regWriteSelect = 1;
end

4'b0010 : begin //XOR
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 1;
regWrite = 1;
branch = 0;
writeFlag = 1;
regWriteSelect = 1;
end

4'b0011 : begin //RED
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 1;
regWrite = 1;
branch = 0;
writeFlag = 0;
regWriteSelect = 1;
end

4'b0100 : begin //SLL
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 0;
regWrite = 1;
branch = 0;
writeFlag = 1;
regWriteSelect = 1;
end

4'b0101 : begin //SRA
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 0;
regWrite = 1;
branch = 0;
writeFlag = 1;
regWriteSelect = 1;
end

4'b0110 : begin //ROR
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 0;
regWrite = 1;
branch = 0;
writeFlag = 1;
regWriteSelect = 1;
end

4'b0111 : begin //PADDSB
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 1;
regWrite = 1;
branch = 0;
writeFlag = 0;
regWriteSelect = 1;
end

4'b1000 : begin //LW
memRead = 1;
memWrite = 0;
memToReg = 1;
ALUsrc = 0;
regWrite = 1;
branch = 0;
writeFlag = 0;
regWriteSelect = 1;
end

4'b1001 : begin //SW
memRead = 0;
memWrite = 1;
memToReg = 0;
ALUsrc = 0;
regWrite = 0;
branch = 0;
writeFlag = 0;
regWriteSelect = 1;
end

4'b1010 : begin //LLB
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 0;
regWrite = 1;
branch = 0;
writeFlag = 0;
regWriteSelect = 1;
end

4'b1011 : begin //LHB
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 0;
regWrite = 1;
branch = 0;
writeFlag = 0;
regWriteSelect = 1;
end

4'b1100 : begin //B
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 1;
regWrite = 0;
branch = 1;
writeFlag = 0;
regWriteSelect = 1;
end

4'b1101 : begin //BR
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 1;
regWrite = 0;
branch = 1;
writeFlag = 0;
regWriteSelect = 1;
end

4'b1110 : begin //PCS
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 1;
regWrite = 1;
branch = 0;
writeFlag = 0;
regWriteSelect = 0;
end

default : begin  //HLT, 1'b1111
memRead = 0;
memWrite = 0;
memToReg = 0;
ALUsrc = 0;
regWrite = 0;
branch = 0;
writeFlag = 0;
regWriteSelect = 0;
end

endcase



endmodule

