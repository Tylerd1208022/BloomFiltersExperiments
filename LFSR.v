`timescale 1ns/10ps

module LFSR(WE,Increment,Zero,rstb,CLK,OF);

    input WE;   //1 for change, 0 for probe
    input Increment; //1 for ++, 0 for -- (when WE high)
    input rstb; //set counter to 0
    input CLK;
    output Zero; //1 when contents are zero post operation
    output OF;//Only used for multi hash filters

    reg [7:0]counter; //Actual stored value

    wire [7:0]incVals, decVals; //Wires to hold the next value to be muxxed based on Increment bit
    wire [7:0]currVals, rstVals;//Wires to hold current value for no change/reset value (0)

    wire [7:0]changeVal, constVal, nextVal;

    wire [7:0]GND;
    wire allowChange, overflow, NoOverride; //Reset bit, overflow must override signal to increment
    assign GND = 0;
    //Forward Shift Logic
    assign incVals[0] = counter[7];
    assign incVals[1] = counter[0];
    assign incVals[2] = counter[1];
    assign incVals[3] = counter[2];
    xnor_gate FwdTap1(counter[3],counter[7],incVals[4]);
    xnor_gate FwdTap2(counter[4],counter[7],incVals[5]);
    xnor_gate FwdTap3(counter[5],counter[7],incVals[6]);
    assign incVals[7] = counter[6];

    //Backward Shift Logic
    assign decVals[7] = counter[0];
    assign decVals[0] = counter[1];
    assign decVals[1] = counter[2];
    assign decVals[2] = counter[3];
    xnor_gate BckTap1(counter[4],counter[0],decVals[3]);
    xnor_gate BckTap2(counter[5],counter[0],decVals[4]);
    xnor_gate BclTap3(counter[6],counter[0],decVals[5]);
    assign decVals[6] = counter[7];
    
    OVFDetector ODetect(counter,overflow);
    assign OF = overflow;
    //State change logic
    mux_n #(.n(8))ChangeMux(Increment,incVals,decVals,changeVal);
    mux_n #(.n(8))ConstMux(rstb,GND,,counter,constVal);
    nor_gate overridecheck(rstb,overflow,NoOverride);
    and_gate allowChangeGate(NoOverride,WE,allowChange);
    mux_n #(.n(8))StateChangeMux(allowChange,changeVal,constVal,nextVal);

    ZeroDetector ZDetect(nextVal,zero);

    always @(posedge CLK)  counter <= nextVal;
        
endmodule
