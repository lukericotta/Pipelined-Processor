// Gokul's D-flipflop
`timescale 1ns/1ps
module dff (q, d, wen, clk, rst);

    output         q; //DFF output
    input          d; //DFF input
    input 	   wen; //Write Enable
    input          clk; //Clock
    input          rst; //Reset (used synchronously)

    reg            state;

    assign q = state;

    always @(posedge clk) begin
      state = #0.1 rst ? 0 : (wen ? d : state);
    end

endmodule
