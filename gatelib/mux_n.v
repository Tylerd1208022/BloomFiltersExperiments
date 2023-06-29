`timescale 1ns/10ps

module mux_n(sel,a,b,out);
    parameter n = 32;
    input sel;
    input [n-1:0]a,b;
    output [n-1:0]out;
    wire [n-1:0]selTrue, selFalse;
    wire notSel;
    not_gate selInverter(sel,notSel);
    genvar i;
    generate
        for(i = 0; i < n; i = i + 1) begin
            and_gate SelFilter(sel,a[i],selTrue[i]);
            and_gate NotSelFilter(notSel,b[i],selFalse[i]);
        end
    endgenerate
    or_gate_n #(.n(n))finalGate(selFalse,selTrue,out);
endmodule