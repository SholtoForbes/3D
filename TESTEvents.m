function eventConditions = TESTEvents(primal)

global CONSTANTS

V0 = primal.states(1,1);		Vf = primal.states(1,end);
% vv0 = primal.states(4,1);	
% vh0 = primal.states(5,1);	

% xi0 = primal.states(2,1);
% xif = primal.states(2,end);
% phi0 = primal.states(3,1);
% phif = primal.states(3,end);
% gamma0 = primal.states(4,1);
% v0 = primal.states(5,1);	
% zeta0 = primal.states(6,1);
% zetaf = primal.states(6,end);
% gammaf = primal.states(4,end);
% m0 = primal.states(9,1);
% mf = primal.states(9,end);


gamma0 = primal.states(2,1);
v0 = primal.states(3,1);	
m0 = primal.states(5,1);
mf = primal.states(5,end);


% eventConditions = zeros(8,1); 
% 
% %===========================================================
% eventConditions(1) = V0;
% eventConditions(2) = xi0;
% eventConditions(3) = phi0;
% eventConditions(4) = gamma0;
% eventConditions(5) = v0;
% eventConditions(6) = zeta0;
% eventConditions(7) = m0;
% eventConditions(8) = mf;

eventConditions = zeros(5,1); 

%===========================================================
eventConditions(1) = V0;
eventConditions(2) = gamma0;
eventConditions(3) = v0;
eventConditions(4) = m0;
eventConditions(5) = mf;





