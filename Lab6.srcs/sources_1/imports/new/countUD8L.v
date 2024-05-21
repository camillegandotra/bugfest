`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2023 07:09:34 PM
// Design Name: 
// Module Name: countUD8L
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


module countUD8L(
    input Up,           // Up(increment)
    input Dw,           // Dw(decrement)
    input LD,           // LD(load control)
    input R,            // Reset Button
    input [7:0] Din,    // 8-bit vector sw
    input clk,          // the system clock
    output [7:0] Q,     // 8-bit bus Q which is the current value held by the counter
    output UTC,         // signal UTC (Up Terminal Count) which is 1 only when the counter is all 1s
    output DTC          // signal DTC (Down Terminal Count) which is 1 only when the counter is all 0s
    );
    
    wire [1:0] utc, dtc;
    // We & Up w/ previous utc to indicate incrementation in the new section...
    // ... similarly dont for Dw
    countUD4L counter3_0 (.Up(Up), .Dw(Dw), .LD(LD), .R(R), .Din(Din[3:0]), .clk(clk), .Q(Q[3:0]), .UTC(utc[0]), .DTC(dtc[0]));
    countUD4L counter7_4 (.Up(Up & utc[0]), .Dw(Dw & dtc[0]), .LD(LD), .R(R), .Din(Din[7:4]), .clk(clk), .Q(Q[7:4]), .UTC(utc[1]), .DTC(dtc[1]));

    assign UTC = &utc;  // All of the 4 bit counters produce a 1 utc
    assign DTC = &dtc;  // All of the 4 bit counters produce a 1 dtc
    
endmodule
