`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2023 07:08:08 PM
// Design Name: 
// Module Name: countUD4L
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


module countUD4L(
    input Up,           // Up(increment)
    input Dw,           // Dw(decrement)
    input LD,           // LD(load control)
    input R,
    input [3:0] Din,    // 5-bit vector Din
    input clk,          // the system clock
    output [3:0] Q,     // 5-bit bus Q which is the current value held by the counter
    output UTC,         // signal UTC (Up Terminal Count) which is 1 only when the counter is at 5'b11111
    output DTC          // signal DTC (Down Terminal Count) which is 1 only when the counter is at 5'b0000
    );
    
    // D Flip Flop will work if (Up XOR Dw) OR LD
    wire CE;
    assign CE = (Up ^ Dw) | LD;
    
    // Calculate all possible 3 outcomes first 
    
    // Calculating Up (Incrementation)
    wire [3:0] U;
    assign U =  {(Q[3] ^ (Up & Q[2] & Q[1] & Q[0])),
                 (Q[2] ^ (Up & Q[1] & Q[0])),
                 (Q[1] ^ (Up & Q[0])),
                 (Q[0] ^ Up)};
    
    // Calculating Dw (Decrementation)
    wire [3:0] D;
    assign D =  {(Q[3] ^ (Dw & ~Q[2] & ~Q[1] & ~Q[0])),
                 (Q[2] ^ (Dw & ~Q[1] & ~Q[0])),
                 (Q[1] ^ (Dw & ~Q[0])),
                 (Q[0] ^ Dw)};
                 
    // Calculating I (Choosing which output)
    wire [3:0] I;
    assign I = (U & ({5{Up}} & ~{5{Dw}} & ~{5{LD}})) | 
                (D & (~{5{Up}} & {5{Dw}} & ~{5{LD}})) |
                 (Din & {5{LD}});
         
    
    FDRE #(.INIT(1'b0) ) FDRE0 (.C(clk), .R(R), .CE(CE), .D(I[0]), .Q(Q[0])); 
    FDRE #(.INIT(1'b0) ) FDRE1 (.C(clk), .R(R), .CE(CE), .D(I[1]), .Q(Q[1]));   
    FDRE #(.INIT(1'b0) ) FDRE2 (.C(clk), .R(R), .CE(CE), .D(I[2]), .Q(Q[2]));  
    FDRE #(.INIT(1'b0) ) FDRE3 (.C(clk), .R(R), .CE(CE), .D(I[3]), .Q(Q[3]));  

    assign UTC = &Q;    // UTC is 1 if all outputs are 1
    assign DTC = ~(|Q); // DTC is 1 if all outputs are 0
    
endmodule