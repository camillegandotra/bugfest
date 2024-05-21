`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2023 05:33:33 PM
// Design Name: 
// Module Name: countUD16L
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module countUD16L(
    input Up,           // Up(increment)
    input Dw,           // Dw(decrement)
    input LD,           // LD(load control)
    input R,            // Reset Button
    input [15:0] Din,   // 16-bit vector sw
    input clk,          // the system clock
    output [15:0] Q,    // 16-bit bus Q which is the current value held by the counter
    output UTC,         // signal UTC (Up Terminal Count) which is 1 only when the counter is all 1s
    output DTC          // signal DTC (Down Terminal Count) which is 1 only when the counter is all 0s
    );
    
    wire [1:0] utc, dtc;
    // We & Up w/ previous utc to indicate incrementation in the new section...
    // ... similarly dont for Dw
    countUD8L counter7_0 (.Up(Up), .Dw(Dw), .LD(LD), .R(R), .Din(Din[7:0]), .clk(clk), .Q(Q[7:0]), .UTC(utc[0]), .DTC(dtc[0]));
    countUD8L counter15_8 (.Up(Up & utc[0]), .Dw(Dw & dtc[0]), .LD(LD), .R(R), .Din(Din[15:8]), .clk(clk), .Q(Q[15:8]), .UTC(utc[1]), .DTC(dtc[1]));

    assign UTC = &utc;  // All of the 8 bit counters produce a 1 utc
    assign DTC = &dtc;  // All of the 8 bit counters produce a 1 dtc
    
endmodule
