`timescale 1ns/10ps

module and_gate_condense(in,out);

    //Condenses a long input into single output bit with bitwise AND

    parameter n = 32;

    input [n-1:0]in;
    output out;

    assign out = &in;

endmodule

module or_gate_condense(in,out);

    //Condenses a long input into single output bit with bitwise AND

    parameter n = 32;

    input [n-1:0]in;
    output out;

    assign out = |in;

endmodule