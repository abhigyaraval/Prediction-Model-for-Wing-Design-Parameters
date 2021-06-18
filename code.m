clear all;
clc
CL = 0.353;
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
19
end
idx(1) = find(cL == uppercL);
idx(2) = find(cL == lowercL);
%% Mesh griddata
x = linspace(0, 35, 501); % sweep angle grid
y = linspace(0.08, 0.12, 501); % thickness grid
[xq, yq] = meshgrid(x, y);
% Interpolated Matrix- The following contains solutions for respective cL
GridUpper = griddata(sweep, tc, Mach(:,:,idx(1)), xq, yq);
GridLower = griddata(sweep, tc, Mach(:,:,idx(2)), xq, yq);
%% Finding all the Mdiv vectors at given Cl using linear fit
slope = (GridUpper - GridLower)/(uppercL - lowercL);
intercept = GridUpper - slope*uppercL;
Mdiv = slope*CL + intercept;
%% Design Problem
log = Mdiv>0.86; % logical array
sweep = xq.*log; % required sweep angles
t = yq.*log; % required thickness
% Range of thickness
t(t == 0) = NaN;
tmin = min(min(t))
tmax = max(max(t))
% Range of Sweep angles
sweep(sweep == 0) = NaN;
smin = min(min(sweep(:,:)))
smax = max(max(sweep(:,:)))
%% Plot
surf(sweep,t,Mdiv.*log);hold on; grid on;
xlabel(’Sweep angle’)
ylabel(’Thickness’)
zlabel(’Mach divergence’)
h = colorbar;
set(h, ’ylim’, [0.84 1])
