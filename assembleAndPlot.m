%% Script to assemble required measurements from a list of .dat files, 
% and then plot 3D graphs of the data.
%
%
% See also getMeasurements.

% Tidy up:
clear; home; close all

%% Step 1: Create a list of files.
folderName = 'Squeal_dat';
fileList = ls([folderName, filesep, '*.dat']); % this a character array
% How can you get the folder name as part of the file name?
fileList = cellstr(strcat(folderName, filesep, fileList));

%% Step 2: For each file in the list, use the getMeasurements function
% to extract only the required data.
C = cell(size(fileList)); % Preallocation statement
for k = 1:length(fileList)
C{k} = getMeasurements(fileList{k});
end

%% Assemble into a numeric matrix.
C = cell2mat(C);

%% Step 3: Plot the required data.

frequency = C(:,1);
pressure = C(:,2);
friction = C(:,3);
dampingRatio = C(:,4);

figure(1)
stem3( frequency, pressure, dampingRatio )
xlabel('Frequency')
ylabel('Pressure')
zlabel('Damping Ratio')

figure(2)
stem3( frequency, friction, dampingRatio )
xlabel('Frequency')
ylabel('Friction')
zlabel('Damping Ratio')

%% Step 4: Perform some surface fitting.
x = linspace(min(frequency), max(frequency));
y1 = linspace(min(pressure), max(pressure));
y2 = linspace(min(friction), max(friction));

[X1, Y1] = meshgrid(x, y1);
[X2, Y2] = meshgrid(x, y2);

Z1 = griddata(frequency, pressure, dampingRatio,X1, Y1);
Z2 = griddata(frequency, friction, dampingRatio, X2, Y2);

figure(3)
s = surf(X1, Y1, Z1);
xlabel('Frequency'), ylabel('Pressure'), zlabel('Damping Ratio')
shading('interp')

figure(4)
surf(X2, Y2, Z2)
xlabel('Frequency'), ylabel('Friction'), zlabel('Damping Ratio')
shading('interp')

%% Step 5: Additional graphics.
% Interpolate a point on the surface.
zInterp = griddata(frequency, pressure, dampingRatio, 3500, 15);
figure(3)
hold on
[C, h] = contour3(X1, Y1, Z1, 20, 'k');
clabel(C, h, 'LabelSpacing', 500)
set(s, 'FaceAlpha', 0.8)

% %%
% hold on
% plot3(3500, 15, zInterp, 'Marker', '.', 'MarkerSize', 30, 'Color', 'r')
% 
% % Draw a curve on the surface.
% fTarget = 3900;
% [~, idxMin] = min(abs(x-fTarget));
% xLine = x(idxMin)*ones(size(x));
% yLine = y1;
% zLine = Z1(idxMin, :);
% plot3(xLine, yLine, zLine, 'Color', 'm', 'LineWidth', 2)
% hold off
% 






    

