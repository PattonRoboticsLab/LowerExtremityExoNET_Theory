% ***********************************************************************
% Draw individual MARIONETs for the leg pose specified by phis
% ***********************************************************************

function h = drawExonetsLeg(p)

%% Setup
fprintf('\n\n\n\n Drawing MARIONETs~~\n')
global EXONET


%% Locations for the cartoon
ColorsS = [0 0.2 0.9; 0 0.7 0; 0.9 0.4 0]; % 3 distinct RGB color spaces for the springs
ColorsR = [0.5 0.7 1; 0.1 1 0.2; 1 0.6 0.3]; % 3 distinct RGB color spaces for the rotators
LWs = 2; % lines width springs
LWr = 4; % lines width rotators

hip =   [0      0];
knee =  [0     -0.4451];
ankle = [0.02  -1.03];
toe =   [0.30367  -1.129];

hipIndex = 1;
kneeIndex = EXONET.nParameters*EXONET.nElements+1;
hipKneeIndex = EXONET.nParameters*EXONET.nElements*2+1;


%% Loop through all MARIONETs
for element = 1:EXONET.nElements
    fprintf(' Hip element %d..',element);
    r = p(hipIndex+(element-1)*EXONET.nParameters+0);
    theta = p(hipIndex+(element-1)*EXONET.nParameters+1);
    L0 = p(hipIndex+(element-1)*EXONET.nParameters+2);
    rPos = [r*sind(theta) -r*cosd(theta)]; % R vector
    plot([rPos(1) knee(1)],[rPos(2) knee(2)],'Color',ColorsS(3,:),'Linewidth',LWs);
    plot([hip(1) rPos(1)],[hip(2) rPos(2)],'Color',ColorsR(3,:),'Linewidth',LWr);
end

for element = 1:EXONET.nElements
    fprintf(' Knee element %d..',element);
    r = p(kneeIndex+(element-1)*EXONET.nParameters+0);
    theta = p(kneeIndex+(element-1)*EXONET.nParameters+1);
    L0 = p(kneeIndex+(element-1)*EXONET.nParameters+2);
    rPos = knee + [r*sind(theta) -r*cosd(theta)]; % R vector
    plot([rPos(1) ankle(1)],[rPos(2) ankle(2)],'Color',ColorsS(1,:),'Linewidth',LWs);
    plot([knee(1) rPos(1)],[knee(2) rPos(2)],'Color',ColorsR(1,:),'Linewidth',LWr);
end

if EXONET.nJoints == 3
    for element = 1:EXONET.nElements
        fprintf(' Hip-Knee element %d..',element);
        r = p(hipKneeIndex+(element-1)*EXONET.nParameters+0);
        theta = p(hipKneeIndex+(element-1)*EXONET.nParameters+1);
        L0 = p(hipKneeIndex+(element-1)*EXONET.nParameters+2);
        rPos = [r*sind(theta) -r*cosd(theta)]; % R vector
        plot([rPos(1) ankle(1)],[rPos(2) ankle(2)],'Color',ColorsS(2,:),'Linewidth',LWs);
        plot([hip(1) rPos(1)],[hip(2) rPos(2)],'Color',ColorsR(2,:),'Linewidth',LWr);
    end
end

fprintf('\n\n\n\n Done drawing~~\n')

end