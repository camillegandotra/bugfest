`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2023 03:11:33 PM
// Design Name: 
// Module Name: slug
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


module slug(
    input slugUp,
    input slugMove,
    input [15:0] H,
    input [15:0] V,
    input IDLE,
    input clk,
    input frame1,
    input frame2,
    input plat,
    input hang,
    input pinned,
    output hitPond,
    output hitLeft,
    output [15:0] slugH,
    output [15:0] slugV,
    output slug
    );
    wire pond, top, left;
    // top and bottom boundaries
    assign pond = (slugV + 16'd15 < 16'd374);   // change to when overlaps
    assign top = (slugV > 16'd8);
    assign left = (slugH > 16'd23);

    wire load;
    FDRE #(.INIT(1'b1) ) FDRE_load (.C(clk), .R(1'b0), .CE(IDLE), .D(1'b0), .Q(load));   // Load in initial V value

    countUD16L verCounter (.Up(~slugUp & pond & frame2 & slugMove & ~plat & ~hang), .Dw(slugUp & top & frame2 & slugMove & ~hang), .LD(IDLE & load), .R(1'b0), .Din(16'd184),
                .clk(clk), .Q(slugV), .UTC(), .DTC());
                
    assign slug = (((slugH <= (H + 16'd15)) && (H <= slugH))) && (((slugV <= V) && (V <= (slugV + 16'd15))));
    
    countUD16L horCounter (.Up(1'b0), .Dw(pinned & frame1 & left), .LD(IDLE), .R(1'b0), .Din(16'd140),
                .clk(clk), .Q(slugH), .UTC(), .DTC());
    assign hitLeft = ~left;            
    assign hitPond = ~pond;
                
endmodule
