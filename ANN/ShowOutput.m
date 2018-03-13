function ShowOutput(R,phi,rho)

% shows R with angle and length of vector mean
% R is assumed to be nUnits x nT
% phi and rho are assumed to be 1 x nT

clf;

subplot(3,1,1:2)
[~,nT] = size(R);
imagesc([1 nT], [-pi pi], R);
colormap copper

hold on;
scatter(1:nT,phi,40,'r','.');

subplot(3,1,3);
plot(1:nT, rho, 'r.');
