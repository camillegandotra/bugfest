`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2023 05:16:34 PM
// Design Name: 
// Module Name: selector
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


module selector(
    input [3:0] sel,
    input [15:0] N,
    output [3:0] H      // 4-bit range of N bus
    );
    // Rather than using four hex7seg symbols (Lab2)...
    // ... feed it 4-bit values one at a time for each of the four digits.
    // H is N[15:12] when sel=(1000)
    // H is N[11:8] when sel=(0100)
    // H is N[7:4] when sel=(0010)
    // H is N[3:0] when sel=(0001)
    assign H = (N[15:12] & {4{sel[3]}}) | (N[11:8] & {4{sel[2]}}) | (N[7:4] & {4{sel[1]}}) | (N[3:0] & {4{sel[0]}}); 
endmodule
