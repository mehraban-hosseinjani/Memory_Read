`timescale 1ns / 1ps

module MemoryReadFSM_tb;

    // Input declarations
    reg clk;
    reg reset;
    reg [1:0] Op;
    reg Func;

    // Output declarations
    wire AdrSrc;
    wire ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [1:0] ALUOp;
    wire [1:0] ResultSrc;
    wire IRWrite;
    wire NextPC;
    wire RegWrite;
    wire MemRead;

    // Instantiate the MemoryReadFSM module
    MemoryReadFSM uut (
        .clk(clk),
        .reset(reset),
        .Op(Op),
        .Func(Func),
        .AdrSrc(AdrSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUOp(ALUOp),
        .ResultSrc(ResultSrc),
        .IRWrite(IRWrite),
        .NextPC(NextPC),
        .RegWrite(RegWrite),
        .MemRead(MemRead)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // Initial block to set up the test and produce VCD output
    initial begin
        // Set up VCD file for waveform visualization
        $dumpfile("MemoryReadFSM_tb.vcd");  // Specify VCD file name
        $dumpvars(0, MemoryReadFSM_tb);     // Dump all variables for the testbench

        // Initialization
        clk = 0;
        reset = 1;
        Op = 2'b00;
        Func = 0;

        // Apply reset
        #10 reset = 0;

        // Apply test cases
        #10 Op = 2'b01; // Memory Read instruction
        Func = 1;       // LDR instruction

        #20;  // Wait for next state transition
        #20;  // Continue simulation

        // Finish simulation
        #50 $stop;
    end

endmodule
