function xdot = SFBDynamics(primal)

global CONSTANTS
global scale
global Atmosphere
global Coeff

A = 62.77; % reference area (m^2)

rEarth = 6.3674447e6;  %(m) radius of earth

r = primal.states(1,:)/scale.V + rEarth;
xi = primal.states(2,:)/scale.LATLONG;
phi = primal.states(3,:)/scale.LATLONG;
gamma = primal.states(4,:)/scale.ang;
v = primal.states(5,:)/scale.v;
zeta = primal.states(6,:)/scale.ang;
alpha = primal.states(7,:)/scale.a;
chi = primal.states(8,:)/scale.ang;

%======================================================================
% Equations of Motion:
%======================================================================

rad2deg(alpha);
C_L = interp1(Coeff(:,1),Coeff(:,2),rad2deg(alpha));
C_D = interp1(Coeff(:,1),Coeff(:,3),rad2deg(alpha));
rho = interp1(Atmosphere(:,1),Atmosphere(:,4),r - rEarth);

L = 0.5.*C_L.*rho.*v.^2.*A;
m = 9000;
D = 0.5.*C_D.*rho.*v.^2.*A;

[rdot,xidot,phidot,gammadot,vdot,zetadot] = RotCoords(r,xi,phi,gamma,v,zeta,L,D,m,alpha,chi);

alphadot = primal.controls(1,:)/scale.a;
chidot = primal.controls(2,:)/scale.LATLONG;
%=======================================================================

xdot = [rdot*scale.V;xidot*scale.LATLONG;phidot*scale.LATLONG;gammadot*scale.ang;vdot*scale.v;zetadot*scale.ang; alphadot*scale.a; chidot*scale.LATLONG]/scale.t;
