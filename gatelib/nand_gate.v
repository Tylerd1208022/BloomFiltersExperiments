`timescale 1ns/10ps

module nand_gate(a,b,out);
    input a, b;
    output out;
    assign output = ~(a & b);
endmodule