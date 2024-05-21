`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2023 07:26:42 PM
// Design Name: 
// Module Name: bug
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


module bug(
    input clk,
    input [15:0] H,
    input [15:0] V,
    input frame2,
    input IDLE,
    input bugMove,
    input score,
    output [15:0] bugH,
    output [15:0] bugV,
    output bug
    );
    // bug coord will be top right
    // bugs are 8x8
    wire DTC;
    countUD16L horCounter (.Up(1'b0), .Dw(frame2 & ~IDLE & bugMove & ~DTC & ~score), .LD((DTC | IDLE | score)), .R(1'b0), .Din({16'd700}),
                .clk(clk), .Q(bugH), .UTC(), .DTC(DTC));
                
   // Gets a random number in range for vertical position
   //  randomly selected from one of the two ranges, 128 to 156, and 256 to 284.
    wire [9:0] rnd; 
    wire r;
    LFSR pos (.clk(clk), .rnd(rnd));
    assign r = ((16'd128 <= bugV) && (bugV <= 16'd156)) || ((16'd256 <= bugV) && (bugV <= 16'd284));
    
    // Load in random value if it is not in range or if DTC
    countUD16L verB (.Up(1'b0), .Dw(1'b0), .LD(DTC | ~r), .R(1'b0), .Din({{6{1'b0}}, rnd}),
                .clk(clk), .Q(bugV), .UTC(), .DTC());             
    assign bug = (((bugH <= (H + 16'd7)) && (H <= bugH))) && (((bugV <= V) && (V <= (bugV + 16'd7))));
                
endmodule
