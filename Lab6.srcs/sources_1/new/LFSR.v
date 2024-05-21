`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2023 10:38:50 AM
// Design Name: 
// Module Name: LFSR
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


module LFSR(
    input clk,
    output [9:0] rnd
    );
    //  generate a random 10-bit binary number
    wire rnd0 = (rnd[0]^rnd[5]^rnd[6]^rnd[7]);
    FDRE #(.INIT(1'b1)) FDRE0 (.C(clk), .R(R), .CE(1'b1), .D(rnd0), .Q(rnd[0])); 
    FDRE #(.INIT(1'b0)) FDRE4_1[9:1] (.C({9{clk}}),.R({9{R}}),.CE({9{1'b1}}),.D(rnd[8:0]),.Q(rnd[9:1]));
    endmodule