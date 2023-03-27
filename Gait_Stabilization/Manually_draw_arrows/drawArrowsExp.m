% ***************************************************************************
% Draw new Torque Arrows on top of the Gait Torque Field in the Angles Plane
% ***************************************************************************

global PHIs TAUsDESIRED ArrowPHIs ArrowTAUsDESIRED AllPHIs AllTAUsDESIRED

xDist = 3;
yDist = 3;

xMax = max(abs(PHIs(:,1)));
xMin = min(abs(PHIs(:,1)));
yMax = max(abs(PHIs(:,2)));
yMin = min(abs(PHIs(:,2)));

for i = 1:length(PHIs)
    if PHIs(i,1) >= (xMax+xMin)/2
        ArrowPHIs(i,1) = PHIs(i,1) + xDist;
    else
        ArrowPHIs(i,1) = PHIs(i,1) - xDist;
    end
    
    if PHIs(i,2) >= (yMax+yMin)/2
        ArrowPHIs(i,2) = PHIs(i,2) + yDist;
    else
        ArrowPHIs(i,2) = PHIs(i,2) - yDist;
    end
end

ArrowTAUsDESIRED = PHIs - ArrowPHIs;

AllPHIs = [PHIs; ArrowPHIs];
AllTAUsDESIRED = [TAUsDESIRED; ArrowTAUsDESIRED];

