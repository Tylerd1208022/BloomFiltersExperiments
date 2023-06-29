`timescale 1ns/10ps


module testLFSR();

    reg WE, Increment, rstb, CLK;
    wire zero, OF;
    always #1 CLK = ~CLK;
    LFSR testedModule(
        .WE(WE),
        .Increment(Increment),
        .rstb(rstb),
        .CLK(CLK)
        .zero(zero),
        .OF(OF)
    );

    initial begin
        CLK = 0;
        WE = 0;
        Increment = 0;
        rstb = 1;
        #2
        rstb = 0;
        #2
        WE = 1;
        Increment = 1;
        #10
        Increment = 0;
        #10
        WE = 0;
        #4
    end
