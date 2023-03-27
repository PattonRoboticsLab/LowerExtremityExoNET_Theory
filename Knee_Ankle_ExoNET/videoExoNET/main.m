close all; clear; clc

% Rotation Matrix
% R = [cos(theta) -sin(theta)
%      sin(theta) cos(theta)]

bodyColor = [0.8, 0.7, 0.6]; % RGB color space for shaded body parts
ColorsS = [0.5 0.7 1; 0.1 1 0.2; 1 0.6 0.3]; % 3 distinct RGB color spaces for the springs

load('torso.mat')
load('thigh.mat')
load('shank.mat')
load('foot.mat')

beatrice_gait_hip_knee_ankle = xlsread('beatrice_gait_hip_knee_ankle.xlsx');


%%
nParameters = 3;
nElements = 2;
p = [0.0982896895148031,-150.354968168607,0.0218641650894900,-0.259512153365745,-1170.91335973169,0.160387508106843,-0.442574215244968,17488.6059241523,0.678148901420898,-0.335173388656248,1245.08278511284,1.00000000175530];

anglesT = beatrice_gait_hip_knee_ankle(:,2); %[-30:1:30 29:-1:-29 -30:1:30];
anglesS = beatrice_gait_hip_knee_ankle(:,3).*(-1);
anglesF = (beatrice_gait_hip_knee_ankle(:,3)+beatrice_gait_hip_knee_ankle(:,4)).*(-1);


put_figure(1, 0, 0, 1, 1);
for i = 1:length(anglesT)
clf;

% x = -0.3552
% y = -0.1232
% x0 = 0.0004815
% y0 = -0.4671
% distX = x - x0
% distY = y - y0
% x = x - distX   % x coordinate becomes equal to x0
% y = y - distY   % y coordinate becomes equal to y0


%
thetaT = anglesT(i);
Rt = [cosd(thetaT) -sind(thetaT); ...
      sind(thetaT) cosd(thetaT)];

hip =   [0      0];  % HIP

thighR = (Rt*thigh')';  % THIGH


%
thetaS = anglesS(i);
Rs = [cosd(thetaS) -sind(thetaS); ...
      sind(thetaS) cosd(thetaS)];

knee =  [0     -0.4451];

kneeR = (Rt*knee')';  % KNEE

knee2R = (Rs*knee')';

dist = knee2R - kneeR;

shankR = (Rs*shank')';

shankR = shankR - dist;  % SHANK


%
thetaF = anglesF(i);
Rf = [cosd(thetaF) -sind(thetaF); ...
      sind(thetaF) cosd(thetaF)];

ankle = [0.02  -1.03];

ankleR = (Rs*ankle')';

ankleR = ankleR - dist;  % ANKLE

ankle2R = (Rf*ankle')';

dist2 = ankle2R - ankleR;

footR = (Rf*foot')';

footR = footR - dist2;  % FOOT


toe =   [0.30367  -1.129];

toeR = (Rf*toe')';

toeR = toeR - dist2;  % TOE


% kneeBand(1,:) = [-0.117279:0.001:0.082721];
% kneeBand(2,:) = knee(2)*ones(length(kneeBand(1,:)),1); kneeBandR = (Rt*kneeBand)';
% ankleBand(1,:) = [-0.062005286:0.001:0.10141705];
% ankleBand(2,:) = ankle(2)*ones(length(ankleBand(1,:)),1); ankleBandR = (Rt*ankleBand)';


plot(torso(:,1),torso(:,2),'.','Color',bodyColor)
hold on
plot(thighR(:,1),thighR(:,2),'.','Color',ColorsS(3,:))
plot(shankR(:,1),shankR(:,2),'.','Color',ColorsS(1,:))
plot(footR(:,1),footR(:,2),'.','Color',bodyColor)
% plot(kneeBandR(1,:),kneeBandR(2,:),'Color',ColorsS(3,:),'linewidth',6)
% plot(ankleBandR(1,:),ankleBandR(2,:),'Color',ColorsS(1,:),'linewidth',6)
ylim([-1.2 1.2])
axis equal
axis off
%scatter(hip(1),hip(2),30,'k','filled') % hip
scatter(kneeR(1),kneeR(2),30,'k','filled') % knee
scatter(ankleR(1),ankleR(2),30,'k','filled') % ankle
scatter(toeR(1),toeR(2),30,'k','filled') % toe

drawExonetsLeg(p,nParameters,nElements,2,hip,kneeR,ankleR,toeR)

fig(i) = getframe(gcf);

pause(0.000000001);

end

writerObj = VideoWriter('VideoExoNET.avi'); % create video writer object
writerObj.FrameRate = 15; % set the frame rate
open(writerObj); % open the video writer
for i = 1:length(fig) % write the frames to the video
    frame = fig(i); % convert the image to a frame
    writeVideo(writerObj,frame);
end
close(writerObj); % close the writer object

