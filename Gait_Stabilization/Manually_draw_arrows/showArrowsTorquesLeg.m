% ***********************************************************************
% Plot the ExoNET torques superimposed on the desired torques
% ***********************************************************************

function showArrowsTorquesLeg(PHIs,TAUsDESIRED,TAUs)

figure
subplot(2,1,1)
p1 = plot(PHIs(:,1),TAUsDESIRED(:,1),'r','LineWidth',2);
hold on
p2 = plot(PHIs(:,1),TAUs(:,1),'b','LineWidth',2);
xlabel('Hip Angle [deg]'); ylabel({'Hip Moment [Nm]';'extension    flexion'});
legend([p1 p2],'Desired','ExoNET');
box off

subplot(2,1,2)
p1 = plot(PHIs(:,2),TAUsDESIRED(:,2),'r','LineWidth',2);
hold on
p2 = plot(PHIs(:,2),TAUs(:,2),'b','LineWidth',2);
xlabel('Knee Angle [deg]'); ylabel({'Knee Moment [Nm]';'flexion    extension'});
legend([p1 p2],'Desired','ExoNET');
box off

end