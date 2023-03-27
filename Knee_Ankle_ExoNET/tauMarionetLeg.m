% ***********************************************************************
% Calculate the torque created by a MARIONET
% ***********************************************************************

function [tau,T,Tdist] = tauMarionetLeg(phi,L,r,theta,L0)

global TENSION1j

rVect = [r*sind(theta) -r*cosd(theta)  0]; % R vector
lVect = [L*sind(phi)   -L*cosd(phi)    0]; % anatomical segment vector
Tdir = rVect - lVect;                      % MARIONET vector
Tdist = norm(Tdir);                        % magnitude of MARIONET vector
Tdir = Tdir./Tdist;                        % MARIONET unit vector
T = TENSION1j(L0,Tdist);                   % magnitude of the Tension exerted by the MARIONET
tauVect = cross(rVect,T.*Tdir);            % cross product between the R vector and the Tension vector
tau = tauVect(3);                          % the 3rd dimension is the torque

end