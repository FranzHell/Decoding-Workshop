function [z, pABOVE, pBELOW] = FeederCellTest(S,T,sd, varargin)

% [z, pABOVE, pBELOW] = FeederCellTest(sd,iC, varargin)
%
% INPUT
%   S = ts of a single spiketrain
%   T = times cell fired
%   sd = sd structure
% OUTPUT
%   z = zscore relative to random samples
%   pABOVE, pBELOW = proportion of random samples actual is larger than or less than
% PARAMETERS
%   nB = number of random samples to do (nB=1000);
%   w = window (w=[0 4]);

nB = 1000;
w = [0 4];
fn = '';
displayREAL = true;
process_varargin(varargin);

% real PETH
if displayREAL
    spikePETH(S, T, 'window', [w(1)-2 w(2)+2], 'dt', 0.1, 'showSpikes',true);
    line(w(1) * [1 1], ylim, 'Color', 'g', 'LineWidth', 2);
    line(w(2) * [1 1], ylim, 'Color', 'r', 'LineWidth', 2);
    title(fn);
    drawnow;
end

FR = CountSpikes(S.data, T, w);
FRreal = mean(FR);

% PETHs at random times
nT = length(T);
FRtest = nan(nB, 1);
for iB = 1:nB
    T0 = rand(nT,1) * (sd.ExpKeys.TimeOffTrack - sd.ExpKeys.TimeOnTrack) + sd.ExpKeys.TimeOnTrack;
    FR = CountSpikes(S.data, T0, w);
    FRtest(iB) = mean(FR);
end

% stats
pABOVE = mean(FRreal > FRtest);
pBELOW = mean(FRreal < FRtest);
z = (FRreal - mean(FRtest))/std(FRtest);

% distribution
clf;
hist(FRtest,100);
line(FRreal*[1 1], ylim, 'Color', 'r');
title(sprintf('%s z=%.2f pABOVE=%.2f pBELOW=%.2f', fn, z, pABOVE, pBELOW));
end

%% CountSpikes: note needs to be same function used for both raw data and random data
function FR = CountSpikes(Sdata, T, w)
nT = length(T);
FR = nan(nT,1);
for iT = 1:nT
    FR(iT) = sum(Sdata >= T(iT) + w(1) & Sdata <= T(iT) + w(2));
end
end