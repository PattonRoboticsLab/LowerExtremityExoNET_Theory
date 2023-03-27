% ***********************************************************************
% Calculate the torques created by a 2-joint MARIONET
% ***********************************************************************

function [taus,T,Tdist] = tau2jMarionetLeg(phis,Ls,r,theta,L0)

global TENSION2j

rVect = [r*sind(theta)  -r*cosd(theta)  0];            % R vector
knee = [Ls(1)*sind(phis(1))  -Ls(1)*cosd(phis(1))  0]; % knee position
ankle = [knee(1) + Ls(2)*sind(phis(1)-phis(2)), ...    % ankle position
         knee(2) - Ls(2)*cosd(phis(1)-phis(2)), ...
         0];
foot = [ankle(1) + Ls(3)*sind(phis(3)), ...            % foot position
        ankle(2) - Ls(3)*cosd(phis(3)), ...
        0];
knee2foot = foot - knee;   % knee-foot vector
knee2ankle = ankle - knee; % knee-ankle vector
ankle2foot = foot - ankle; % ankle-foot vector
Tdir = rVect - knee2foot;  % MARIONET vector
Tdist = norm(Tdir);        % magnitude of MARIONET vector
Tdir = Tdir./Tdist;        % MARIONET unit vector
T = TENSION2j(L0,Tdist);   % magnitude of the Tension exerted by the MARIONET
tau1 = cross(knee2foot,T.*Tdir);  % cross product for knee torque
tau2 = cross(ankle2foot,T.*Tdir); % cross product for ankle torque
taus = [tau1(3) tau2(3)];         % the 3rd dimension is the torque

end