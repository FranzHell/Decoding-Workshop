function RESULTS = ANN(inputs)
%
% Attractor
% One dimensional attractor sample code, written for Matlab 5.0
%
% [RESULTS, M] = Attractor(figure_to_show)
% provide inputs as trio of (input neuron, time, strength)
% inputs will be continued for 100 timesteps from time

if nargin==0
    inputs = {};
end

global dt
global W_EI W_IE W_II W_EE
global tauE gammaE tauI gammaI

%------------------------------
% set random seed
%------------------------------

rand('state', sum(100*clock));

%------------------------------
% PARAMETERS
%------------------------------

NE = 75; 		% Number of excitatory neurons

dt = 0.001;		% time step, in ms

tauE = 0.01;		% time constant, excitatory neurons
gammaE = -1.5;		% tonic inhibition, excitatory neurons

tauI = 0.002;		% time constant, inhibitory neuron
gammaI = -7.5;		% tonic inhibition, inhibitory neuron

E = zeros(NE,1);	% allocate space for NE excitatory neurons and
I = 0;			% one inhibitory neuron

W_EI = -8.0 * ones(NE,1);	% I -> E weights
W_IE = 0.880 * ones(1,NE);	% E -> I weights
W_II = -4.0;			% I -> I weights
W_EE = BuildWeightMatrix(NE);	% E -> E weights

%------------------------------
% Construct inputs 
%------------------------------

IN = cat(1, ones(100,1) * rand(1,NE), zeros(200,NE))';
for i0 = 1:length(inputs)
    IN0 = exp(-(((1:NE) - inputs{i0}(1)).^2)/25);
    IN1 = [zeros(inputs{i0}(2)-1,1); ones(100,1); zeros(300-inputs{i0}(2)-100+1,1)];
    IN = IN + inputs{i0}(3)*(IN1*IN0)';
end

%----------------------------
% CYCLE
%----------------------------

steps = size(IN,2);

RESULTS = zeros(NE,steps);

for t=1:steps
    
    VE = W_EI * I + W_EE * E + gammaE + IN(:,t);
    VI = W_II * I + W_IE * E + gammaI;
    
    FE = 0.5 + 0.5 * tanh(VE);
    FI = 0.5 + 0.5 * tanh(VI);
    
    E = E + dt/tauE * (-E + FE);
    I = I + dt/tauI * (-I + FI);
    
    RESULTS(:,t) = E;
    
end