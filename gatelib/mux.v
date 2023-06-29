`timescale 1ns/10ps

module mux(sel,a,b,out);
    input sel, a, b;
    output out;
    wire selA,selB,notsel;
    and_gate ifSel(sel,a,selA);
    not_gate SelInv(sel,notsel);
    and_gate elsegate(notsel,b,selB);
    or_gate combineTest(selB,selA,out);
endmodule