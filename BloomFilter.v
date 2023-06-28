`timescale 1ns/10ps

module BloomFilter(Addr,CLK,rstb,WE,increment,result);

    parameter hashCount = 1;
    parameter size = 8192;
    parameter PageOffset = 12;
    integer logSize = $clog2(size);

    input [56:0]Addr;
    input CLK, rstb, WE, increment;
    output result;

    wire [size-1:0]HashedValues;//Hash functions results (one hot indicies into LFSR array)
    wire [size-1:0]IncArray; //Used for Inc/Dec signal for each LFSR (HashedValue AND Inc)
    wire [size-1:0]WEArray; //Used for WE signal, when high only write to hashed LFSRs (HashedValue AND WE (input))
    wire [size-1:0]longResults; //Output of each LFSR Zero detection
    wire [size-1:0]oneHotResults; //To Be Anded for result
    wire [size-1:0]OFArray;//To be ored for result
    wire [size-1:0]OFOneHotArray;//Prevent non selected overflow from interfering
    reg [size-1:0][1:0]ZVals;//boolean value for quick probe [Value,Overflown]
    
    //Hash functions

    //For 1 Hash
    assign HashedValues[Addr[logSize + PageOffset - 1: PageOffset]] = 1;
    //For 3 Hash, 32k size
    /*
    assign HashedValues[Addr[logSize + PageOffset - 1:PageOffset]] = 1;
    assign HashedValues[Addr[logSize + PageOffset + 14:PageOffset + 15]] = 1;
    assign HashedValues[Addr[logSize + PageOffset + 29:PageOffset + 30]] = 1;
    */
    
    //Logic should follow: If not WE/rstb, read Zvals, else read LFSR signal for zero (post op)
    genvar i;
    generate
        for(i = 0; i < size; i = i + 1) begin //creation of storage LFSR's
            and_gate(HashedValues[j],WE,WEArray[j]);
            and_gate(HashedValues[j],increment,IncArray[j]);
            LFSR ShiftRegs(
                .WE(WEArray[i])
                .Increment(IncArray[i])
                .Zero(longResults[i])
                .rstb(rstb)
                .CLK(CLK)
                .OF(OFArray[i])
            )
            and_gate OneHotAND(longResults[i],HashedValues[i],oneHotResults[i]);
            and_gate OneHotOF(OFArray[i],HashedValues[i],OFOneHotArray[i]);
        end
    endgenerate

    //Update Zregs -- Only really matters on writes
    reg ZregLoopVar [31:0];
    always (@ posedge CLK) begin
        for(ZregLoopVar = 0; ZregLoopVar < size; ZregLoopVar = ZregLoopVar + 1) begin
            if HashedValues[ZregLoopVar] begin
                Zregs[ZregLoopVar][0] <= longResults[ZregLoopVar]; //Set ZReg shared if 1 (No worries on OF since it will be already set)
                Zregs[ZregLoopVar][0] <= OFOneHotArray[ZregLoopVar];
            end
        end
    end

    wire fastOnes, fastOF, fastResults; // faster but only allowed when probing (no WE)
    wire slowOnes, slowOF,slowResults; //Slower must wait for writes (I dont think we need these)
    and_gate_condense #(.n(size))result_gate(Zregs[size-1:0][0],allOnes);
    or_gate_condense #(.n(size))OF_gate(Zregs[size-1:0][1],someOF);
    or_gate(allOnes,someOF,result);

endmodule