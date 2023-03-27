% ***********************************************************************
% Plot the torque vector field
% ***********************************************************************

function plotVectFieldLeg(phis,taus,color)

scaleTau = 0.2; % graphic scale factor for torque pseudo-vectors

%% Plot the Torque Field in the phis Domain (this cheating -- not true vectors)
subplot(1,2,2)
for i = 1:length(phis)
    simpleArrow(phis(i,:),phis(i,:)+scaleTau*taus(i,:),color,1.75);
    plot(phis(i,1),phis(i,2),'.','Color',color) % dots
    hold on
end
xlabel('Hip Angle [deg]','FontSize',14);
ylabel('Knee Angle [deg]','FontSize',14);
title('Torques at angle positions','FontSize',14);
simpleArrow([-2.8, 70+1],[-3, 70+1]+[scaleTau*10, 0],'k',1.75); % for the legend
text(-4,71.5+1,'10 Nm'); % for the legend
% plot(phis(1,1),phis(1,2),'.k'); plot(phis(70,1),phis(70,2),'.k'); % TOR
% text(phis(1,1)-1.3,phis(1,2)+2.1,'TOR');
% plot(phis(28,1),phis(28,2),'.k'); plot(phis(97,1),phis(97,2),'.k'); % HCR
% text(phis(28,1)-6,phis(28,2),'HCR');
box off
axis image

end