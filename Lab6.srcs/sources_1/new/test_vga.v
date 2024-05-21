`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2023 02:20:22 PM
// Design Name: 
// Module Name: test_vga
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
module vga(
    input clk,
    output [15:0] V,
    output [15:0] H,
    output active,
    output frame,
    output HS,
    output VS,
    output border,
    output pond
    );
    pixelAddress PS(.clk(clk),
        .V(V),
        .H(H),
        .AA(active),
        .frame(frame));
        
        syncs US (
        .V(V),
        .H(H),
        .Vsync(VS),
        .Hsync(HS)
    );
    
    border B (.V(V), .H(H), .b(border));
    pond P (.V(V), .H(H), .p(pond));
    
endmodule

module test_vga();
     reg clkin;
    wire [15:0] V, H;
    wire active, frame;
    wire VS, HS;
    
    vga UUT (
        .clk(clkin),
        .V(V),
        .H(H),
        .active(active),
        .frame(frame),
        .HS(HS),
        .VS(VS)
    );
  
    
    parameter PERIOD = 10;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;

    initial    // Clock process for clkin
    begin
        #OFFSET
		  clkin = 1'b1;
        forever
        begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
        end
    end
    
//    initial
//    begin

    
    
    
    
//    end

endmodule
