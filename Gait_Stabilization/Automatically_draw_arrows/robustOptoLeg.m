% ***********************************************************************
% OPTIMIZATION:
% Make a robust effort to find the global optimization
% and return the best choice of several random initial guesses
% ***********************************************************************

function [bestP,bestCost,TAUs,costs] = robustOptoLeg(AllPHIs,AllTAUsDESIRED,EXONET,nTries)

%% Setup
fprintf('\n\n\n\n robustOpto~~\n')
drawnow    % to update the figures in the graphic screen
pause(0.1) % to pause for 0.1 seconds before continuing

global PHIs TAUsDESIRED ArrowPHIs ArrowTAUsDESIRED GridPHIs

ProjectName = 'Gait Torques Field';

p0 = EXONET.pConstraint(:,1)';          % initial values of the parameters
% Randomize initial values of the parameters
j = 2:3:length(EXONET.pConstraint);
p0(j) = p0(j) + randn(1,length(j)).*10;
k = 1:length(EXONET.pConstraint); k(j) = [];
p0(k) = p0(k) + randn(1,length(k)).*0.1;
% % % % %
bestP = p0;                             % best parameters
bestCost = 1e5;                         % best cost, initially high (10^16)
TAUs = exoNetTorquesLeg(bestP,AllPHIs); % initial guess for the solution
costs = zeros(nTries,1);                % vector collecting the cost at each try


%% Set the plot
clf % to reset the figure

plotVectFieldLeg(AllPHIs,AllTAUsDESIRED,'r'); % to plot the desired torque field in red
plotVectFieldLeg(AllPHIs,TAUs,[0.9 0.9 0.9]); % to plot the initial guess in grey
axis([-20 50 -10 100])
subplot(1,2,1)
drawMan;
drawExonetsLeg(bestP); % to draw the ExoNET line segments
title(ProjectName)


%% Loop multiple optimization tries with Simulated Annealing Perturbation
fprintf('\n\n\n\n Begin Optimization~~\n')
tic
for TRY = 1:nTries
    fprintf('Opt#%d..',TRY);
    [p,c] = fminsearch('costLeg',p0); % OPTIMIZATION
    [p,c] = fminsearch('costLeg',p);  % OPTIMIZATION
    if c < bestCost                   % if the cost is decreased
        fprintf(' c=%g, ',c); p'      % to display the cost
        bestCost = c;                 % to update the best cost
        bestP = p;                    % to update the best parameters
        TAUs = exoNetTorquesLeg(p,AllPHIs); % new guess for the torque field
    else
        fprintf('\n\n (not an improvement)~~\n')
    end
    costs(TRY) = bestCost; % vector collecting the cost at each try
    pKick = range(EXONET.pConstraint').*(nTries/TRY); % to simulate Annealing Perturbation
    % Kick p away from its best value
    j = 2:3:length(EXONET.pConstraint);
    p0(j) = bestP(j) + 1.*randn(1,length(j)).*pKick(j);
    k = 1:length(EXONET.pConstraint); k(j) = [];
    p0(k) = bestP(k) + 1.*randn(1,length(k)).*pKick(k).*0.1;
end
toc


%% Wrap up the Optimization with one last run starting at the best location
fprintf('\n\n\n\n Final Optimization~~\n')
[p,c] = fminsearch('costLeg',bestP); % last and best OPTIMIZATION
if c < bestCost
    bestCost = c;
    bestP = p;
    fprintf(' c=%g, ',c); p'
else
    fprintf('\n\n (not an improvement)~~\n')
end
[c,meanErr] = costLeg(bestP); meanErr
costs(TRY+1) = c; % vector collecting the cost at each try


%% Update the plots
% Draw the ExoNET and plot the torques
clf % to reset the figure

TAUs = exoNetTorquesLeg(bestP,AllPHIs); % to calculate the final solution
GridTAUs = exoNetTorquesLeg(bestP,GridPHIs); % to calculate ExoNET torques in the grid

plotVectFieldLeg(AllPHIs,AllTAUsDESIRED,[1 0.5451 0.4039]); % to plot the desired torque field in red
plotVectFieldLeg(PHIs,TAUsDESIRED,'r'); % to plot the gait torque field in red
plotVectFieldLeg(AllPHIs,TAUs,[0.1569 0.2157 0.4275]); % to plot the best solution in blue
plotVectFieldLeg(GridPHIs,GridTAUs,[0.6863 0.6980 0.8510]); % to plot ExoNET torques in the grid
% axis([-20 50 -10 100])
subplot(1,2,1)
drawMan;
drawExonetsLeg(bestP); % to draw the ExoNET line segments
title([ProjectName ', Average Error = ' num2str(meanErr)],'FontSize',14) % to show the average error


% %figure
% scaleTau = 0.2;
% for i = 1:length(PHIs)
%     plot(PHIs(i,1),PHIs(i,2),'.r') % dots
%     hold on
% end
% for i = 1:length(ArrowPHIs)
%     plot(ArrowPHIs(i,1),ArrowPHIs(i,2),'.','Color',[1 0.5451 0.4039]) % dots
%     hold on
% end
% axis([-20 50 -10 100])
% box off
% axis image
% for i = 1:length(ArrowPHIs)
%     simpleArrow(ArrowPHIs(i,:),ArrowPHIs(i,:)+scaleTau*ArrowTAUsDESIRED(i,:),[1 0.5451 0.4039],1.75); % arrows
%     hold on
%     pause(0.1)
% end


% %figure
% for i = 1:length(PHIs)
%     plot(PHIs(i,1),PHIs(i,2),'.','Color',[0.9 0.9 0.9]) % dots
%     hold on
% end
% axis([-20 50 -10 100])
% box off
% axis image
% for i = 1:length(ArrowPHIs)
%     plot(ArrowPHIs(i,1),ArrowPHIs(i,2),'.r') % dots
%     hold on
%     pause(0.1)
% end


end