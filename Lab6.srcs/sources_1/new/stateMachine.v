`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2023 01:12:09 PM
// Design Name: 
// Module Name: stateMachine
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


module stateMachine(
    input start,
    input hitBug,
    input die,
    input timeUp,
    input reset,
    input clk,
    output idleS,
    output platMove,
    output bugMove,
    output slugMove,
    output bugFlash,
    output slugFlash,
    output timeLoad,
    output timeRun,
    output incScore
    );
    // Game State Machine
    wire [3:0] PS, NS;
    FDRE #(.INIT(1'b1)) Q0_FF (.C(clk),.R(reset),.CE(1'b1),.D(NS[0]),.Q(PS[0]));
    FDRE #(.INIT(1'b0)) Q3_FF[3:1] (.C({3{clk}}),.R({3{reset}}),.CE({3{1'b1}}),.D(NS[3:1]),.Q(PS[3:1]));

    wire IDLE, GAME, SCORE, COLLIDE;
    wire Next_IDLE, Next_GAME, Next_SCORE, Next_COLLIDE;
    
    assign IDLE = PS[0];
    assign GAME = PS[1];
    assign SCORE = PS[2];
    assign COLLIDE = PS[3];

    assign NS[0] = Next_IDLE;
    assign NS[1] = Next_GAME;
    assign NS[2] = Next_SCORE;
    assign NS[3] = Next_COLLIDE;
    
    assign Next_IDLE = ~start & IDLE;
    assign Next_GAME = (start & IDLE) | (timeUp & SCORE) | (((die & hitBug) | (~die & ~hitBug)) & GAME);
    assign Next_SCORE = (~die & hitBug & GAME) | (~timeUp & SCORE);
    assign Next_COLLIDE = (die & ~hitBug & GAME) | COLLIDE;

    assign idleS = IDLE;
    assign slugMove = IDLE | GAME | SCORE;
    assign platMove = GAME | COLLIDE;
    assign bugMove = GAME | COLLIDE;
    assign bugFlash = SCORE;
    assign slugFlash = COLLIDE;
    assign timeLoad = ~die & hitBug & GAME;
    assign timeRun = SCORE;
    assign incScore = timeUp & SCORE;

endmodule