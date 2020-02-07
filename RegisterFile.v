module RegisterFile(input clk, input rst, input [3:0] SrcReg1, input [3:0] SrcReg2, input [3:0]
DstReg, input WriteReg, input [15:0] DstData, inout [15:0] SrcData1, inout [15:0] SrcData2);

wire [15:0] oneHotSource1, oneHotSource2, oneHotDest, newSrcData1, newSrcData2;


//instantiate read decoders
ReadDecoder_4_16 source1(.RegId(SrcReg1), .Wordline(oneHotSource1));
ReadDecoder_4_16 source2(.RegId(SrcReg2), .Wordline(oneHotSource2));
//instantiate write decoder
WriteDecoder_4_16 dest1(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(oneHotDest));
//instantiate 16 registers
Register reg0( .clk(clk), .rst(rst), .D(DstData), .WriteReg(1'b0), .ReadEnable1(oneHotSource1[0]), // never write to R0
.ReadEnable2(oneHotSource2[0]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg1( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[1]), .ReadEnable1(oneHotSource1[1]), 
.ReadEnable2(oneHotSource2[1]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg2( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[2]), .ReadEnable1(oneHotSource1[2]), 
.ReadEnable2(oneHotSource2[2]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg3( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[3]), .ReadEnable1(oneHotSource1[3]), 
.ReadEnable2(oneHotSource2[3]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg4( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[4]), .ReadEnable1(oneHotSource1[4]), 
.ReadEnable2(oneHotSource2[4]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg5( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[5]), .ReadEnable1(oneHotSource1[5]), 
.ReadEnable2(oneHotSource2[5]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg6( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[6]), .ReadEnable1(oneHotSource1[6]), 
.ReadEnable2(oneHotSource2[6]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg7( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[7]), .ReadEnable1(oneHotSource1[7]), 
.ReadEnable2(oneHotSource2[7]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg8( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[8]), .ReadEnable1(oneHotSource1[8]), 
.ReadEnable2(oneHotSource2[8]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg9( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[9]), .ReadEnable1(oneHotSource1[9]), 
.ReadEnable2(oneHotSource2[9]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg10( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[10]), .ReadEnable1(oneHotSource1[10]), 
.ReadEnable2(oneHotSource2[10]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg11( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[11]), .ReadEnable1(oneHotSource1[11]), 
.ReadEnable2(oneHotSource2[11]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg12( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[12]), .ReadEnable1(oneHotSource1[12]), 
.ReadEnable2(oneHotSource2[12]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg13( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[13]), .ReadEnable1(oneHotSource1[13]), 
.ReadEnable2(oneHotSource2[13]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg14( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[14]), .ReadEnable1(oneHotSource1[14]), 
.ReadEnable2(oneHotSource2[14]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));

Register reg15( .clk(clk), .rst(rst), .D(DstData), .WriteReg(oneHotDest[15]), .ReadEnable1(oneHotSource1[15]), 
.ReadEnable2(oneHotSource2[15]), .Bitline1(newSrcData1), .Bitline2(newSrcData2));


//logic for write-before-read bypassing
assign SrcData1 = (rst == 1) ? 16'h0000 : ( ((oneHotDest == oneHotSource1) & (WriteReg == 1'b1))? DstData : newSrcData1 ) ;
assign SrcData2 = (rst == 1) ? 16'h0000 : ( ((oneHotDest == oneHotSource2) & (WriteReg == 1'b1))? DstData : newSrcData2 ) ;


//assign SrcData1 =  newSrcData1 ;
//assign SrcData2 = newSrcData2 ;
endmodule



