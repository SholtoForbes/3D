function eventConditions = SFBEvents(primal)

global CONSTANTS

V0 = primal.states(1,1);		Vf = primal.states(1,end);
% vv0 = primal.states(4,1);	
% vh0 = primal.states(5,1);	

xi0 = primal.states(2,1);
phi0 = primal.states(3,1);
gamma0 = primal.states(4,1);
v0 = primal.states(5,1);	
zeta0 = primal.states(6,1);

eventConditions = zeros(7,1); 

%===========================================================
eventConditions(1) = V0;
eventConditions(2) = Vf;
% eventConditions(3) = vv0;
% eventConditions(4) = vh0;

eventConditions(3) = xi0;
eventConditions(4) = phi0;
eventConditions(5) = gamma0;
eventConditions(6) = v0;
eventConditions(7) = zeta0;

