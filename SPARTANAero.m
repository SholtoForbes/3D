% Defines the aerodynamics of the SPARTAN over a range of Mach no.s
% Created by Sholto Forbes-Spyratos 
% Uses equations defined in the Aerodynamics section of Aircraft Design: A Conceptual Approach by
% Raymer

% M = 2
% alpha = 0
% v = 2*300
% rho = 0.412707
% mu = 0.0000146884

function CL = SPARTANAero(M,alpha,v,rho,mu)

geom.b = 4.45*2; % Wingspan (m)
geom.c = 9.791;  % Root Chord (m)
geom.d = 1.0499*2; % Fuselage Diameter (m)

geom.S_ref = 0.5*4.45*12.8159; % Wing Reference Area (m^2)
geom.A = geom.b^2/geom.S_ref; % Aspect Ratio
geom.S_exposed = 0.5*(4.45 - 1.0499)*9.7910; % Wing Reference Area (m^2)
geom.Lambda = deg2rad(19.1505); % Wing Sweep at Chord Location (rad)
geom.L_tot = 22.94; % Total Length (m)

if M < 0.8
    CL = SubSonic(M,alpha,geom)
elseif (0.8 <= M) && (M <= 1.2)

elseif (1.2 < M) && (M < 3)
    CL = SuperSonic(M,alpha)    
elseif M >= 3
    CL = SuperSonic(M,alpha)  
end

l_fuselage = geom.L_tot;
l_wing = geom.c/2; % Mean Chord (m)

R_fuselage  = rho*v*l_fuselage/mu % Reynolds no. Fuselage
R_wing  = rho*v*l_wing/mu % Reynolds no. Wings
% R_tail  = rho*v*l_tail/mu; % Reynolds no. Tails

Cf_fuselage = 0.455 / ( log10(R_fuselage)^2.58 * (1 + 0.144*M^2)^0.65) % Fiction Coefficient Fuselage
Cf_wing = 0.455 / ( log10(R_wing)^2.58 * (1 + 0.144*M^2)^0.65) % Fiction Coefficient Fuselage

end



function CL = SuperSonic(M,alpha)
beta = sqrt(M^2 - 1);
CL_alpha = 4/beta; % Lift Coefficient per Unit Angle of Attack (Radians)
CL = CL_alpha * alpha;
end
    

function CL = SubSonic(M,alpha,geom)
A = geom.A; % Aspect Ratio
b = geom.b; % Wingspan (m)
c = geom.c; % Chord length (m)
d = geom.d; % Fuselage Diameter (m)
S_ref = geom.S_ref; % Wing Reference Area (m^2)
S_exposed = geom.S_exposed; % Wing Reference Area (m^2)
Lambda = geom.Lambda; % Wing Sweep at Chord Location (rad)

cl_alpha = 2*pi;
Cl_alpha = cl_alpha*(0.5*c*(b-d));

beta = sqrt(M^2 - 1);
F = 1.07 * (1 + d/b)^2;
eta = Cl_alpha/(2*pi/beta);

CL_alpha = 2*pi*A / (2 + sqrt(4 + A^2 * beta^2 / eta^2 * (1 + tan(Lambda)^2 / beta^2))) * S_exposed / S_ref * F
 
CL = CL_alpha * alpha;
end