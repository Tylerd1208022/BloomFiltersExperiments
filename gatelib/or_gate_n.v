`timescale 1ns/10ps

module or_gate_n(a,b,out);
    parameter n = 32;

    input [n-1:0]a,b;
    output [n-1:0]out;
    assign out = a | b;
    endmodule