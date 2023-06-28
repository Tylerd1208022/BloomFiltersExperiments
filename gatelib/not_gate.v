`timescale 1ns/10ps

module not_gate(a,out);
    input a;
    output out;
    assign out = ~a;
endmodule