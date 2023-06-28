`timescale 1ns/10ps

module and_gate_condense(input,output);

    //Condenses a long input into single output bit with bitwise AND

    parameter n = 32;

    input [n-1:0]input;
    output output;

    assign output = &input;

endmodule

module or_gate_condense(input,output);

    //Condenses a long input into single output bit with bitwise AND

    parameter n = 32;

    input [n-1:0]input;
    output output;

    assign output = |input;

endmodule