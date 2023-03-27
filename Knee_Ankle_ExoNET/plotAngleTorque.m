% ***********************************************************************
% Plot the ExoNET torques superimposed on the desired torques
% ***********************************************************************

function plotAngleTorque(TAUsDESIRED,TAUs,PHIs,exOn)

global EXONET

ColorsS = [0.5 0.7 1; 0.1 1 0.2; 1 0.6 0.3]; % 3 distinct RGB color spaces for the springs
Colors = [1 0.87843 0.40]; % yellow springs
ColorsC = [0.0235294 0.8392157 0.627451]; % green 1-joint springs
ColorsT = [1 0.572549 0.545098]; % pink 2-joint springs

subplot(1,2,2)
p1 = plot(PHIs(:,3),TAUsDESIRED(:,1),'^','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','r');
hold on
p1 = plot(PHIs(:,3),TAUsDESIRED(:,1),'r','LineWidth',2);
p2 = plot(PHIs(:,3),TAUs(:,1),'^','MarkerSize',5,'MarkerFaceColor','b','MarkerEdgeColor','b');
p2 = plot(PHIs(:,3),TAUs(:,1),'b','LineWidth',2);
xlabel({'Ankle Angle [deg]';'plantarflexion    dorsiflexion'}); ylabel({'Ankle Torque [Nm]';'plantarflexion    dorsiflexion'});
p4 = plot(PHIs(end,3),TAUsDESIRED(end,1),'.k'); % TOR
text(PHIs(end,3)+0.2,TAUsDESIRED(end,1)+0.6,'TOR');
xlim([min(PHIs(:,3)) max(PHIs(:,3))])

if exist('exOn','var')
for element = 1:EXONET.nElements

if EXONET.nJoints == 11
p4 = plot(PHIs(:,3),EXONET.tau(:,1,element),'--','Color',ColorsC,'LineWidth',1);
p6 = plot(PHIs(:,3),TAUs(:,1),'b','LineWidth',2);
legend([p1 p2 p4],'Desired','ExoNET','1-joint element','Location','Southeast');
end

if EXONET.nJoints == 22
p5 = plot(PHIs(:,3),EXONET.tau(:,1,element),'--','Color',ColorsT,'LineWidth',1);
p6 = plot(PHIs(:,3),TAUs(:,1),'b','LineWidth',2);
legend([p1 p2 p5],'Desired','ExoNET','2-joint element','Location','Southeast');
end

if EXONET.nJoints == 2
p4 = plot(PHIs(:,3),EXONET.tau(:,1,element),'--','Color',ColorsC,'LineWidth',1);
p5 = plot(PHIs(:,3),EXONET.tau(:,2,element),'--','Color',ColorsT,'LineWidth',1);
p6 = plot(PHIs(:,3),TAUs(:,1),'b','LineWidth',2);
legend([p1 p2 p4 p5],'Desired','ExoNET','1-joint element','2-joint element','Location','Southeast');
end
end

box off
title('Gait Torques Field for Late Stance')

end

end