module Red (rs, rt, rd);
input [15:0] rs;
input [15:0] rt;
output [15:0] rd;

wire [15:0] sumUpper, sumLower, ext_rsu, ext_rsl, ext_rtu, ext_rtl;

assign ext_rsu = {{8{rs[15]}}, rs[15:8]};
assign ext_rsl = {{8{rs[7]}}, rs[7:0]};
assign ext_rtu = {{8{rt[15]}}, rt[15:8]};
assign ext_rtl = {{8{rt[7]}}, rt[7:0]};

CLA16bit redAdd1(.A(ext_rsu),.B(ext_rtu),.SUB(1'b0),.SUM(sumUpper),.Cout());
CLA16bit redAdd2(.A(ext_rsl),.B(ext_rtl),.SUB(1'b0),.SUM(sumLower),.Cout());
CLA16bit redAdd3(.A(sumUpper),.B(sumLower),.SUB(1'b0),.SUM(rd),.Cout());
endmodule // Red
