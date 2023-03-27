% ***********************************************************************
% SETUP:
% Set the parameters for the Body and for the ExoNET
% ***********************************************************************


%% BEGIN
% Define Global Variables
global EXONET BODY PHIs TAUsDESIRED TENSION


%% EXONET
EXONET.K = 300;           % springs stiffness in [N/m]
EXONET.nParameters = 3;   % number of parameters for each spring
EXONET.nJoints = 3;       % hip, knee and hip-knee
EXONET.nElements = menu('Number of stacked elements per joint:', ...
                        '1', ...
                        '2', ...
                        '3', ...
                        '4', ...
                        '5');

% Set the constraints for the parameters:
RLoHi = [0.001 0.20];    % R low and high range in [m]
thetaLoHi = [-360 360];  % theta low and high range in [deg]
L0LoHi = [0.05 0.30];    % L0 low and high range in [m]
i=0;
EXONET.pConstraint = NaN*zeros(EXONET.nJoints*EXONET.nElements*EXONET.nParameters,2); % initialization
for joint = 1:EXONET.nJoints
    for element = 1:EXONET.nElements
        i = i+1;
        EXONET.pConstraint(i,:) = RLoHi;
        i = i+1;
        EXONET.pConstraint(i,:) = thetaLoHi;
        i = i+1;
        EXONET.pConstraint(i,:) = L0LoHi;
    end
end
LL0LoHi = [0.05 0.70];    % L0 low and high range in [m] for the 2-joint element
I = (9*EXONET.nElements)-3*(EXONET.nElements-1);
for j = I:3:length(EXONET.pConstraint)
    EXONET.pConstraint(j,:) = LL0LoHi;
end


%% BODY
BODY.Mass = 70; % body mass in [kg] for a body height of 1.70 m
BODY.Lengths = [0.46 0.42]; % segments lengths (thigh, leg) in [m]
BODY.pose = [10 20]; % angles in [deg] for the thigh and leg positions


%% IMPORT DATA OF THE WALK CYCLE
beatrice_gait_new = xlsread('beatrice_gait.xlsx'); % walk cycle parameters for the right leg
                                                   % (from Bovi et al.)
percentageGaitCycle = beatrice_gait_new(:,1); % percentage of gait cycle
hip_angle = beatrice_gait_new(:,2);   % hip angles in [deg]
knee_angle = beatrice_gait_new(:,3);  % knee angles in [deg]
hip_moment = beatrice_gait_new(:,4);  % hip moments of force in [Nm/kg]
knee_moment = beatrice_gait_new(:,5); % knee moments of force in [Nm/kg]

PHIs = [hip_angle, hip_angle+knee_angle]; % angles in [deg]
TAUsDESIRED = [hip_moment.*(-1).*BODY.Mass, knee_moment.*BODY.Mass]; % moments of force in [Nm]

% STANCE PHASE
%PHIs = [hip_angle(1:63), hip_angle(1:63)+knee_angle(1:63)]; % angles in [deg]
%TAUsDESIRED = [hip_moment(1:63).*(-1).*BODY.Mass, knee_moment(1:63).*BODY.Mass]; % moments of force in [Nm]

% SWING PHASE
%PHIs = [hip_angle(64:end), hip_angle(64:end)+knee_angle(64:end)]; % angles in [deg]
%TAUsDESIRED = [hip_moment(64:end).*(-1).*BODY.Mass, knee_moment(64:end).*BODY.Mass]; % moments of force in [Nm]


% Hip Flexion (+) Hip Extension (-)
% Knee Extension (+) Knee Flexion (-)
% Ankle Dorsiflexion (+) Ankle Plantarflexion (-)

%   o HIP
%   .\
%   . \
%   .  \
%   .   \
%   .    \
%   .phi1 \
%          \
%           o KNEE
%          / .
%         /   .
%        /     .
%       /  phi2 .
%      /
%     /
%    / ANKLE
%   o---------o TOE
%   .
%   . phi3
%   .
%   .


%% CREATE THE DIFFERENT POSITIONS OF THE BODY
Position = forwardKinLeg(PHIs,BODY); % positions associated to the angles


%% DRAW THE BODY ON THE BACKGROUND
% doGraph = menu('Do you want to draw the body?', ...
%                 'YES', ...
%                 'NO');        
% switch doGraph
%     case 1 % YES
%     % single pose of the right leg
%     put_figure(1, 0.02, 0.07, 0.95, 0.82);
%     drawBodyLeg(BODY); % draws the body on the background
%     plot(Position.ankle(:,1),Position.ankle(:,2),'.','color',0.8*[1 1 1]); % plot the positions of the ankle in grey
%       
%     pause(2)
%       
%     % dynamic plot of the right leg
%     put_figure(1, 0.02, 0.07, 0.95, 0.82);
%     for i = 1:length(PHIs)
%         BODY.pose = [PHIs(i,1) PHIs(i,2)];
%         clf % to clear the previous plot
%         drawBodyLeg(BODY);
%         pause(0.0001)
%     end
%     
%     otherwise % NO
%     close all
% end


%% HANDLE = @(ARGLIST) EXPRESSION   constructs an anonymous function and returns the handle to it
TENSION = @(L0,L)   (EXONET.K.*(L-L0)).*((L-L0)>0).*((L*L0)>0); % (inlineFcn) + stretch


%% Optimization Parameters
optOptions = optimset();
optOptions.MaxIter = 1E3;     % optimization limit
optOptions.MaxFunEvals = 1E3; % optimization limit
optimset(optOptions);
nTries = 50;                  % 50 number of optimization reruns 
       % 30*EXONET.nElements

       
fprintf('\n\n\n\n Parameters set~~\n')

