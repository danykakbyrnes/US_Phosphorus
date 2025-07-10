clc, clear

% Script to create the color color ramp used in various figures. 

INPUT_folderName = '../INPUTS_061322/';

length = 200;

% q1
start = [134,173,170];
stop = [1,102,94];
QColorRamp(:,:,1) = [linspace(start(1),stop(1),length)', linspace(start(2),...
    stop(2),length)', linspace(start(3),stop(3),length)'];

% q2
start = [255, 237, 199];
stop = [216,179,101];
QColorRamp(:,:,2) = [linspace(start(1),stop(1),length)', linspace(start(2),...
    stop(2),length)', linspace(start(3),stop(3),length)'];
             
% q3
start = [225, 240, 238];
stop = [90,180,172];
QColorRamp(:,:,3) = [linspace(start(1),stop(1),length)', linspace(start(2),...
    stop(2),length)', linspace(start(3),stop(3),length)'];
              
% Q4         
start = [92, 51, 1];
stop = [140,81,10];
QColorRamp(:,:,4) = [linspace(start(1),stop(1),length)', linspace(start(2),...
    stop(2),length)', linspace(start(3),stop(3),length)'];

save([INPUT_folderName, '0_General_Data/divergentColorRamp.mat'],...
    'QColorRamp')