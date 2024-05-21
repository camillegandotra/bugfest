`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2023 05:15:11 PM
// Design Name: 
// Module Name: ringCounter
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


module ringCounter(
    input clk,          // system clock
    input R,            // Reset Button
    input adv,          // advance button
    output [3:0] o      
    );
    // A ring counter holds a bit vector which has a single 1 bit.
    // It has a control, Advance, along with a clock input.
    // If Advance is high on the clock edge then the 1 bit shifts by one position circularly.
    // You will need to make sure that one of the FFs has a 1 on reset.
    
    FDRE #(.INIT(1'b1) ) FDRE1 (.C(clk), .R(R), .CE(adv), .D(o[3]), .Q(o[0])); // Initialize w/ 1
    FDRE #(.INIT(1'b0) ) FDRE2 (.C(clk), .R(R), .CE(adv), .D(o[0]), .Q(o[1]));  
    FDRE #(.INIT(1'b0) ) FDRE3 (.C(clk), .R(R), .CE(adv), .D(o[1]), .Q(o[2])); 
    FDRE #(.INIT(1'b0) ) FDRE4 (.C(clk), .R(R), .CE(adv), .D(o[2]), .Q(o[3]));  
    
endmodule
