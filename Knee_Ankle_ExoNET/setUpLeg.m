% ***********************************************************************
% SETUP:
% Set the parameters for the Body and for the ExoNET
% ***********************************************************************


%% BEGIN
% Define Global Variables
global EXONET BODY PHIs TAUsDESIRED TENSION1j TENSION2j


%% EXONET
EXONET.K1j = 600;     % springs stiffness in [N/m] for 1-joint Compression Springs
EXONET.K2j = 600;     % springs stiffness in [N/m] for 2-joint Compression Springs
%EXONET.K1j = 2000;   % springs stiffness in [N/m] for 1-joint Tension Springs
%EXONET.K2j = 800;    % springs stiffness in [N/m] for 2-joint Compression Springs
EXONET.nParameters = 3;   % number of parameters for each spring
EXONET.nJoints = 2;   % 11 = only ankle-toe springs
                      % 22 = only knee-toe springs
                      % 2 = both ankle-toe and knee-toe springs
EXONET.nElements = menu('Number of stacked elements per joint:', ...
                        '1', ...
                        '2', ...
                        '3', ...
                        '4', ...
                        '5', ...
                        '6');

% Set the constraints for the parameters:
RLoHi = [0.03 0.20];   % R low and high range in [m]
thetaLoHi = [150 360]; % theta low and high range in [deg]
L0LoHi = [0.10 0.20];  % L0 low and high range in [m] for 1-joint Compression Springs
%L0LoHi = [0.05 0.20];  % L0 low and high range in [m] for 1-joint Tension Springs

if EXONET.nJoints == 11
i=0;
EXONET.pConstraint = NaN*zeros(1*EXONET.nElements*EXONET.nParameters,2); % initialization
for joint = 1:1
    for element = 1:EXONET.nElements
        i = i+1;
        EXONET.pConstraint(i,:) = RLoHi;
        i = i+1;
        EXONET.pConstraint(i,:) = thetaLoHi;
        i = i+1;
        EXONET.pConstraint(i,:) = L0LoHi;
    end
end
end

if EXONET.nJoints == 22
EXONET.K2j = 1000;     % springs stiffness in [N/m] for 2-joint Compression Springs
RLoHi = [0.03 0.30];   % R low and high range in [m]
thetaLoHi = [0 360];   % theta low and high range in [deg]
L0LoHi = [0.40 0.50];  % L0 low and high range in [m] for 2-joint Compression Springs
i=0;
EXONET.pConstraint = NaN*zeros(1*EXONET.nElements*EXONET.nParameters,2); % initialization
for joint = 1:1
    for element = 1:EXONET.nElements
        i = i+1;
        EXONET.pConstraint(i,:) = RLoHi;
        i = i+1;
        EXONET.pConstraint(i,:) = thetaLoHi;
        i = i+1;
        EXONET.pConstraint(i,:) = L0LoHi;
    end
end
end

if EXONET.nJoints == 2
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
LL0LoHi = [0.40 0.60];    % L0 low and high range in [m] for 2-joint Compression Springs
%LL0LoHi = [0.05 0.20];   % L0 low and high range in [m] for 2-joint Tension Springs
I = EXONET.nParameters*EXONET.nElements+3;
for j = I:3:length(EXONET.pConstraint)
    EXONET.pConstraint(j,:) = LL0LoHi;
end
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

phis = [hip_angle, hip_angle+knee_angle, 90-(knee_angle+ankle_angle)]; % angles in [deg]
tausD = ankle_moment.*(-1).*BODY.Mass; % ankle moments of force in [Nm]
tausKnee = knee_moment.*BODY.Mass; % knee moments of force in [Nm]

% ENTIRE GAIT CYCLE
%PHIs = [hip_angle, hip_angle+knee_angle, 90-(knee_angle+ankle_angle)]; % angles in [deg]
%TAUsDESIRED = ankle_moment.*(-1).*BODY.Mass; % moments of force in [Nm]

% STANCE PHASE
%PHIs = [hip_angle(1:63), hip_angle(1:63)+knee_angle(1:63), 90-(knee_angle(1:63)+ankle_angle(1:63))]; % angles in [deg]
%TAUsDESIRED = ankle_moment(1:63).*(-1).*BODY.Mass; % moments of force in [Nm]

% LATE STANCE PHASE
PHIs = [hip_angle(9:63), hip_angle(9:63)+knee_angle(9:63), 90-(knee_angle(9:63)+ankle_angle(9:63))]; % angles in [deg]
TAUsDESIRED = [ankle_moment(9:63).*(-1).*BODY.Mass, knee_moment(9:63).*BODY.Mass]; % moments of force in [Nm]

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


%% HANDLE = @(ARGLIST) EXPRESSION   constructs an anonymous function and returns the handle to it
% 1-joint Springs
TENSION1j = @(L0,L)   (EXONET.K1j.*(L-L0)).*((L-L0)<0).*((L*L0)>0); % Linear Compression Springs
%TENSION1j = @(L0,L)   (EXONET.K1j.*(L-L0)).*((L-L0)>0).*((L*L0)>0); % Linear Tension Springs

% 2-joint Springs
TENSION2j = @(L0,L)   (EXONET.K2j.*(L-L0)).*((L-L0)<0).*((L*L0)>0); % Linear Compression Springs
%TENSION2j = @(L0,L)   (EXONET.K2j.*(L-L0)).*((L-L0)>0).*((L*L0)>0); % Linear Tension Springs


%% Optimization Parameters
optOptions = optimset();
optOptions.MaxIter = 1E3;     % optimization limit
optOptions.MaxFunEvals = 1E3; % optimization limit
optimset(optOptions);
nTries = 50;                  % 50 number of optimization reruns 
       % 30*EXONET.nElements

       
fprintf('\n\n\n\n Parameters set~~\n')

