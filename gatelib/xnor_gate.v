`timescale 1ns/10ps

module xnor_gate(a,b,out);
    input a,b;
    output out;
    assign out = ~(a^b);
endmodule