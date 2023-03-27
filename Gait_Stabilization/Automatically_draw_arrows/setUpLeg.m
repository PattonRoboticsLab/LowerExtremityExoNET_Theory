% ***********************************************************************
% SETUP:
% Set the parameters for the Body and for the ExoNET
% ***********************************************************************


%% BEGIN
% Define Global Variables
global EXONET BODY PHIs TAUsDESIRED GridPHIs TENSION


%% EXONET
EXONET.K = 400;           % springs stiffness in [N/m]
EXONET.nParameters = 3;   % number of parameters for each spring
EXONET.nJoints = 3;       % hip, knee and hip-knee
EXONET.nElements = menu('Number of stacked elements per joint:', ...
                        '1', ...
                        '2', ...
                        '3', ...
                        '4', ...
                        '5');

% Set the constraints for the parameters:
RLoHi = [0.001 0.30];    % R low and high range in [m]
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
BODY.Lengths = [0.46 0.42 0.26]; % segments lengths (thigh, shank, foot) in [m]
BODY.pose = [10 20 90]; % angles in [deg] for the thigh, shank and foot positions


%% IMPORT DATA OF THE WALK CYCLE
beatrice_gait_hip_knee_ankle = xlsread('beatrice_gait_hip_knee_ankle.xlsx'); % walk cycle parameters for the right leg
                                                  % (from Bovi et al.)
percentageGaitCycle = beatrice_gait_hip_knee_ankle(:,1); % percentage of gait cycle
hip_angle = beatrice_gait_hip_knee_ankle(:,2);    % hip angles in [deg]
knee_angle = beatrice_gait_hip_knee_ankle(:,3);   % knee angles in [deg]
ankle_angle = beatrice_gait_hip_knee_ankle(:,4);  % ankle angles in [deg]
hip_moment = beatrice_gait_hip_knee_ankle(:,5);   % hip moments of force in [Nm/kg]
knee_moment = beatrice_gait_hip_knee_ankle(:,6);  % knee moments of force in [Nm/kg]
ankle_moment = beatrice_gait_hip_knee_ankle(:,7); % ankle moments of force in [Nm/kg]

PHIs = [hip_angle, hip_angle+knee_angle]; % angles in [deg]
TAUsDESIRED = [hip_moment.*(-1).*BODY.Mass, knee_moment.*BODY.Mass]; % moments of force in [Nm]

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


%% CREATE GRID IN THE ANGLE PLANE
Xgrid = -15:5:45;
Ygrid = -5:5:95;

n = 0;
for j = 1:length(Ygrid)
    for i = 1:length(Xgrid)
        GridPHIs(i+n,:) = [Xgrid(i) Ygrid(j)];
    end
    n = n + length(Xgrid);
end

figure
plot(GridPHIs(:,1),GridPHIs(:,2),'.r')


%% HANDLE = @(ARGLIST) EXPRESSION   constructs an anonymous function and returns the handle to it
TENSION = @(L0,L)   (EXONET.K.*(L-L0)).*((L-L0)>0).*((L*L0)>0); % (inlineFcn) + stretch


%% Optimization Parameters
optOptions = optimset();
optOptions.MaxIter = 1E3;     % optimization limit
optOptions.MaxFunEvals = 1E3; % optimization limit
optimset(optOptions);
nTries = 5;                  % number of optimization reruns


fprintf('\n\n\n\n Parameters set~~\n')

