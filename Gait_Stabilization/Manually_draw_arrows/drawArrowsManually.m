% ***********************************************************************
% This script allows to draw new torque arrows on top of
% the Gait Torque Field in the Angles Plane
% ***********************************************************************

clear; clc; close;

setUpLeg % set variables and plots

put_figure(1, 0.02, 0.07, 0.95, 0.82)
plotVectField(PHIs,BODY,Position,TAUsDESIRED,'r'); % to plot the desired torque field in red
axis([-20 50 -10 100])
hold on


prompt = {'Enter the number of arrows you want to draw'};
dlgtitle = 'Number of arrows:';
dims = [1 50];
N = str2double(inputdlg(prompt,dlgtitle,dims));


for n = 1:2:N*2
    CreateStruct.Interpreter = 'tex';
    CreateStruct.WindowStyle = 'modal';
    msgbox('Select starting and ending point of the arrow and then press ENTER',CreateStruct)
    [x,y] = ginput;
    Arrows(n:n+1,:) = [x y];
    
    simpleArrow(Arrows(n,:),Arrows(n+1,:),'b',1.75);
    plot(Arrows(n,1),Arrows(n,2),'.','Color','b') % dots
    hold on
end


%% First option: draw standardized arrows
% [x,y] = ginput;
% Arrows = [x y];
% 
% scaleTau = 0.2; % graphic scale factor for torque pseudo-vectors
% for i = 1:size(x,1)
%     simpleArrow(Arrows(i,:),Arrows(i,:)+scaleTau*20,'b',1.75);
%     plot(Arrows(i,1),Arrows(i,2),'.','Color','b') % dots
%     hold on
% end


%% Second option: draw the arrows manually
% [x,y] = ginput;
% Arrows = [x y];
% % size(mat,1) has to be a multiple of two!!
% 
% for i = 1:2:size(x,1)
%     simpleArrow(Arrows(i,:),Arrows(i+1,:),'b',1.75);
%     plot(Arrows(i,1),Arrows(i,2),'.','Color','b') % dots
%     hold on
% end


%% Third option: draw arrows automatically
% x_lim = linspace(-15,40,60)';
% y_lim = linspace(-5,95,60)';
% for j = 1:size(y_lim,1)
%     for i = 1:size(x_lim,1)
%         grid = [x_lim(i) y_lim(j)];
%     end
% end
% 
% scaleTau = 0.2; % graphic scale factor for torque pseudo-vectors
% for i = 1:size(grid,1)
%     %simpleArrow(mat(i,:),mat(i+1,:),'b',1.75);
%     plot(grid(i,1),grid(i,2),'.','Color','k') % dots
%     hold on
% end

