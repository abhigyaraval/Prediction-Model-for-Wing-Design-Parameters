function [Mdiv] = aarlab3(S, TC, CL)
% AARLAB3 Predicts the Divergence Mach number
% at a given sweep angle, thickness ratio and lift coefficient
%
% SYNTAX: Mdiv = AARLAB3(sweep, thickness ratio, lift coefficient)
%
% Range of inputs allowed:
% Lift Coefficient: [0.2, 0.6]
% Sweep angle: [0, 35] degrees
% Thickness ratio: [0.08, 0.12]
%% Organize dataset
sweep = [0 15 25 35]; % sweep angle
cL = linspace(0.2,0.6,5); % lift coefficient
tc =[0.08 0.1 0.12]; % thickness
for i = 1:length(sweep)
% The spreadsheet used here is attached on the CANVAS submission
% Please use that for the function to work
Mach(:,:,i) = xlsread(’data.xlsx’,i);
end
Mach(Mach == 0.11) = NaN;
for i = 1:length(cL)
Mach1(:, :, i) = Mach(i, :,:);
end
Mach = Mach1; % for data in Mach, thickness is y-axis, lift is z-axis and sweep is x-axis
%% Find bounds for lift coefficient
if CL >=0.2 && CL < 0.3
uppercL = 0.3; lowercL = 0.2;
elseif CL >=0.3 && CL < 0.4
uppercL = 0.4; lowercL = 0.3;
elseif CL >=0.4 && CL < 0.5
uppercL = 0.5; lowercL = 0.4;
elseif CL >=0.5 && CL <= 0.6
uppercL = 0.6; lowercL = 0.5;
else
fprintf("error")
uppercL = NaN;
lowercL = NaN;
end
idx(1) = find(cL == uppercL);
idx(2) = find(cL == lowercL);
%% Mesh griddata
x = linspace(0, 35, 5001); % sweep angle grid
y = linspace(0.08, 0.12, 501); % thickness grid
[xq, yq] = meshgrid(x, y);
18
% Interpolated Matrix- The following contains solutions for respective cL
GridUpper = griddata(sweep, tc, Mach(:,:,idx(1)), xq, yq);
GridLower = griddata(sweep, tc, Mach(:,:,idx(2)), xq, yq);
% Scanning for correct location of requested Sweep and thickness
[c, indS] = min(abs(S-x)); [c, indT] = min(abs(TC-y));
% Mach divergence prediction for upper and lower cL
Md(1) = GridLower(indT, indS); Md(2) = GridUpper(indT, indS);
%% Final linear-fit for cL
slope = (Md(2)-Md(1))/(uppercL - lowercL);
intercept = Md(2) - slope*uppercL;
Mdiv = slope*CL + intercept;