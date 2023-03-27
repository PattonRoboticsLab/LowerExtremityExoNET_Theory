% ***********************************************************************
% Draw individual MARIONETs for the leg pose specified by phis
% ***********************************************************************

function h = drawExonetsLeg(p,phis)

%% Setup
fprintf('\n\n\n\n Drawing MARIONETs~~\n')
global EXONET BODY


%% Locations for the cartoon
ColorsS = [0.5 0.7 1; 0.1 1 0.2; 1 0.6 0.3]; % 3 distinct RGB color spaces for the springs
ColorsR = [0 0.2 0.9; 0 0.7 0; 0.9 0.4 0]; % 3 distinct RGB color spaces for the rotators
Colors = [1 0.87843 0.40]; % yellow springs
ColorsC = [0.0235294 0.8392157 0.627451]; % green 1-joint springs
ColorsT = [1 0.572549 0.545098]; % pink 2-joint springs
LWs = 2; % lines width springs
LWr = 4; % lines width rotators

hip =   [0      0];
knee =  [0     -0.4451];
ankle = [0.02  -1.03];
toe =   [0.30367  -1.129];

ankleIndex = 1;
kneeFootIndex = EXONET.nParameters*EXONET.nElements+1;


%% Loop through all MARIONETs
if EXONET.nJoints == 11
for element = 1:EXONET.nElements
    fprintf(' Ankle element %d..',element);
    r = p(ankleIndex+(element-1)*EXONET.nParameters+0);
    theta = p(ankleIndex+(element-1)*EXONET.nParameters+1);
    L0 = p(ankleIndex+(element-1)*EXONET.nParameters+2);
    rPos = ankle + [r*sind(theta) -r*cosd(theta)]; % R vector
    plot([rPos(1) toe(1)],[rPos(2) toe(2)],'Color',ColorsC,'Linewidth',LWs);
    plot([ankle(1) rPos(1)],[ankle(2) rPos(2)],'Color',ColorsS(1,:),'Linewidth',LWr);
end
end


if EXONET.nJoints == 22
for element = 1:EXONET.nElements
    fprintf(' Knee element %d..',element);
    r = p(ankleIndex+(element-1)*EXONET.nParameters+0);
    theta = p(ankleIndex+(element-1)*EXONET.nParameters+1);
    L0 = p(ankleIndex+(element-1)*EXONET.nParameters+2);
    rPos = knee + [r*sind(theta) -r*cosd(theta)]; % R vector
    plot([rPos(1) toe(1)],[rPos(2) toe(2)],'Color',ColorsT,'Linewidth',LWs);
    plot([knee(1) rPos(1)],[knee(2) rPos(2)],'Color',ColorsS(3,:),'Linewidth',LWr);
end
end


if EXONET.nJoints == 2
for element = 1:EXONET.nElements
    fprintf(' Ankle element %d..',element);
    r = p(ankleIndex+(element-1)*EXONET.nParameters+0);
    theta = p(ankleIndex+(element-1)*EXONET.nParameters+1);
    L0 = p(ankleIndex+(element-1)*EXONET.nParameters+2);
    rPos = ankle + [r*sind(theta) -r*cosd(theta)]; % R vector
    plot([rPos(1) toe(1)],[rPos(2) toe(2)],'Color',ColorsC,'Linewidth',LWs);
    plot([ankle(1) rPos(1)],[ankle(2) rPos(2)],'Color',ColorsS(1,:),'Linewidth',LWr);
end

for element = 1:EXONET.nElements
    fprintf(' Knee element %d..',element);
    r = p(kneeFootIndex+(element-1)*EXONET.nParameters+0);
    theta = p(kneeFootIndex+(element-1)*EXONET.nParameters+1);
    L0 = p(kneeFootIndex+(element-1)*EXONET.nParameters+2);
    rPos = knee + [r*sind(theta) -r*cosd(theta)]; % R vector
    plot([rPos(1) toe(1)],[rPos(2) toe(2)],'Color',ColorsT,'Linewidth',LWs);
    plot([knee(1) rPos(1)],[knee(2) rPos(2)],'Color',ColorsS(3,:),'Linewidth',LWr);
    end
end

fprintf('\n\n\n\n Done drawing~~\n')

end