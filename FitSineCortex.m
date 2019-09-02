function [yp] = FitSineCortex(x,y) 
% fit a sine wave to the data and extrapolate phase at 0 from it
%   x   : line vector of sample numbers
%   y   : Data to be fit (same size as x)
%   z   : sample number of the zerovalue
%   s(1): sine wave amplitude (in units of y)
%   s(2): period (in units of x)
%   s(3): phase (phase is s(2)/(2*s(3)) in units of x)
%   s(4): offset (in units of y)
%   Adapted from https://uk.mathworks.com/matlabcentral/answers/121579-curve-fitting-to-a-sinusoidal-function
%findpeaks(y)
yu = max(y);
yl = min(y);
yr = (yu-yl);                                                       % Range of ‘y’
yz = y-yu+(yr/2);
zx = x(yz .* circshift(yz,[0 1]) <= 0);                             % Find zero-crossings
per = 2*mean(diff(zx));                                             % Estimate period
ym = mean(y);                                                       % Estimate offset
fit = @(b,x)  b(1).*(sin(2*pi*x./b(2) + 2*pi/b(3))) + b(4);         % Function to fit
fcn = @(b) sum((fit(b,x) - y).^2);                                  % Least-Squares cost function
s = fminsearch(fcn, [yr;  per;  -1;  ym]);                          % Minimise Least-Squares
xp = linspace(min(x),max(x),length(x));                             % Extend original data 
yp = fit(s,xp);

% figure(1)
% hax=axes;
% hold on
% plot(x,y,'b',  xp,yp, 'r', xp, PhaInf, 'k')
% line([z z],get(hax,'YLim'),'Color',[0.5 0 0.5])
% legend('Original Data', 'Extrapolated Fitted Sine', 'Phase Value');
% grid

end