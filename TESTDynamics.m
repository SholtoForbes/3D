function xdot = TESTDynamics(primal)
% primal.states
global CONSTANTS
global scale
global Atmosphere
global Coeff
global ThrustF_spline
global FuelF_spline
% global CL_spline 
% global CD_spline
global Mgrid_com
global alphagrid_com
global CLgrid_com
global CDgrid_com
global Mgrid_eng
global alphagrid_eng
global Thrustgrid_com
global Fuelgrid_com

A = 62.77; % reference area (m^2)

rEarth = 6.3674447e6;  %(m) radius of earth

% r = primal.states(1,:)/scale.V + rEarth;
% xi = primal.states(2,:)/scale.LATLONG;
% phi = primal.states(3,:)/scale.LATLONG;
% gamma = primal.states(4,:)/scale.ang;
% v = primal.states(5,:)/scale.v;
% zeta = primal.states(6,:)/scale.ang;
% alpha = primal.states(7,:)/scale.a;
% chi = primal.states(8,:)/scale.ang;
% mfuel = primal.states(9,:)/scale.m;

r = primal.states(1,:)/scale.V + rEarth;
xi = 0;
phi = 0;
gamma = primal.states(2,:)/scale.ang;
v = primal.states(3,:)/scale.v;
zeta = 0;
alpha = primal.states(4,:)/scale.a;
chi = 0;
mfuel = primal.states(5,:)/scale.m;
%======================================================================
% Equations of Motion:
%======================================================================
c = spline( Atmosphere(:,1),  Atmosphere(:,5), r - rEarth);
M = v./c;

rad2deg(alpha);
% C_L = interp1(Coeff(:,1),Coeff(:,2),rad2deg(alpha));
% C_D = interp1(Coeff(:,1),Coeff(:,3),rad2deg(alpha));
% C_L = CL_spline(M,alpha);
% C_D = CD_spline(M,alpha);

C_L = interp2(Mgrid_com,alphagrid_com,CLgrid_com,M,rad2deg(alpha),'spline');
C_D = interp2(Mgrid_com,alphagrid_com,CDgrid_com,M,rad2deg(alpha),'spline');

rho = interp1(Atmosphere(:,1),Atmosphere(:,4),r - rEarth);

L = 0.5.*C_L.*rho.*v.^2.*A;
m = 9000-mfuel;
D = 0.5.*C_D.*rho.*v.^2.*A;

global q
q = 0.5 * rho .* (v .^2);

Efficiency = zeros(1,length(q));
for i = 1:length(q)
    if q(i) < 50000
    Efficiency(i) = rho(i)/(50000*2/v(i)^2); % dont change this
    else
    Efficiency(i) = 1; % for 50kPa
    end
end
% Efficiency 
% Efficiency = rho./(50000*2./v.^2);

% Fueldt = FuelF_spline(M,alpha).*Efficiency;

Fueldt = interp2(Mgrid_eng,alphagrid_eng,Fuelgrid_com,M,rad2deg(alpha),'spline').*Efficiency;

% Isp = ThrustF_spline(M,alpha)./FuelF_spline(M,alpha);

% T = Isp.*Fueldt;

T = interp2(Mgrid_eng,alphagrid_eng,Thrustgrid_com,M,rad2deg(alpha),'spline').*Efficiency;

[rdot,xidot,phidot,gammadot,vdot,zetadot] = RotCoords(r,xi,phi,gamma,v,zeta,L,D,m,alpha,chi,T);

alphadot = primal.controls(1,:)/scale.a;
% chidot = primal.controls(2,:)/scale.ang;
%=======================================================================

% xdot = [rdot*scale.V;xidot*scale.LATLONG;phidot*scale.LATLONG;gammadot*scale.ang;vdot*scale.v;zetadot*scale.ang; alphadot*scale.a; chidot*scale.ang; -Fueldt*scale.m]/scale.t;
xdot = [rdot*scale.V;gammadot*scale.ang;vdot*scale.v;alphadot*scale.a; -Fueldt*scale.m]/scale.t;
