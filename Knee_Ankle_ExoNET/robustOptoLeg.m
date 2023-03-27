% ***********************************************************************
% OPTIMIZATION:
% Make a robust effort to find the global optimization
% and return the best choice of several random initial guesses
% ***********************************************************************

function [bestP,bestCost,TAUs,costs] = robustOptoLeg(PHIs,TAUsDESIRED,BODY,EXONET,nTries)

%% Setup
fprintf('\n\n\n\n robustOpto~~\n')
drawnow    % to update the figures in the graphic screen
pause(0.1) % to pause for 0.1 seconds before continuing

global ProjectName

ProjectName = 'Ankle ExoNET';

p0 = EXONET.pConstraint(:,1)';       % initial values of the parameters
% Randomize initial values of the parameters
j = 2:3:length(EXONET.pConstraint);
p0(j) = p0(j) + randn(1,length(j)).*10; % to randomize theta
k = 1:length(EXONET.pConstraint); k(j) = [];
p0(k) = p0(k) + randn(1,length(k)).*0.1; % to randomize R and L0
% % % % %
bestP = p0;                          % best parameters
bestCost = 1e5;                      % best cost, initially high (10^16)
TAUs = exoNetTorquesLeg(bestP,PHIs); % initial guess for the solution
costs = zeros(nTries,1);             % vector collecting the cost at each try


%% Set the plot
clf % to reset the figure

subplot(1,2,1)
title(ProjectName)
drawMan;
plotAngleTorque(TAUsDESIRED,TAUs,PHIs);

subplot(1,2,2); ax2 = axis(); % to get axis zoom frame
subplot(1,2,1); ax1 = axis(); % to get axis zoom frame

plotAngleTorque(TAUsDESIRED,TAUs,PHIs);

subplot(1,2,1)
drawMan;
drawExonetsLeg(bestP,BODY.pose); % to draw the ExoNET line segments

subplot(1,2,1); axis(ax1); % to reframe the window
subplot(1,2,2); axis(ax2); % to reframe the window

title(ProjectName)
drawnow; pause(0.1) % to show the plots


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
        TAUs = exoNetTorquesLeg(p,PHIs); % new guess for the torque field
    else
        fprintf('\n\n (not an improvement)~~\n')
    end
    costs(TRY) = bestCost; % vector collecting the cost at each try
    pKick = range(EXONET.pConstraint').*(nTries/TRY); % to simulate Annealing Perturbation
    % Kick p away from its best value
    j = 2:3:length(EXONET.pConstraint);
    p0(j) = bestP(j) + 1.*randn(1,length(j)).*pKick(j); % for theta
    k = 1:length(EXONET.pConstraint); k(j) = [];
    p0(k) = bestP(k) + 1.*randn(1,length(k)).*pKick(k).*0.1; % for R and L0
    % % % % %
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

subplot(1,2,1)
drawMan;
drawExonetsLeg(bestP,BODY.pose); % to draw the ExoNET line segments

TAUs = exoNetTorquesTensionsLeg(bestP,PHIs); % to calculate the final solution

% Adjust axis and title
subplot(1,2,2); axis(ax2); % to zoom the frame
subplot(1,2,1); axis(ax1); % to zoom the frame
title([ProjectName ', RMSE = ' num2str(meanErr) ' Nm']); % to show the average error
drawnow; pause(0.1) % to update the screen

subplot(1,2,1)
drawMan;
drawExonetsLeg(bestP,BODY.pose); % to draw the ExoNET line segments

Residual = TAUsDESIRED - TAUs; % to calculate the Residual
plotAngleTorque(TAUsDESIRED,TAUs,PHIs,'exOn');

end