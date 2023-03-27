% ***************************************************************************
% Draw new Torque Arrows on top of the Gait Torque Field in the Angles Plane
% ***************************************************************************

global PHIs TAUsDESIRED ArrowPHIs ArrowTAUsDESIRED AllPHIs AllTAUsDESIRED

a = 10;
b = 45;
c = 77;
d = 101;

outer = zeros(length(PHIs),2);
inner = zeros(length(PHIs),2);


% Draw outer path
xDist = linspace(-3,0,a)';
outer(1:a,1) = PHIs(1:a,1) + xDist;
outer(1:a,2) = PHIs(1:a,2) - 2;

xDist = [linspace(0,2,15)'; 2*ones(b-a-25,1); linspace(2,0,10)'];
outer(a+1:b,1) = PHIs(a+1:b,1) + xDist;
outer(a+1:b,2) = PHIs(a+1:b,2) - 2;

xDist = [linspace(0,-4,15)'; -4*ones(c-b-25,1); linspace(-4,0,10)'];
outer(b+1:c,1) = PHIs(b+1:c,1) + xDist;
yDist = linspace(-2,2,c-b)';
outer(b+1:c,2) = PHIs(b+1:c,2) + yDist;

xDist = linspace(0,4,d-c)';
outer(c+1:d,1) = PHIs(c+1:d,1) + xDist;
yDist = linspace(2,-2,d-c)';
outer(c+1:d,2) = PHIs(c+1:d,2) + yDist;


% Draw inner path
xDist = linspace(1,0,a)';
inner(1:a,1) = PHIs(1:a,1) + xDist;
inner(1:a,2) = PHIs(1:a,2) + 2;

xDist = [linspace(0,-2,10)'; -2*ones(b-a-20,1); linspace(-2,0,10)'];
inner(a+1:b,1) = PHIs(a+1:b,1) + xDist;
inner(a+1:b,2) = PHIs(a+1:b,2) + 2;

xDist = [linspace(0,4,15)'; 4*ones(c-b-25,1); linspace(4,0,10)'];
inner(b+1:c,1) = PHIs(b+1:c,1) + xDist;
yDist = linspace(2,-2,c-b)';
inner(b+1:c,2) = PHIs(b+1:c,2) + yDist;

xDist = linspace(0,-4,d-c)';
inner(c+1:d,1) = PHIs(c+1:d,1) + xDist;
yDist = linspace(-2,2,d-c)';
inner(c+1:d,2) = PHIs(c+1:d,2) + yDist;


% Angle position of the Arrow Torques
ArrowPHIs = [outer; inner];

scaleTau = 0.2;

% Arrow Torques
ArrowTAUsDESIRED = [PHIs - ArrowPHIs(1:length(PHIs),:); PHIs - ArrowPHIs(length(PHIs)+1:end,:)]/scaleTau;


AllPHIs = [PHIs; ArrowPHIs];
AllTAUsDESIRED = [TAUsDESIRED; ArrowTAUsDESIRED];

