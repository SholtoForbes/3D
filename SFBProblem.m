%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;					
%==============================================================
global CONSTANTS

CONSTANTS.g     = 10.000;  

global Coeff
Coeff = dlmread('Coefficients.txt');

%-----------------------------------
% Define the problem function files:
%-----------------------------------
SFB.cost 		= 'SFBCost';
SFB.dynamics	= 'SFBDynamics';
SFB.events		= 'SFBEvents';	

%-------------------------------------------
% Set up the problem bounds 
%-------------------------------------------

tfMax 	    = 40;     

bounds.lower.time 	= [0; 0];				
bounds.upper.time	= [0; tfMax];			 

% bounds.lower.states = [0; -100; -100; -100; 0; 0; -1.57]; 
% bounds.upper.states = [11; 100; 100; 0; 11; 1.0; 1.57];

global scale
scale.a = 10;
scale.V = 1e-3;
scale.v = 1e-2;

bounds.lower.states = [0*scale.V; -1; -1; -1.5707; 1*scale.v; -1; deg2rad(2)*scale.a; -1]; 
bounds.upper.states = [10000*scale.V; 1; 1; 1.5707; 3000*scale.v; 1; deg2rad(6)*scale.a; 1];


bounds.lower.controls = [-0.1 ;deg2rad(-0.1)*scale.a];
bounds.upper.controls = [0.1 ; deg2rad(0.1)*scale.a];

% bounds.lower.events = [10; 0; 0; 10];	
bounds.lower.events = [3000*scale.V; 0*scale.V; 0; 0; 0; 1000*scale.v; 0];	
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

startTimeNoGuess = cputime;
[cost, primal, dual] = dido(SFB, algorithm);



noGuessRunTime = cputime - startTimeNoGuess

%--- save data ---
save NoGuessLanderOutput

%--- plot data ---

%============================================================================
figure;

plot(primal.nodes, primal.states, primal.nodes, primal.controls);
% legend('altitude', 'LONG position', 'LAT position', 'vertical speed', 'horizontal speed', 'vertical orientation angle', 'lateral orientation angle',  'control 1', 'control 2');
legend('altitude', 'LONG', 'LAT', 'gamma', 'v', 'heading', 'alpha', 'eps',  'control 1', 'control 2');
%=============================================================================

%============================================================================
figure;
plot(primal.nodes, dual.dynamics, '-*');
legend('\lambda_h', '\lambda_v', '\lambda_m');
xlabel('normalized time units');
ylabel('normalized units');

%=============================================================================



