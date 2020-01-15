module ForwardUnit (
    input exmemregwrite,
    input [3:0]exmemregrd,
    input memwbregwrite,
    input [3:0]memwbregrd,
    input [3:0]idexregrs,
    input [3:0]idexregrt,
    output [1:0]forwarda,
    output [1:0]forwardb
    );
    
    wire [1:0]exhazard;
    wire [1:0]memhazard;

    assign exhazard[0] = exmemregwrite & (exmemregrd != 4'h0) & (exmemregrd == idexregrs);
    assign exhazard[1] = exmemregwrite & (exmemregrd != 4'h0) & (exmemregrd == idexregrt);
    assign memhazard[0] = memwbregwrite & (memwbregrd != 4'h0) & ~exhazard[0] & (memwbregrd == idexregrs);
    assign memhazard[1] = memwbregwrite & (memwbregrd != 4'h0) & ~exhazard[1] & (memwbregrd == idexregrt);

    assign forwardb = exhazard[0] ? 2'b10 : (memhazard[0] ? 2'b01 : 2'b0);
    assign forwarda = exhazard[1] ? 2'b10 : (memhazard[1] ? 2'b01 : 2'b0);

endmodule