%   Generate an example cos signal with same frequency but time t = 10s
%    T0 = 0;
%    T1 = 10;
%    Ts = 1.0 / 10000;
%   Length of Signal
%    t = T0:Ts:1;
    N = 0:1/10000:1;
%    M = 10000/1;
%   Generate random signal
    %x = ((1 - 1.005037815.*exp(-0.5*t).*sin(25*t + 1.470628906)) - 1);
%    x = 10.00332110 - 2.500830275.*exp(-20*t).*(4*cos(80*t) + sin(80*t))

%   Time Signal
subplot(3, 1, 1);
plot(t,InputSignal)
title("Time signal");
xlabel('time (s)');


%   Compute bode plot
sys = tf([bn],[an])
N1 = TargetSamplingFrequency/SpectralRes
%   Bode plot logarithmic
subplot(3, 1, 2);
bode(sys, {1,N1})






