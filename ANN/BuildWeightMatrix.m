function W = BuildWeightMatrix(NE)

stddevConst = 15; 	% degrees
Wconst = 6.0;		% weight constant

variance = stddevConst^2 / (360^2) * NE ^2;

i = ones(NE,1) * (1:NE);
j = (1:NE)' * ones(1,NE);

d_choices = cat(3,abs(j + NE - i), abs(i + NE - j), abs(j - i));
d = min(d_choices, [], 3);

W = exp(-d .* d / variance);
W = Wconst * W./(ones(NE,1) * sum(W));


