`timescale 1ns/10ps

module hashCoder(target,current,match);
    //Takes in a target address from hash (target)
    //         a loop variable over the one hot array (current)
    //Outputs a bool on match for populating one hot array
    parameter n = 32;

    input [n-1:0]target,current;
    output match;
    wire [n-1:0] xorRes;
    wire notMatch;
    xor_gate_n #(.n(n))combineGate(target,current,xorRes);
    or_gate_condense(xorRes,notMatch); //notMatch 1 if xor doesn't return zero
    not_gate(notMatch,match);
endmodule