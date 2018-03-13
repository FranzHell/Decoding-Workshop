% SIMPLE SIMULATIONS

%% attractor network with random input
attr(1);
%% attractor network with primed input
attr(8);
%% attractor network with small shift (weak input)
attr(2);
%% attractor network with large shift (weak input)
attr(3);
%% attractor network with large shift (strong input)
attr(4);
%% competing inputs far apart
attr(6);
%% competing inputs close together
attr(7);
%% how does the bump shift as you increase the strength of a distal correction input
for iS = [25 26 27 28 29 30 35 40 50];
    R = ANN({[25,1,5],[iS,200,1]}); 
    [phi,rho] = VectorMean(R);
    figure; 
    ShowOutput(R, phi,rho);
    title(sprintf('Distance = %d units', iS-25));
end

%% how does the bump shift as you increase the strength of a distal correction input
for iS = linspace(0.5,3,10)
    R = ANN({[25,1,5],[50,100,iS]});
    [phi,rho] = VectorMean(R);
    figure; 
    ShowOutput(R, phi,rho);
    title(sprintf('Strength = %f', iS));
end

%% how do two components compete
for iS = linspace(1,19,10)
    R = ANN({[35-iS,1,1],[35+iS,1,1]});
    [phi,rho] = VectorMean(R);
    figure; 
    ShowOutput(R, phi,rho);
    title(sprintf('Distance = %d', 2*iS+1));
end

%%