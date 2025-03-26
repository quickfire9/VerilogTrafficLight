`default_nettype none

// Top-level traffic light controller module
module tlc_controller (
    output wire [1:0] highwaySignal,  // Connected to LEDs for highway signals
    output wire [1:0] farmSignal,     // Connected to LEDs for farm road signals
    output wire [3:0] JB,             // Output state and debug signals
    input wire Clk,                   // Clock signal
    input wire Rst,                    // Reset signal
    input wire farmSensor
);

    // Intermediate nets and registers
    wire RstSync;                     // Synchronized reset signal
    wire RstCount;                     // Reset count signal from FSM
    reg [30:0] Count;                 // 31-bit clock cycle counter
    wire [2:0] state;                 // FSM state for debugging

    // Assign debug outputs
    assign JB[3] = RstCount;           // Debug RsCount signal
    assign JB[2:0] = state;           // Debug FSM state

    // Synchronize reset input
    synchronizer syncRst (
        .OutSignal(RstSync), 
        .InSignal(Rst), 
        .Clk(Clk)
    );

    // Instantiate FSM
    tlc_fsm FSM (
        .state(state),                // FSM state output
        .RstCount(RstCount),            // Reset count signal output
        .highwaySignal(highwaySignal),// Highway traffic lights output
        .farmSignal(farmSignal),      // Farm traffic lights output
        .Count(Count),                // Counter input
        .Clk(Clk),                    // Clock input
        .Rst(RstSync),                 // Reset input
        .farmSensor(farmSensor)
    );

    // Counter with asynchronous reset and FSM reset control
    always @(posedge Clk or posedge RstSync) begin
        if (RstSync)
            Count <= 0;               // Reset counter when reset is high
        else if (RstCount)
            Count <= 0;               // Reset counter based on FSM signal
        else
            Count <= Count + 1;       // Increment counter
    end

endmodule 
