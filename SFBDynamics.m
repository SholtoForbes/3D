function xdot = SFBDynamics(primal)

global CONSTANTS
global scale

global Coeff
% V = primal.states(1,:);		
% LONG = primal.states(2,:);	
% LAT = primal.states(3,:);	
% vv = primal.states(4,:);		
% vh = primal.states(5,:);	
% theta = primal.states(6,:);	
% phi = primal.states(7,:);	

rEarth = 6.3674447e6;  %(m) radius of earth

r = primal.states(1,:)/scale.V + rEarth;
xi = primal.states(2,:);
phi = primal.states(3,:);
gamma = primal.states(4,:);
v = primal.states(5,:)/scale.v;
zeta = primal.states(6,:);
alpha = primal.states(7,:)/scale.a;
eps = primal.states(8,:);

%======================================================================
% Equations of Motion:
%======================================================================
% D = 0;
% 
% L = 5;
% 
% Vdot = vv;
% LONGdot = vh .* cos(phi);
% LATdot = vh .* sin(phi);
% vvdot = - CONSTANTS.g + L * cos(theta) - D .* sin(theta);
% vhdot = -L * sin(theta) - D .* cos(theta);
% thetadot = primal.controls(1,:);
% phidot = primal.controls(2,:);

C_L = interp1(Coeff(:,1),Coeff(:,2),alpha); 

L = 140;
D = 0;
m = 100;

[rdot,xidot,phidot,gammadot,vdot,zetadot] = RotCoords(r,xi,phi,gamma,v,zeta,L,D,m,alpha,eps);

alphadot = primal.controls(1,:)/scale.a;
epsdot = primal.controls(2,:);
%=======================================================================
% xdot = [Vdot; LONGdot; LATdot; vvdot; vhdot; thetadot; phidot];

xdot = [rdot*scale.V;xidot;phidot;gammadot;vdot*scale.v;zetadot; alphadot*scale.a; epsdot];
