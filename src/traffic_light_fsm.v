`timescale 1ns / 1ps
`default_nettype none


module tlc_fsm (
    output reg [2:0] state,          // Output for debugging
    output reg RstCount,              // Reset count signal
    output reg [1:0] highwaySignal,  // Highway signal output (00=red, 01=yellow, 10=green)
    output reg [1:0] farmSignal,     // Farm road signal output (00=red, 01=yellow, 10=green)
    input wire [30:0] Count,         // Clock cycle counter
    input wire Clk,                  // Clock
    input wire Rst,                   // Reset
    input wire farmSensor
);

    // State definitions   highway, farm
    parameter S0 = 3'b000; // red, red
    parameter S1 = 3'b001; // green, red
    parameter S2 = 3'b010; // yellow, red
    parameter S3 = 3'b011; // red, red
    parameter S4 = 3'b100; // red, green
    parameter S5 = 3'b101; // red, yellow

    // Clock cycle counts for each state
    reg [30:0] countLimit;

    always @(posedge Clk or posedge Rst) begin
        if (Rst) begin
            state <= S0;
            RstCount <= 1'b1;  // Reset the counter on reset
        end else begin
            if (RstCount) begin
                RstCount <= 1'b0; // Deassert after one cycle
            end else if (Count >= countLimit) begin
                RstCount <= 1'b1; // Assert to reset the counter

                // State transition logic
                case (state)
                    S0: state <= S1;
                    S1: if(farmSensor == 0) state <= S1;
                        else state <= S2;
                    S2: state <= S3;
                    S3: state <= S4;
                    S4: if(farmSensor == 0) state <= S5;
                        else if(farmSensor == 1 && Count > 750000000) state <= S5;
                        else state <= S4;
                    S5: state <= S0;
                    default: state <= S0; // Default case for unknown states
                endcase
            end
        end
    end

    always @(*) begin
        // Assign outputs based on the current state
        case (state)
            S0: begin
                highwaySignal = 2'b00;
                farmSignal = 2'b00;
                countLimit = 50000000; // Delay for 1 second (1 * 50,000,000 cc)
            end
            S1: begin
                highwaySignal = 2'b10;
                farmSignal = 2'b00;
                countLimit = 1500000000; // Delay for 30 seconds (30 * 50,000,000 cc)
            end
            S2: begin
                highwaySignal = 2'b01;
                farmSignal = 2'b00;
                countLimit = 150000000; // Delay for 3 seconds (3 * 50,000,000 cc)
            end
            S3: begin
                highwaySignal = 2'b00;
                farmSignal = 2'b00;
                countLimit = 50000000; // Delay for 1 second (1 * 50,000,000 cc)
            end
            S4: begin
                highwaySignal = 2'b00;
                farmSignal = 2'b10;
                countLimit = 150000000; // Delay for 3 seconds (15 * 50,000,000 cc)
            end
            S5: begin
                highwaySignal = 2'b00;
                farmSignal = 2'b01;
                countLimit = 150000000; // Delay for 3 seconds (3 * 50,000,000 cc)
            end
            default: begin
                highwaySignal = 2'b00;
                farmSignal = 2'b00;
                countLimit = 50000000; // Default delay for 1 second (1 * 50,000,000 cc)
            end
        endcase
    end

endmodule