`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2023 05:24:23 PM
// Design Name: 
// Module Name: pixelAddress
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


module pixelAddress(
    input clk,
    input R,       // global reset         
    output [15:0] V,
    output [15:0] H,
    output AA,      // Active Area
    output frame,    // for incrementing per frame
    output frame2    // for incrementing 2x per frame
    );
    
    // pixel incrementer
    wire [15:0] hor, ver;
    countUD16L horCounter (.Up(1'b1), .Dw(1'b0), .LD(1'b0), .R(horR | R), .Din({16{1'b0}}),
                .clk(clk), .Q(H), .UTC(), .DTC());
    countUD16L verCounter (.Up(horR), .Dw(1'b0), .LD(1'b0), .R((verR & horR) | R), .Din({16{1'b0}}),
                .clk(clk), .Q(V), .UTC(), .DTC());
    
    // check when to reset counter
    assign verR = 16'd524 == V;    // Check 525th pixel (524)
    assign horR = 16'd799 == H;    // Check 800th pixel (799)
    
    // active area
    assign AA = (H < 16'd640) && (V < 16'd480);
    
    // frame incrementation
    assign frame = (H == 16'd0) && (V == 16'd0);
    
    assign frame2 = (H == 16'd400) && (V == 16'd0);
    
endmodule
