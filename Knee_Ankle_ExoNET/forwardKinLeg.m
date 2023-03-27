% ***********************************************************************
% Create the different positions of the Body associated to
% the given angles combinations for hip and knee
% ***********************************************************************

function Position = forwardKinLeg(PHIs,BODY)

Position.hip = zeros(size(PHIs(:,1:2))); % HIP position

Position.knee = [BODY.Lengths(1)*sind(PHIs(:,1)), ... % KNEE position
                 -(BODY.Lengths(1)*cosd(PHIs(:,1)))];

Position.ankle = [Position.knee(:,1) + BODY.Lengths(2)*sind(PHIs(:,1)-PHIs(:,2)), ... % ANKLE position
                  Position.knee(:,2) - BODY.Lengths(2)*cosd(PHIs(:,1)-PHIs(:,2))];

Position.foot = [Position.ankle(:,1) + BODY.Lengths(3)*sind(PHIs(:,3)), ... % FOOT position
                 Position.ankle(:,2) - BODY.Lengths(3)*cosd(PHIs(:,3))];

end