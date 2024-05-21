`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2023 05:08:25 PM
// Design Name: 
// Module Name: top_lab6
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


module top_lab6(
    input clkin,
    input btnU,         // Up button
    input btnC,         // Start Game button
    input btnR,         // Global reset button
    output [15:0] led,
    output [3:0] an,
    output [6:0] seg,
    output Hsync,
    output Vsync,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue
    );
    // synchronizing all asynchronous external inputs
    wire buttonR, buttonC, buttonU;
    FDRE #(.INIT(1'b0) ) FDRE_btnR (.C(clk), .R(1'b0), .CE(1'b1), .D(btnR), .Q(buttonR));   // RESET GAME
    FDRE #(.INIT(1'b0) ) FDRE_btnU (.C(clk), .R(1'b0), .CE(1'b1), .D(btnU), .Q(buttonU));   // GO UP
    FDRE #(.INIT(1'b0) ) FDRE_btnC (.C(clk), .R(1'b0), .CE(1'b1), .D(btnC), .Q(buttonC));   // START GAME
 
    // clk
    wire clk, digsel;
    labVGA_clks not_so_slow (.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel));
    
    // pixel address calculator
    wire [15:0] x, y;
    wire active, frame, frame2;
        // Gives current pixel, active area, and two frames (evenly spaced out)
    pixelAddress pixel (.clk(clk), .R(buttonR), .V(y), .H(x), .AA(active), .frame(frame), .frame2(frame2));
    
    // game state machine
    wire hitBug, die, timeUp, idleS, platMove, bugMove, slugMove, bugFlash, slugFlash, timeLoad, timeRun, incScore;
        // player dies when either they hit the pond or the side of the platform
    assign die = hitPond | pinned;
    stateMachine gameSM (.start(buttonC), .hitBug(hitBug), .die(die), .timeUp(timeUp), .reset(buttonR),
                        .clk(clk), .idleS(idleS), .platMove(platMove), .bugMove(bugMove), .slugMove(slugMove),
                        .bugFlash(bugFlash), .slugFlash(slugFlash), .timeLoad(timeLoad), .timeRun(timeRun),
                        .incScore(incScore));
    
    // time for scoring (time for bug to flash)
    wire runTimer;    
    assign runTimer = timeRun & ~timeUp & frame;  // run time every frame and stop at all 0s (DTC)
    wire [7:0] Q;
    countUD8L timer (.Up(1'b0), .Dw(runTimer), .LD(timeLoad), .R(1'b0), .Din({1'b0, {7{1'b1}}}), .clk(clk), .Q(Q), .UTC(), .DTC(timeUp));

    
    //platforms
    wire [15:0] ONEplatH, ONEplatV, TWOplatH, TWOplatV, THREEplatH, THREEplatV,
                ONEplatW, TWOplatW, THREEplatW;
    wire ONEplat, TWOplat, THREEplat;
    platform plat_one (.H(x), .V(y), .IDLE(idleS), .clk(clk), .startX({16'd300}), .startW({16'd200}), .frame1(frame), .platMove(platMove),
                    .platH(ONEplatH), .platV(ONEplatV), .platW(ONEplatW), .plat(ONEplat), .slugCollide(hitLeft));
                    
    platform plat_two (.H(x), .V(y), .IDLE(idleS), .clk(clk), .startX({16'd601}), .startW({16'd150}), .frame1(frame), .platMove(platMove),
                    .platH(TWOplatH), .platV(TWOplatV), .platW(TWOplatW), .plat(TWOplat), .slugCollide(hitLeft));
    
    platform plat_three (.H(x), .V(y), .IDLE(idleS), .clk(clk), .startX({16'd902}), .startW({16'd230}), .frame1(frame), .platMove(platMove),
                    .platH(THREEplatH), .platV(THREEplatV), .platW(THREEplatW), .plat(THREEplat), .slugCollide(hitLeft));
     
    // bug
    wire [15:0] bugH, bugV;
    wire bug;
    bug bug_one (.clk(clk), .H(x), .V(y), .frame2(frame | frame2), .IDLE(idleS), .score(incScore), .bugMove(bugMove),
                    .bugH(bugH), .bugV(bugV), .bug(bug));
                  
    // slug
    wire [15:0] slugH, slugV;
    wire slug, hitPond, hitLeft;
    slug player (.slugUp(buttonU), .slugMove(slugMove), .H(x), .V(y), .IDLE(idleS), .plat(plat), .hang(hang), .pinned(pinned), .frame1(frame), .frame2(frame | frame2), .clk(clk),
                .slugH(slugH), .slugV(slugV), .slug(slug), .hitPond(hitPond), .hitLeft(hitLeft));
   

    // slug & bug (player scored)
    assign hitBug = slug & bug;

     // slug & platform
     wire plat, hang, pinned;   // indicates when slug is on top of platform...
                                // ... when slug is hanging...
                                // ... and when slug is pinned against platform.
    slugPlatform slugAndPlats (.slugH(slugH), .slugV(slugV), .ONEplatH(ONEplatH), .ONEplatV(ONEplatV), .ONEplatW(ONEplatW),
                                .TWOplatH(TWOplatH), .TWOplatV(TWOplatV), .TWOplatW(TWOplatW), .THREEplatH(THREEplatH), .THREEplatV(THREEplatV), .THREEplatW(THREEplatW),
                                .plat(plat), .hang(hang), .pinned(pinned));
              
    // Coord Color Picker
    wire b;
    assign b = ((16'd0 <= y) && (y <= 16'd7)) || ((16'd632 <= x) && (x <= 16'd639))
                || ((16'd472 <= y) && (y <= 16'd479)) || ((16'd0 <= x) && (x <= 16'd7));
//    borderRGB walls (.H(x), .V(y), .b(b));

    // pond
    wire p;
    assign p = (y >= 16'd374);  
//    pondRGB ocean (.H(x), .V(y), .p(p));
    
    // flasher
    wire [7:0] flash;
    countUD8L flasher (.Up(frame), .Dw(1'b0), .LD(1'b0), .R(1'b0), .Din({8{1'b0}}), .clk(clk), .Q(flash), .UTC(), .DTC());

    // RGB control
    wire [3:0] RED, GRN, BLU;
    assign RED = {4{active}} & ({4{1'b0}} | ({4{b}} & {4{1'b0}}) | ({4{p & ~b}} & {4{1'b0}}) |
                ({4{(ONEplat | TWOplat | THREEplat) & ~b}} & {{3{1'b1}}, 1'b0}) | ({4{(bug & ~b & ~bugFlash) | (bug & ~b & bugFlash & flash[4])}} & {4{1'b0}}) | 
                ({4{(slug & ~slugFlash) | (slug & slugFlash & flash[5])}} & {{3{1'b1}}, 1'b0}));
    assign GRN = {4{active}} & ({4{1'b0}} | ({4{b}} & {4{1'b0}}) | ({4{p & ~b}} & {{2{1'b1}}, {2{1'b0}}}) | 
                ({4{(ONEplat | TWOplat | THREEplat) & ~b}} & {{2{1'b0}}, {2{1'b1}}}) | ({4{(bug & ~b & ~bugFlash) | (bug & ~b & bugFlash & flash[4])}} & {4{1'b1}}) | 
                ({4{(slug & ~slugFlash) | (slug & slugFlash & flash[5])}} & {{2{1'b1}}, {2{1'b0}}}));
    assign BLU = {4{active}} & ({4{1'b0}} | ({4{b}} & {4{1'b1}}) | ({4{p & ~b}} & {{3{1'b1}}, 1'b0}) |
                ({4{(ONEplat | TWOplat | THREEplat) & ~b}} & {1'b0, {3{1'b1}}}) | ({4{(bug & ~b & ~bugFlash) | (bug & ~b & bugFlash & flash[4])}} & {4{1'b0}}) |
                ({4{(slug & ~slugFlash) | (slug & slugFlash & flash[5])}} & {4{1'b0}}));
    
    // syncs
    wire HS, VS;
    syncs sync (.V(y), .H(x), .Vsync(VS), .Hsync(HS));
    
    // score counter
    wire [7:0] score;
    countUD8L scoreCounter (.Up(incScore), .Dw(1'b0), .LD(1'b0), .R(buttonR), .Din({8{1'b0}}),
     .clk(clk), .Q(score), .UTC(), .DTC());
     
    
    // Output Synchronisers
    FDRE #(.INIT(1'b1) ) FDRE_Hsync (.C(clk), .R(buttonR), .CE(1'b1), .D(HS), .Q(Hsync));
    FDRE #(.INIT(1'b1) ) FDRE_Vsync (.C(clk), .R(buttonR), .CE(1'b1), .D(VS), .Q(Vsync));
    FDRE #(.INIT(1'b0))  FDRE_vgaRed[3:0] (.C({4{clk}}),.R({4{buttonR}}),.CE({4{1'b1}}),.D(RED),.Q(vgaRed));
    FDRE #(.INIT(1'b0))  FDRE_vgaGreen[3:0] (.C({4{clk}}),.R({4{buttonR}}),.CE({4{1'b1}}),.D(GRN),.Q(vgaGreen));
    FDRE #(.INIT(1'b0))  FDRE_vgaBlue[3:0] (.C({4{clk}}),.R({4{buttonR}}),.CE({4{1'b1}}),.D(BLU),.Q(vgaBlue));



 // Score Display
     // ring counter
    wire [3:0] sel;
    ringCounter RC (.clk(clk), .R(buttonR), .adv(digsel), .o(sel));
    
    // an logic
    assign an = {1'b1,      // always off
                 1'b1,      // always off
                 ~(sel[1]),
                 ~(sel[0])};
                 
    // selector
    wire [3:0] h;
    wire [15:0] qWire;
    assign qWire = {{8{1'b0}}, score};
    selector S (.sel(sel), .N(qWire), .H(h));
    
    // hex display
    hex7seg hexdisplay(.n(h), .seg(seg));
     
endmodule
