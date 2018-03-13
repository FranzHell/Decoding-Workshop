function [phi,rho] = VectorMean(R)

% returns angle and length of vector mean of R
% R is assumed to be nUnits x nT

[nU, nT] = size(R);

[P,~] = ndgrid(linspace(-pi,pi,nU),1:nT);

% normalize R by time
for iT = 1:nT
    R(:,iT) = R(:,iT)/sum(R(:,iT));
end

X = mean(cos(P).*R);
Y = mean(sin(P).*R);

phi = atan2(Y,X);
rho = sqrt(X.*X + Y.*Y);
