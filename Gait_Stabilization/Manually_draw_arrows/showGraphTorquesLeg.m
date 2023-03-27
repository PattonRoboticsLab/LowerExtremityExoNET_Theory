% ***********************************************************************
% Plot the ExoNET torques superimposed on the desired torques
% ***********************************************************************

function showGraphTorquesLeg(percentageGaitCycle,TAUsDESIRED,TAUs)

figure
subplot(2,1,1)
p1 = plot(percentageGaitCycle,TAUsDESIRED(:,1),'r','LineWidth',2);
hold on
p2 = plot(percentageGaitCycle,TAUs(:,1),'b','LineWidth',2);
xlabel('Gait Cycle [%]'); ylabel({'Hip Moment [Nm]';'extension    flexion'});
p3 = plot(percentageGaitCycle(1),TAUsDESIRED(1,1),'.k'); % HSR
text(percentageGaitCycle(1)+0.5,TAUsDESIRED(1,1)+5,'HSR');
p4 = plot(percentageGaitCycle(63),TAUsDESIRED(63,1),'.k'); % TOR
text(percentageGaitCycle(63),TAUsDESIRED(63,1)+3.5,'TOR');
p5 = plot(percentageGaitCycle(end),TAUsDESIRED(end,1),'.k'); % HSR
text(percentageGaitCycle(end)-5,TAUsDESIRED(end,1)+3,'HSR');
legend([p1 p2],'Desired','ExoNET');
box off

subplot(2,1,2)
p1 = plot(percentageGaitCycle,TAUsDESIRED(:,2),'r','LineWidth',2);
hold on
p2 = plot(percentageGaitCycle,TAUs(:,2),'b','LineWidth',2);
xlabel('Gait Cycle [%]'); ylabel({'Knee Moment [Nm]';'flexion    extension'});
p3 = plot(percentageGaitCycle(1),TAUsDESIRED(1,2),'.k'); % HSR
text(percentageGaitCycle(1)+0.5,TAUsDESIRED(1,2)-1,'HSR');
p4 = plot(percentageGaitCycle(63),TAUsDESIRED(63,2),'.k'); % TOR
text(percentageGaitCycle(63),TAUsDESIRED(63,2)+2,'TOR');
p5 = plot(percentageGaitCycle(end),TAUsDESIRED(end,2),'.k'); % HSR
text(percentageGaitCycle(end)-5,TAUsDESIRED(end,2)+2,'HSR');
legend([p1 p2],'Desired','ExoNET');
box off

end