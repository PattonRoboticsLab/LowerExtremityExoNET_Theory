% ***************************************************************************
% Draw new Torque Arrows on top of the Gait Torque Field in the Angles Plane
% ***************************************************************************

function Position = drawArrows

global BODY PHIs TAUsDESIRED

GaitPHIs = PHIs;
GaitTAUsDESIRED = TAUsDESIRED;

% put_figure(1, 0.02, 0.07, 0.95, 0.82)
% plotVectFieldLeg(PHIs,TAUsDESIRED,'r'); % to plot the desired torque field in red
% axis([-20 50 -10 100])
% hold on
% 
% x = 0;
% n = 1;
% while size(x,1)<3
%     CreateStruct.Interpreter = 'tex';
%     CreateStruct.WindowStyle = 'modal';
%     msgbox({'Click on the plot for selecting starting and ending point of the arrow and then press ENTER';...
%             'When finished, click on the plot 3 times and then press ENTER'},CreateStruct)
%     [x,y] = ginput;
%     
%     if size(x,1)<3
%         Arrows(n:n+1,:) = [x y];
%         simpleArrow(Arrows(n,:),Arrows(n+1,:),'b',1.75);
%         plot(Arrows(n,1),Arrows(n,2),'.','Color','b') % dots
%         hold on
%     end
%     
%     n = n+2;
% end

load('Arrows.mat')
scaleTau = 0.2; % graphic scale factor for torque pseudo-vectors
ArrowsPHIs = Arrows(1:2:length(Arrows),:); % hip and knee angles for the new torque arrows
k = 1;
for j = 1:2:length(Arrows)
    ArrowsTAUsDESIRED(k,:) = (Arrows(j+1,:) - Arrows(j,:))/scaleTau;
    k = k+1;
end

PHIs = [GaitPHIs; ArrowsPHIs];
TAUsDESIRED = [GaitTAUsDESIRED; ArrowsTAUsDESIRED];
Position = forwardKinLeg(PHIs,BODY); % positions associated to the angles

end