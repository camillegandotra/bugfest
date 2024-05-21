`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2023 12:42:34 PM
// Design Name: 
// Module Name: syncs
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


module syncs(
    input [15:0] V,
    input [15:0] H,
    output Vsync,
    output Hsync
    );
    // Hsync and Vsync areas
    assign Vsync = (16'd489 > V) || (16'd490 < V);
    assign Hsync = (16'd655 > H) || (16'd750 < H); 
endmodule
