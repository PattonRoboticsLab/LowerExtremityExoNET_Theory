% ***********************************************************************
% Draw individual MARIONETs for the leg pose specified by phis
% ***********************************************************************

function h = drawExonetsLeg(p,param,elem,joints,hip,knee,ankle,toe)

%% Setup
fprintf('\n\n\n\n Drawing MARIONETs~~\n')


%% Locations for the cartoon
ColorsS = [0.5 0.7 1; 0.1 1 0.2; 1 0.6 0.3]; % 3 distinct RGB color spaces for the springs
ColorsR = [0 0.2 0.9; 0 0.7 0; 0.9 0.4 0]; % 3 distinct RGB color spaces for the rotators
Colors = [1 0.87843 0.40]; % yellow springs
ColorsC = [0.0235294 0.8392157 0.627451]; % green 1-joint springs
ColorsT = [1 0.572549 0.545098]; % pink 2-joint springs
LWs = 2; % lines width springs
LWr = 4; % lines width rotators

% hip = [0, 0]; % HIP position
% knee = [L(1)*sind(phis(1)), ... % KNEE position
%         -(L(1)*cosd(phis(1)))];
% ankle = [knee(1) + L(2)*sind(phis(1)-phis(2)), ... % ANKLE position
%          knee(2) - L(2)*cosd(phis(1)-phis(2))];
% toe = [ankle(1) + L(3)*sind(phis(3)), ... % TOE position
%        ankle(2) - L(3)*cosd(phis(3))];

% hip =   [0      0];
% knee =  [0     -0.4451];
% ankle = [0.02  -1.03];
% toe =   [0.30367  -1.129];

ankleIndex = 1;
kneeFootIndex = param*elem+1;


%% Loop thorough all MARIONETs
for element = 1:elem
    r = p(ankleIndex+(element-1)*param+0);
    theta = p(ankleIndex+(element-1)*param+1);
    L0 = p(ankleIndex+(element-1)*param+2);
%     ankle = [knee(1) + L(2)*sind(phis(1)-phis(2)), ... % ANKLE position
%              knee(2) - L(2)*cosd(phis(1)-phis(2))];
    rPos = ankle + [r*sind(theta) -r*cosd(theta)]; % R vector
%     toe = [ankle(1) + L(3)*sind(phis(3)), ... % TOE position
%            ankle(2) - L(3)*cosd(phis(3))];
    plot([rPos(1) toe(1)],[rPos(2) toe(2)],'Color',ColorsC,'Linewidth',LWs);
    plot([ankle(1) rPos(1)],[ankle(2) rPos(2)],'Color',ColorsS(1,:),'Linewidth',LWr);
end

if joints == 2
    for element = 1:elem
        r = p(kneeFootIndex+(element-1)*param+0);
        theta = p(kneeFootIndex+(element-1)*param+1);
        L0 = p(kneeFootIndex+(element-1)*param+2);
%         knee = [L(1)*sind(phis(1)), ... % KNEE position
%                 -(L(1)*cosd(phis(1)))];
        rPos = knee + [r*sind(theta) -r*cosd(theta)]; % R vector
%         toe = [ankle(1) + L(3)*sind(phis(3)), ... % TOE position
%                ankle(2) - L(3)*cosd(phis(3))];
        plot([rPos(1) toe(1)],[rPos(2) toe(2)],'Color',ColorsT,'Linewidth',LWs);
        plot([knee(1) rPos(1)],[knee(2) rPos(2)],'Color',ColorsS(3,:),'Linewidth',LWr);
    end
end

fprintf('\n\n\n\n Done drawing~~\n')

end