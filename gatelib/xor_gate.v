`timescale 1ns/10ps

module xor_gate(a,b,out);
    input a,b;
    output out;
    assign out = a ^ b;

endmodule 