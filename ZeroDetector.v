`timescale 1ns/10ps

module ZeroDetector(bits,zero);
    input [7:0] bits;
    output zero;
    wire [3:0]firstLayer;
    wire[1:0]secondLayer;
    wire nonzero;

    or_gate L1G1(bits[0],bits[1],firstLayer[0]);
    or_gate L1G2(bits[2],bits[3],firstLayer[1]);
    or_gate L1G3(bits[4],bits[5],firstLayer[2]);
    or_gate L1G4(bits[6],bits[7],firstLayer[3]);

    or_gate L2G1(firstLayer[0],firstLayer[1],secondLayer[0]);
    or_gate L2G2(firstLayer[2],firstLayer[3],secondLayer[1]);

    or_gate nonzeroGate(secondLayer[0],secondLayer[1],nonzero);

    not_gate finalGate(nonzero,zero);
endmodule


module OVFDetector(bits,OVF);

    input [7:0]bits;
    output OVF;

    wire [3:0]firstLayer;
    wire[1:0]secondLayer;

    and_gate L1G1(bits[0],bits[1],firstLayer[0]);
    and_gate L1G2(bits[2],bits[3],firstLayer[1]);
    and_gate L1G3(bits[4],bits[5],firstLayer[2]);
    and_gate L1G4(bits[6],bits[7],firstLayer[3]);

    and_gate L2G1(firstLayer[0],firstLayer[1],secondLayer[0]);
    and_gate L2G2(firstLayer[2],firstLayer[3],secondLayer[1]);

    and_gate nonzeroGate(secondLayer[0],secondLayer[1],OVF);
endmodule
