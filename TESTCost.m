function [endPointCost, runningCost] = TESTCost(primal)
global q

% xi = primal.states(2,:);
% phi = primal.states(3,:);
% v = primal.states(5,:);
% 
% endPointCost   = -v(end)*1000;

% v = primal.states(3,:);

% endPointCost   = -v(end);

endPointCost   = 0;

runningCost = ((q-50000).^2+1e7)./1e7;

% runningCost =0;
