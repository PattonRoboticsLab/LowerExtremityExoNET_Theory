% ***********************************************************************
% Calculate the torques and the tensions created by the ExoNET
% ***********************************************************************

function TAUs = exoNetTorquesTensionsLeg(p,PHIs,plotIt)

%% Setup
global EXONET BODY TENSION1j TENSION2j
if ~exist('plotIt','var'); plotIt = 0; end   % if plotIt argument not passed

ColorsS = [0.5 0.7 1; 0.1 1 0.2; 1 0.6 0.3]; % 3 distinct RGB color spaces for the springs
Colors = [1 0.87843 0.40]; % yellow springs
ColorsC = [0.0235294 0.8392157 0.627451]; % green 1-joint springs
ColorsT = [1 0.572549 0.545098]; % pink 2-joint springs

TAUs = zeros(size(PHIs,1),2); % initialization

ankleIndex = 1;
kneeToeIndex = EXONET.nParameters*EXONET.nElements+1;

if plotIt; cf = gcf(); figure; end           % add cf and create another figure


%% Find torques
for i = 1:size(PHIs,1)

if EXONET.nJoints == 11
    tau = 0;
    for element = 1:EXONET.nElements
        r = p(ankleIndex+(element-1)*EXONET.nParameters+0);
        theta = p(ankleIndex+(element-1)*EXONET.nParameters+1);
        L0 = p(ankleIndex+(element-1)*EXONET.nParameters+2);
        [new_tau,EXONET.T(i,1,element),EXONET.Tdist(i,1,element)] = tauMarionetLeg(PHIs(i,3),BODY.Lengths(3),r,theta,L0);
        EXONET.tau(i,1,element) = new_tau;
        if plotIt
            %stretch_max = max(EXONET.Tdist(i,1,element));       % Tension Springs
            stretch_min = min(EXONET.Tdist(i,1,element));       % Compression Springs
            %x = 0:0.001:stretch_max;                            % Tension Springs
            x = stretch_min:0.001:EXONET.pConstraint(3,2)+0.1;  % Compression Springs
            y = TENSION1j(L0,x);
            plot(x,y,'Color',ColorsC,'LineWidth',2.5)
            hold on
            yline(0)
            plot(EXONET.Tdist(i,1,element),EXONET.T(i,1,element),'o','MarkerSize',7,'MarkerFaceColor',ColorsC,'MarkerEdgeColor','w')
            xlabel('L [m]')
            ylabel('Tension [N]')
            title('Tension exerted by each elastic element with respect to its length')
            box off
        end
        tau = tau + new_tau; % + element's torque
    end
    TAUs(i,1) = tau; % torque created by the ankle MARIONET
end


if EXONET.nJoints == 22
    taus = [0 0];
    for element = 1:EXONET.nElements
        r = p(ankleIndex+(element-1)*EXONET.nParameters+0);
        theta = p(ankleIndex+(element-1)*EXONET.nParameters+1);
        L0 = p(ankleIndex+(element-1)*EXONET.nParameters+2);
        [new_tau,EXONET.T(i,1,element),EXONET.Tdist(i,1,element)] = tau2jMarionetLeg(PHIs(i,:),BODY.Lengths,r,theta,L0);
        EXONET.tau(i,1,element) = new_tau(2);
        if plotIt
            %stretch_max = max(EXONET.Tdist(i,1,element));       % Tension Springs
            stretch_min = min(EXONET.Tdist(i,1,element));       % Compression Springs
            %x = 0:0.001:stretch_max;                            % Tension Springs
            x = stretch_min:0.001:EXONET.pConstraint(3,2)+0.1;  % Compression Springs
            y = TENSION2j(L0,x);
            plot(x,y,'Color',ColorsT,'LineWidth',2.5)
            hold on
            yline(0)
            plot(EXONET.Tdist(i,1,element),EXONET.T(i,1,element),'o','MarkerSize',7,'MarkerFaceColor',ColorsT,'MarkerEdgeColor','w')
            xlabel('L [m]')
            ylabel('Tension [N]')
            title('Tension exerted by each elastic element with respect to its length')
            box off
        end
        taus = taus + new_tau; % + element's torques
    end
    TAUs(i,1) = TAUs(i,1) + taus(2); % torque created by the knee-toe MARIONET on the ankle
    TAUs(i,2) = taus(1); % torque created by the knee-toe MARIONET on the knee
end


if EXONET.nJoints == 2
    tau = 0;
    for element = 1:EXONET.nElements
        r = p(ankleIndex+(element-1)*EXONET.nParameters+0);
        theta = p(ankleIndex+(element-1)*EXONET.nParameters+1);
        L0 = p(ankleIndex+(element-1)*EXONET.nParameters+2);
        [new_tau,EXONET.T(i,1,element),EXONET.Tdist(i,1,element)] = tauMarionetLeg(PHIs(i,3),BODY.Lengths(3),r,theta,L0);
        EXONET.tau(i,1,element) = new_tau;
        if plotIt
            %stretch_max = max(EXONET.Tdist(i,1,element));       % Tension Springs
            stretch_min = min(EXONET.Tdist(i,1,element));       % Compression Springs
            %x = 0:0.001:stretch_max;                            % Tension Springs
            x = stretch_min:0.001:EXONET.pConstraint(3,2)+0.1;  % Compression Springs
            y = TENSION1j(L0,x);
            plot(x,y,'Color',ColorsC,'LineWidth',2.5)
            hold on
            yline(0)
            plot(EXONET.Tdist(i,1,element),EXONET.T(i,1,element),'o','MarkerSize',7,'MarkerFaceColor',ColorsC,'MarkerEdgeColor','w')
            xlabel('L [m]')
            ylabel('Tension [N]')
            title('Tension exerted by each elastic element with respect to its length')
        end
        tau = tau + new_tau; % + element's torque
    end
    TAUs(i,1) = tau; % torque created by the ankle MARIONET
    
    taus = [0 0];
    for element = 1:EXONET.nElements
        r = p(kneeToeIndex+(element-1)*EXONET.nParameters+0);
        theta = p(kneeToeIndex+(element-1)*EXONET.nParameters+1);
        L0 = p(kneeToeIndex+(element-1)*EXONET.nParameters+2);
        [new_tau,EXONET.T(i,2,element),EXONET.Tdist(i,2,element)] = tau2jMarionetLeg(PHIs(i,:),BODY.Lengths,r,theta,L0);
        EXONET.tau(i,2,element) = new_tau(2);
        if plotIt
            %stretch_max = max(EXONET.Tdist(i,2,element));       % Tension Springs
            stretch_min = min(EXONET.Tdist(i,2,element));       % Compression Springs
            %x = 0:0.001:stretch_max;                            % Tension Springs
            x = stretch_min:0.001:EXONET.pConstraint(3,2)+0.1;  % Compression Springs
            y = TENSION2j(L0,x);
            plot(x,y,'Color',ColorsT,'LineWidth',2.5)
            hold on
            yline(0)
            plot(EXONET.Tdist(i,2,element),EXONET.T(i,2,element),'o','MarkerSize',7,'MarkerFaceColor',ColorsT,'MarkerEdgeColor','w')
            box off
        end
        taus = taus + new_tau; % + element's torques
    end
    TAUs(i,1) = TAUs(i,1) + taus(2); % torque created by the knee-toe MARIONET on the ankle
    TAUs(i,2) = taus(1); % torque created by the knee-toe MARIONET on the knee
end

if plotIt; figure(cf); end

end

end