function [RESULTS, M] = attr(figure_to_show)
%
% Attractor
% One dimensional attractor sample code, written for Matlab 5.0
%
% [RESULTS, M] = Attractor(figure_to_show)
%
% Figure to Show
% 1: settling from noise
% 2: small shift
% 3: rotation
% 4: jump
% 5: THERE IS NO 5.
% 6: competition far
% 7: competition near
% 8: priming

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
% Input functions
%------------------------------

switch figure_to_show
    
    case 1, 			% figure A.1
        
        IN = cat(1, ones(100,1) * rand(1,NE), zeros(100,NE))';
        
    case 2,			% figure A.2
        
        IN0 = exp(-(((1:75) - 35).^2)/25);
        IN1 = ones(100,1) * IN0;
        IN0 = 2 * exp(-(((1:75) - 40).^2)/25);
        IN2 = ones(200,1) * IN0;
        IN = cat(1,IN1,IN2)';
        
    case 3,			% figure A.3
        
        IN0 = exp(-(((1:75) - 20).^2)/25);
        IN1 = ones(100,1) * IN0;
        IN0 = exp(-(((1:75) - 60).^2)/25);
        IN2 = ones(200,1) * IN0;
        IN = cat(1,IN1,IN2)';
        
    case 4,			% figure A.4
        
        IN0 = exp(-(((1:75) - 60).^2)/25);
        IN1 = ones(100,1) * IN0;
        IN0 = 2 * exp(-(((1:75) - 20).^2)/25);
        IN2 = ones(200,1) * IN0;
        IN = cat(1,IN1,IN2)';
        
    case 5, % Not part of the figures...
        disp('There is no 5.');
        return;
        
    case 6,			% figure A.6
        
        IN0 = 0.5 * (0.1 * rand(1,75) + exp(-(((1:75) - 25).^2)/40));
        IN1 = 0.5 * (0.1 * rand(1,75) + exp(-(((1:75) - 45).^2)/40));
        IN = (ones(150,1) * (IN0 + IN1))';
        
    case 7,			% figure A.7
        
        IN0 = 0.5 * (0.1 * rand(1,75) + exp(-(((1:75) - 29).^2)/40));
        IN1 = 0.5 * (0.1 * rand(1,75) + exp(-(((1:75) - 41).^2)/40));
        IN = (ones(150,1) * (IN0 + IN1))';
        
    case 8,              % priming the attractor
        IN0 = 0.5 * (0.1 * rand(1,75) + exp(-(((1:75) - 29).^2)/40));
        IN = (ones(150,1) * IN0)';
        
    otherwise, disp('Unknown input set')
        
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

%-----------------------------
% DRAW
%------------------------------

figure(1)
clf
surfl(RESULTS)
shading interp
view([-30 75])
colormap(bone)

set(gca,'Xtick',[])
set(gca,'Ytick',[])
set(gca,'Ztick',[])

if (nargout == 2)
    figure(3)
    clf
    bar(RESULTS(:,1),0.75);
    M = moviein(steps);
    for iS = 1:steps
        bar(RESULTS(end:-1:1,iS),0.75);
        axis([0 NE+1 0 1.5]);
        M(iS) = getframe;
    end
end