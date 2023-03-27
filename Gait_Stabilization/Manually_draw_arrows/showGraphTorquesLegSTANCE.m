% ***********************************************************************
% Plot the ExoNET torques superimposed on the desired torques
% ***********************************************************************

function showGraphTorquesLegSTANCE(percentageGaitCycle,TAUsDESIRED,TAUs)

figure
subplot(2,1,1)
p1 = plot(percentageGaitCycle(1:63),TAUsDESIRED(:,1),'r','LineWidth',2);
hold on
p2 = plot(percentageGaitCycle(1:63),TAUs(:,1),'b','LineWidth',2);
xlabel('Gait Cycle [%]'); ylabel({'Hip Moment [Nm]';'extension    flexion'});
p3 = plot(percentageGaitCycle(1),TAUsDESIRED(1,1),'.k'); % HSR
text(percentageGaitCycle(1)+0.5,TAUsDESIRED(1,1)+7,'HSR');
p4 = plot(percentageGaitCycle(63),TAUsDESIRED(63,1),'.k'); % TOR
text(percentageGaitCycle(63)+0.5,TAUsDESIRED(63,1)+2.5,'TOR');
legend([p1 p2],'Desired','ExoNET','Location','southeast');
box off

subplot(2,1,2)
p1 = plot(percentageGaitCycle(1:63),TAUsDESIRED(:,2),'r','LineWidth',2);
hold on
p2 = plot(percentageGaitCycle(1:63),TAUs(:,2),'b','LineWidth',2);
xlabel('Gait Cycle [%]'); ylabel({'Knee Moment [Nm]';'flexion    extension'});
p3 = plot(percentageGaitCycle(1),TAUsDESIRED(1,2),'.k'); % HSR
text(percentageGaitCycle(1)+1,TAUsDESIRED(1,2),'HSR');
p4 = plot(percentageGaitCycle(63),TAUsDESIRED(63,2),'.k'); % TOR
text(percentageGaitCycle(63)+0.5,TAUsDESIRED(63,2)+1.5,'TOR');
legend([p1 p2],'Desired','ExoNET');
box off

end