% ***********************************************************************
% Plot the ExoNET torques superimposed on the desired torques
% ***********************************************************************

function showGraphTorquesLegSWING(percentageGaitCycle,TAUsDESIRED,TAUs)

figure
subplot(2,1,1)
p1 = plot(percentageGaitCycle(64:end),TAUsDESIRED(:,1),'r','LineWidth',2);
hold on
p2 = plot(percentageGaitCycle(64:end),TAUs(:,1),'b','LineWidth',2);
xlabel('Gait Cycle [%]'); ylabel({'Hip Moment [Nm]';'extension    flexion'});
p4 = plot(percentageGaitCycle(64),TAUsDESIRED(1,1),'.k'); % TOR
text(percentageGaitCycle(64)-2,TAUsDESIRED(1,1)+0.5,'TOR');
p5 = plot(percentageGaitCycle(end),TAUsDESIRED(end,1),'.k'); % HSR
text(percentageGaitCycle(end)-1.5,TAUsDESIRED(end,1)+1.3,'HSR');
legend([p1 p2],'Desired','ExoNET');
box off

subplot(2,1,2)
p1 = plot(percentageGaitCycle(64:end),TAUsDESIRED(:,2),'r','LineWidth',2);
hold on
p2 = plot(percentageGaitCycle(64:end),TAUs(:,2),'b','LineWidth',2);
xlabel('Gait Cycle [%]'); ylabel({'Knee Moment [Nm]';'flexion    extension'});
p4 = plot(percentageGaitCycle(64),TAUsDESIRED(1,2),'.k'); % TOR
text(percentageGaitCycle(64)-2,TAUsDESIRED(1,2),'TOR');
p5 = plot(percentageGaitCycle(end),TAUsDESIRED(end,2),'.k'); % HSR
text(percentageGaitCycle(end)-1.5,TAUsDESIRED(end,2)+1,'HSR');
legend([p1 p2],'Desired','ExoNET');
box off

end