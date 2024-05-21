`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2023 09:52:48 AM
// Design Name: 
// Module Name: test_platform
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

module plat (
    input clk,
    input frame,
    input IDLE,
    input platMove,
    output [15:0]ONEplatH,
    output [15:0]ONEplatV,
    output [15:0]TWOplatH,
    output [15:0]TWOplatV,
    output [15:0]THREEplatH,
    output [15:0]THREEplatV,
    output [15:0]ONEplatW,
    output [15:0]TWOplatW,
    output [15:0]THREEplatW
    );
    
    platform one (.IDLE(IDLE), .clk(clk), .startX({16'd300}), .frame(frame), .platMove(platMove),
                    .platH(ONEplatH), .platV(ONEplatV), .platW(ONEplatW));
                    
    platform two (.IDLE(IDLE), .clk(clk), .startX({16'd601}), .frame(frame), .platMove(platMove),
                    .platH(TWOplatH), .platV(TWOplatV), .platW(TWOplatW));
    
    platform three (.IDLE(IDLE), .clk(clk), .startX({16'd902}), .frame(frame), .platMove(platMove),
                    .platH(THREEplatH), .platV(THREEplatV), .platW(THREEplatW));
endmodule 

module test_platform();
    reg clkin;
    reg frame;
    reg platMove, IDLE;
    wire [15:0] ONE_PH, ONE_PV, TWO_PH, TWO_PV, THREE_PH, THREE_PV, ONE_PW, TWO_PW, THREE_PW;
    
    plat UUT (
         .clk(clkin),
         .frame(frame),
         .IDLE(IDLE),
         .platMove(platMove),
         .ONEplatH(ONE_PH),
         .ONEplatV(ONE_PV),
         .TWOplatH(TWO_PH),
         .TWOplatV(TWO_PV),
         .THREEplatH(THREE_PH),
         .THREEplatV(THREE_PV),
         .ONEplatW(ONE_PW),
         .TWOplatW(TWO_PW),
         .THREEplatW(THREE_PW)
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
    
    initial
    begin
    frame = 1'b0;
    platMove = 1'b0;
    IDLE = 1'b1;
    
   #1000
   IDLE = 1'b0;
   platMove = 1'b1;
   frame = 1'b1;
    
    
    
    end

endmodule
