%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;		
clc;
%==============================================================
global CONSTANTS
 

global Coeff
Coeff = dlmread('Coefficients.txt');
global Atmosphere
Atmosphere = dlmread('atmosphere.txt');

%-----------------------------------  
% Define the problem function files:
%-----------------------------------
SFB.cost 		= 'SFBCost';
SFB.dynamics	= 'SFBDynamics';
SFB.events		= 'SFBEvents';	

%-------------------------------------------
% Set up the problem bounds 
%-------------------------------------------
global scale
scale.a = 100;
scale.V = 1e-3;
scale.v = 1e-3;
scale.ang = 10;
scale.LATLONG = 100;
scale.t = 1;

tfMax 	    = 800;     

bounds.lower.time 	= [0; 0];				
bounds.upper.time	= [0; tfMax]*scale.t;			 

bounds.lower.states = [0*scale.V; -1*scale.LATLONG; -1*scale.LATLONG; -1.5707; 1*scale.v; -1*scale.ang; deg2rad(2)*scale.a + eps*scale.a; -1*scale.ang]; 
bounds.upper.states = [40000*scale.V; 1*scale.LATLONG; 1*scale.LATLONG; 1.5707; 3000*scale.v; 1*scale.ang; deg2rad(6)*scale.a - eps*scale.a; 1*scale.ang];

bounds.lower.controls = [deg2rad(-.5)*scale.a;-0.001*scale.ang];
bounds.upper.controls = [deg2rad(.5)*scale.a; 0.001*scale.ang ];

bounds.lower.events = [27000*scale.V; 0.01*scale.V; 0*scale.ang; 0*scale.ang; 0*scale.ang; 2850*scale.v; 0*scale.ang; 0];	
bounds.upper.events = bounds.lower.events;

%------------------------------------
% Tell DIDO the bounds on the problem
%------------------------------------

SFB.bounds = bounds;

%------------------------------------------------------
% Select the number of nodes for the spectral algorithm
%------------------------------------------------------

algorithm.nodes = [100];  

%------------------------------------------------------------------
% guess.states(1,:) = [10, 0];
% guess.states(2,:) = [0, 50];
% guess.states(3,:) = [0, ];
% guess.states(4,:) = [];
% guess.states(5,:) = [];
% guess.controls    = [];
% guess.time        = [];

% algorithm.guess = guess;
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
legend('altitude', 'LONG', 'LAT', 'gamma', 'v', 'heading', 'alpha', 'chi',  'control 1', 'control 2');
%=============================================================================

%============================================================================
figure;
plot(primal.nodes, dual.dynamics, '-*',primal.nodes,dual.states,'--');

xlabel('normalized time units');
ylabel('normalized units');

%=============================================================================

xi = primal.states(2,:);
phi = primal.states(3,:);

endPointCost   = -sqrt(xi(end)^2+phi(end)^2)

