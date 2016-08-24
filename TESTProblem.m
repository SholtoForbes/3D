%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;		
clc;
%==============================================================
global CONSTANTS
global q
q = 0;

global Coeff
Coeff = dlmread('Coefficients.txt');
global Atmosphere
Atmosphere = dlmread('atmosphere.txt');

communicator = importdata('communicatornew.txt');

% global CL_spline 
CL_spline = scatteredInterpolant(communicator(:,1),communicator(:,2),communicator(:,3),'natural');
% global CD_spline
CD_spline = scatteredInterpolant(communicator(:,1),communicator(:,2),communicator(:,4),'natural');

global Mgrid_com
global alphagrid_com
global CLgrid_com
global CDgrid_com
[Mgrid_com,alphagrid_com] =  meshgrid(unique(sort(communicator(:,1))),unique(sort(communicator(:,2))));
CLgrid_com = CL_spline(Mgrid_com,alphagrid_com);
CDgrid_com = CD_spline(Mgrid_com,alphagrid_com);


enginedata = dlmread('engineoutput_matrix');


ThrustF_spline= scatteredInterpolant(enginedata(:,1),enginedata(:,2),enginedata(:,3)); %interpolator for engine data (also able to extrapolate badly)
FuelF_spline= scatteredInterpolant(enginedata(:,1),enginedata(:,2),enginedata(:,4)); %interpolator for engine data

global Mgrid_eng
global alphagrid_eng
global Thrustgrid_com
global Fuelgrid_com

[Mgrid_eng,alphagrid_eng] =  meshgrid(unique(sort(enginedata(:,1))),unique(sort(enginedata(:,2))));
Thrustgrid_com = ThrustF_spline(Mgrid_eng,alphagrid_eng);
Fuelgrid_com = FuelF_spline(Mgrid_eng,alphagrid_eng);

%-----------------------------------
% Define the problem function files:
%-----------------------------------
SFB.cost 		= 'TESTCost';
SFB.dynamics	= 'TESTDynamics';
SFB.events		= 'TESTEvents';	

%-------------------------------------------
% Set up the problem bounds 
%-------------------------------------------
global scale
scale.a = 1000;
scale.V = 1e-3;
scale.v = 1e-3;
scale.ang = 10;
scale.LATLONG = 100;
scale.t = 1;
scale.m = 1;

tfMax 	    = 800;     

bounds.lower.time 	= [0; 0];				
bounds.upper.time	= [0; tfMax]*scale.t;			 

% bounds.lower.states = [25000*scale.V; -1*scale.LATLONG; -1*scale.LATLONG; -0.1*scale.ang; 1*scale.v; -1*scale.ang; deg2rad(2)*scale.a + eps*scale.a; -1*scale.ang; 0*scale.m]; 
% bounds.upper.states = [35000*scale.V; 1*scale.LATLONG; 1*scale.LATLONG; .1*scale.ang; 3000*scale.v; 1*scale.ang; deg2rad(6)*scale.a - eps*scale.a; 1*scale.ang; 1000*scale.m];

bounds.lower.states = [25000*scale.V;  -0.1*scale.ang; 1*scale.v;deg2rad(2)*scale.a + eps*scale.a; 0*scale.m]; 
bounds.upper.states = [35000*scale.V; .1*scale.ang; 3000*scale.v; deg2rad(6)*scale.a - eps*scale.a;  1000*scale.m];

% bounds.lower.controls = [deg2rad(-.5)*scale.a;-0.001*scale.ang];
% bounds.upper.controls = [deg2rad(.5)*scale.a; 0.001*scale.ang ];

bounds.lower.controls = [deg2rad(-.5)*scale.a];
bounds.upper.controls = [deg2rad(.5)*scale.a];

% bounds.lower.events = [26000*scale.V; 0*scale.ang; 0*scale.ang; 0*scale.ang; 1850*scale.v; 0*scale.ang; 1000*scale.m; 0*scale.m];	

bounds.lower.events = [26000*scale.V; 0*scale.ang; 1850*scale.v; 1000*scale.m; 0*scale.m];
bounds.upper.events = bounds.lower.events;

%------------------------------------
% Tell DIDO the bounds on the problem
%------------------------------------

SFB.bounds = bounds;

%------------------------------------------------------
% Select the number of nodes for the spectral algorithm
%------------------------------------------------------

algorithm.nodes = [50];  

%------------------------------------------------------------------
% guess.states(1,:) = [26000*scale.V, 33000*scale.V];
% guess.states(2,:) = [0*scale.LATLONG,0.20*scale.LATLONG];
% guess.states(3,:) = [0, 0.0*scale.LATLONG];
% guess.states(4,:) = [0,0];
% guess.states(5,:) = [1800*scale.v, 2800*scale.v];
% guess.states(6,:) = [0,0];
% guess.states(7,:) = [deg2rad(3)*scale.a,deg2rad(3)*scale.a];
% guess.states(8,:) = [0,0];
% guess.states(9,:) = [1000,0];
% guess.controls(1,:)    = [0,0];
% guess.controls(2,:)    = [0, 0];
% guess.time        = [0,300];

guess.states(1,:) = [26500*scale.V, 32400*scale.V];
guess.states(2,:) = [deg2rad(1.5)*scale.ang,deg2rad(0.2)*scale.ang];
guess.states(3,:) = [1800*scale.v, 2850*scale.v];
guess.states(4,:) = [deg2rad(5)*scale.a,deg2rad(4)*scale.a];
guess.states(5,:) = [1000,0];
guess.controls(1,:)    = [0,0];
guess.time        = [0,300];

algorithm.guess = guess;
%---------------------------
% call DIDO
%---------------------------

startTime = cputime;
[cost, primal, dual] = dido(SFB, algorithm);

RunTime = cputime - startTime

%--- save data ---
save NoGuessLanderOutput

%--- plot data ---

%============================================================================
figure;

plot(primal.nodes, primal.states, primal.nodes, primal.controls);
% legend('altitude', 'LONG', 'LAT', 'gamma', 'v', 'heading', 'alpha', 'chi',  'control 1', 'control 2');
%=============================================================================

%============================================================================
figure;
plot(primal.nodes, dual.dynamics, '-*',primal.nodes,dual.states,'--');

xlabel('normalized time units');
ylabel('normalized units');

%=============================================================================

xi = primal.states(2,:);
phi = primal.states(3,:);

% endPointCost   = -sqrt(xi(end)^2+phi(end)^2)

