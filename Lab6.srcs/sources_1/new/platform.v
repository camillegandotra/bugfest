`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2023 08:34:59 PM
// Design Name: 
// Module Name: platform
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


module platform(
    input clk,
    input [15:0] H,
    input [15:0] V,
    input [15:0] startX,
    input [15:0] startW,
    input frame1,
    input IDLE,
    input platMove,
    input slugCollide,
    output [15:0] platH,
    output [15:0] platV,
    output [15:0] platW,
    output plat
    );
    // platform coord will be top right
    wire [15:0] D;
    wire DTC;
    assign D = ({16{IDLE}} & {startX}) | ({16{~IDLE}} & {16'd902});
    countUD16L horCounter (.Up(1'b0), .Dw(frame1 & ~IDLE & platMove & ~DTC & ~slugCollide), .LD((DTC | IDLE)), .R(1'b0), .Din(D),
                .clk(clk), .Q(platH), .UTC(), .DTC(DTC));
            
    wire [9:0] rnd;   
    wire r;
    // Gets a random number in range
    LFSR width (.clk(clk), .rnd(rnd));
    assign r = (8'd128 <= platW) && (platW <= 8'd252);
    
    // Load in random value if it is not in range or if DTC
    wire [15:0] D2;
    assign D2 = ({16{IDLE}} & {startW}) | ({16{~IDLE}} & {{6{1'b0}}, rnd});
    countUD16L widthS (.Up(1'b0), .Dw(1'b0), .LD(DTC | ~r), .R(1'b0), .Din(D2),
                .clk(clk), .Q(platW), .UTC(), .DTC());
                
    // Vertical position of platform is constant             
    assign platV = 16'd200;
    assign plat = ((((platH + 16'd1) <= (H + platW)) && (H <= platH))) && (((platV <= V) && (V <= (platV + 16'd7))));
   
endmodule
