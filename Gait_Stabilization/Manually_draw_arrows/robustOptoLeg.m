% ***********************************************************************
% OPTIMIZATION:
% Make a robust effort to find the global optimization
% and return the best choice of several random initial guesses
% ***********************************************************************

function [bestP,bestCost,TAUs,costs] = robustOptoLeg(PHIs,BODY,EXONET,nTries,percentageGaitCycle)

%% Setup
fprintf('\n\n\n\n robustOpto~~\n')
drawnow    % to update the figures in the graphic screen
pause(0.1) % to pause for 0.1 seconds before continuing

global ProjectName TAUsDESIRED

if length(PHIs)<=101
ProjectName = 'Gait Torques Field';
else
ProjectName = 'Arrow Torques Field';
end

p0 = EXONET.pConstraint(:,1)';       % initial values of the parameters
bestP = p0;                          % best parameters
bestCost = 1e5;                      % best cost, initially high
TAUs = exoNetTorquesLeg(bestP,PHIs); % initial guess for the solution
costs = zeros(nTries,1);             % vector collecting the cost at each try


%% Set the plot
clf % to reset the figure

if length(PHIs)<=101
subplot(1,2,1)
title(ProjectName)
drawBodyLeg(BODY);
plotVectFieldLeg(PHIs,TAUsDESIRED,'r'); % to plot the desired torque field in red

subplot(1,2,2); ax2 = axis(); % to get axis zoom frame
subplot(1,2,1); ax1 = axis(); % to get axis zoom frame

plotVectFieldLeg(PHIs,TAUs,0.9*[1 1 1]); % to plot the initial guess in grey
plotVectFieldLeg(PHIs,TAUsDESIRED,'r');  % to plot the desired torque field in red

subplot(1,2,1)
drawBodyLeg(BODY);
drawExonetsLeg(bestP,BODY.pose); % to draw the ExoNET line segments

subplot(1,2,1); axis(ax1); % to reframe the window
subplot(1,2,2); axis(ax2); % to reframe the window

title(ProjectName)
drawnow; pause(0.1) % to show the plots

else

plotVectFieldLeg(PHIs,TAUsDESIRED,'r');  % to plot the desired torque field in red
plotVectFieldLeg(PHIs,TAUs,0.9*[1 1 1]); % to plot the initial guess in grey
axis([-20 50 -10 100])
subplot(1,2,1)
drawBodyLeg(BODY);
drawExonetsLeg(bestP,BODY.pose); % to draw the ExoNET line segments
title(ProjectName)
drawnow
end


%% Loop multiple optimization tries with Simulated Annealing Perturbation
fprintf('\n\n\n\n Begin Optimizations~~\n')
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
        
        % Update the plots
        clf % to reset the figure
        subplot(1,2,1)
        drawBodyLeg(BODY);
        drawExonetsLeg(bestP,BODY.pose); % to draw the ExoNET line segments
        plotVectFieldLeg(PHIs,TAUsDESIRED,'r');    % to plot the desired torque field in red
        plotVectFieldLeg(PHIs,TAUs,[0.8 0.9 0.9]); % to plot the improved solution in grey
        fprintf('\n');
        drawnow; pause(0.1) % to update the display
        title([ProjectName ', costLeg = ' num2str(c)])
        drawnow; pause(0.1) % to update the display
    else
        fprintf('\n\n (not an improvement)~~\n')
    end
    costs(TRY) = bestCost; % vector collecting the cost at each try
    pKick = range(EXONET.pConstraint').*(nTries/TRY); % to simulate Annealing Perturbation
    p0 = bestP + 1.*randn(1,length(p0)).*pKick.*0.01; % to kick p away from its best value
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
costs(TRY+1) = c;  % vector collecting the cost at each try


%% Update the plots
% Draw the ExoNET and plot the torques
clf % to reset the figure

if length(PHIs)<=101
subplot(1,2,1)
drawBodyLeg(BODY);
drawExonetsLeg(bestP,BODY.pose); % to draw the ExoNET line segments

% figure;
% drawBodyLeg(BODY);
% drawRestingLengthsLeg(bestP,BODY.pose); % to draw the resting lengths L0

%TAUs = exoNetTorquesTensionsLeg(bestP,PHIs,'plotIt'); % to plot Tension vs Length
TAUs = exoNetTorquesLeg(bestP,PHIs); % to calculate the final solution

Residual = TAUsDESIRED - TAUs;          % to calculate the Residual
plotVectFieldLeg(PHIs,TAUsDESIRED,'r'); % to plot the desired torque field in red
plotVectFieldLeg(PHIs,TAUs,'b');        % to plot the best solution in blue
%plotVectFieldLeg(PHIs,Residual,[0.8 0.9 0.9]);  % to plot the Residual in grey

% Adjust axis and title
subplot(1,2,2); axis(ax2); % to zoom the frame
subplot(1,2,1); axis(ax1); % to zoom the frame
title([ProjectName ', Average Error = ' num2str(meanErr)]); % to show the average error
drawnow; pause(0.1) % to update the screen

subplot(1,2,1)
drawBodyLeg(BODY);
drawExonetsLeg(bestP,BODY.pose); % to draw the ExoNET line segments

else

TAUs = exoNetTorquesLeg(bestP,PHIs); % to calculate the final solution
plotVectFieldLeg(PHIs,TAUsDESIRED,'r'); % to plot the desired torque field in red
plotVectFieldLeg(PHIs,TAUs,'b'); % to plot the best solution in blue
axis([-20 50 -10 100])
subplot(1,2,1)
drawBodyLeg(BODY);
drawExonetsLeg(bestP,BODY.pose); % to draw the ExoNET line segments
title([ProjectName ', Average Error = ' num2str(meanErr)]); % to show the average error
drawnow
end

end