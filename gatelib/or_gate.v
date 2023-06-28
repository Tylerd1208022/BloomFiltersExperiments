`timescale 1ns/10ps

module or_gate(a,b,out);
    input a,b;
    output out;
    assign out = a | b;
endmodule