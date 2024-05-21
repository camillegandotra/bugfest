`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2023 07:21:06 PM
// Design Name: 
// Module Name: slugPlatform
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


module slugPlatform(
    input [15:0] slugH,
    input [15:0] slugV,
    input [15:0] ONEplatH,
    input [15:0] ONEplatV,
    input [15:0] ONEplatW,
    input [15:0] TWOplatH,
    input [15:0] TWOplatV,
    input [15:0] TWOplatW,
    input [15:0] THREEplatH,
    input [15:0] THREEplatV,
    input [15:0] THREEplatW,
    output plat,
    output hang,
    output pinned
    );
    
   // checks for when slug is on top of platform (should not fall through)
   wire plat1, plat2, plat3;
   assign plat1 = (ONEplatV == slugV + 16'd16)  &&
                (((ONEplatH <= slugH + ONEplatW) && (slugH <= ONEplatH)) ||
               ((ONEplatH + 16'd15 <= slugH + ONEplatW) && (slugH <= ONEplatH + 16'd15)));
                 
   assign plat2 = (TWOplatV == slugV + 16'd16)  &&
                (((TWOplatH <= slugH + TWOplatW) && (slugH <= TWOplatH)) ||
               ((TWOplatH + 16'd15 <= slugH + TWOplatW) && (slugH <= TWOplatH + 16'd15)));
               
    assign plat3 = (THREEplatV == slugV + 16'd16)  &&
                (((THREEplatH <= slugH + THREEplatW) && (slugH <= THREEplatH)) ||
               ((THREEplatH + 16'd15 <= slugH + THREEplatW) && (slugH <= THREEplatH + 16'd15)));
               
    assign plat = plat1 | plat2 | plat3;
    
    // checks for when slug should hang on the platform
    wire hang1, hang2, hang3;
    assign hang1 = (ONEplatV + 16'd8 == slugV)  &&
                (((ONEplatH <= slugH + ONEplatW) && (slugH <= ONEplatH)) ||
               ((ONEplatH + 16'd15 <= slugH + ONEplatW) && (slugH <= ONEplatH + 16'd15)));
               
    assign hang2 = (TWOplatV + 16'd8 == slugV)  &&
                (((TWOplatH <= slugH + TWOplatW) && (slugH <= TWOplatH)) ||
               ((TWOplatH + 16'd15 <= slugH + TWOplatW) && (slugH <= TWOplatH + 16'd15)));
                 
    assign hang3 = (THREEplatV + 16'd8 == slugV)  &&
                (((THREEplatH <= slugH + THREEplatW) && (slugH <= THREEplatH)) ||
               ((THREEplatH + 16'd15 <= slugH + THREEplatW) && (slugH <= THREEplatH + 16'd15)));
                                   
    assign hang = hang1 | hang2 | hang3;
    
    // checks for when slug is pinned by platform
    wire pinned1, pinned2, pinned3;
    assign pinned1 = (slugH + ONEplatW == ONEplatH)  &&
                (((slugV <= ONEplatV) && (ONEplatV <= slugV + 16'd15)) ||
               ((slugV <= ONEplatV + 16'd7) && (ONEplatV + 16'd7 <= slugV + 16'd15)));
               
    assign pinned2 = (slugH + TWOplatW == TWOplatH)  &&
                (((slugV <= TWOplatV) && (TWOplatV <= slugV + 16'd15)) ||
               ((slugV <= TWOplatV + 16'd7) && (TWOplatV + 16'd7 <= slugV + 16'd15)));
               
    assign pinned3 = (slugH + THREEplatW == THREEplatH)  &&
                (((slugV <= THREEplatV) && (THREEplatV <= slugV + 16'd15)) ||
               ((slugV <= THREEplatV + 16'd7) && (THREEplatV + 16'd7 <= slugV + 16'd15)));
    
    assign pinned = pinned1 | pinned2 | pinned3;
    
endmodule
