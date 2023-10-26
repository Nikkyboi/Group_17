%% Filtering back and forth

%% 1 Poles and zeros - once again
%We found that poles and zeros really can do cool stuff. 
%Let’s see how they impact the impulse response of the system.

%% 1.1 In-N-out zero/pole
% • Create a system by placing two zeros (ζ1,2) and two poles (ρ1,2) at
clear;
%ζ1,2 = 0.95 · exp(±jπ/4)
%ρ1,2 = 0.95 · exp(±j3π/4)

Zeros = [0.95*exp((1i*pi)/4) 0.95*exp((-1i*pi)/4)]';
Poles = [0.95*exp((1i*3*pi)/4) 0.95*exp((-1i*3*pi)/4)]';
% • Calculate the filter coefficients B and A from the location of the poles/zeros
%Dette kan man gører med poly funktionen. 
%doc poly %Fjern procent tegn for at se hvad den gør. 
%I den tidligere hands-on gjorde vi det i hånden.
Bk = poly(Zeros);
Ak = poly(Poles);



%• Plot the pole-zero plot, the frequency response and the impulse response.
%Dette kan opnås med zplane og freqz.
figure()
zplane(Zeros,Poles)

figure()
freqz(Bk,Ak)

%Benytter impz til at finde impulse respons:
figure()
impz(Bk,Ak)

[hkorrekt, ~] = impz(Bk,Ak);
%Forsøger selv lige at lave impulse respons mere manuelt.
UnitCircStepSize = (pi*2)/(length(hkorrekt));
zHalf = zeros(1,round(length(hkorrekt)/2));
for j = 1:length(zHalf)
    zHalf(j) = exp((j-1)*UnitCircStepSize*1i);
end
z = [zHalf conj(zHalf(2:end))];
ZTrans = zeros(1,length(z));
Num = zeros(1,length(z));
Denomi = zeros(1,length(z));
for i = 1:length(hkorrekt)
    Num = Bk(1)*(z(i)^0)+Bk(2)*(z(i)^(-1))+Bk(3)*(z(i))^(-2);
    Denomi = Ak(1)*(z(i))^(0)+Ak(2)*(z(i))^(-1)+Ak(3)*(z(i))^(-2);
    ZTrans(i) = Num/Denomi;
end

hmanuel = ifft(ZTrans,'symmetric');
figure()
plot(hmanuel,'-bo')

%De ser ummildbart ud til at have samme form. Tjekker absDiff.
AbsDiff = sum((abs(hkorrekt')-abs(hmanuel))); %Vi ser at den er meget lav, så det er altså ens.

%%
%• Now move the zeros to a new location:
%ζ1,2 = 1.05 · exp(±jπ/4)
nZeros = [1.05*exp(+1i*pi/4) 1.05*exp(-1i*pi/4)]';
%Replot the figures and focus on the relation between 
%frequency response and impulse response
figure()
tiledlayout(2,1)
nexttile
hold on
zplane(Zeros,Poles)
title('Original z-plane')
hold off
nexttile
hold on
zplane(nZeros,Poles)
title('New zeros z-plane')
hold off



%Laver nye Bk koefficienter.
nBk = poly(nZeros);
figure()
freqz(Bk,Ak)
title('Original freqz response')
figure()
freqz(nBk,Ak)
title('New zeros freqz response')

[nhkorrekt, ~] = impz(nBk,Ak);

figure()
tiledlayout(1,2)
nexttile
plot(hkorrekt,'-bo')
title('Original impulse respons')
nexttile
plot(nhkorrekt,'-bo')
title('New zeros impulse respons')

%% 
%• Move the zeros back to their original location and move the poles to a new location:
%ρ1,2 = 1.05 · exp(±j3π/4)
%Dette filter er pr. definition ustabilt da polerne er ude af
%enhedscirklen. Men lad os gører det alligevel.
nPoles = [1.05*exp(+1i*3*pi/4) 1.05*exp(-1i*3*pi/4)]';
%Replot the figures and focus on the relation between 
%frequency response and impulse response
figure()
tiledlayout(2,1)
nexttile
hold on
zplane(Zeros,Poles)
title('Original z-plane')
hold off
nexttile
hold on
zplane(Zeros,nPoles)
title('New poles z-plane')
hold off



%Laver nye Bk koefficienter.
nAk = poly(nPoles);
figure()
freqz(Bk,Ak)
title('Original freqz response')
figure()
freqz(Bk,nAk)
title('New poles freqz response')

[nhkorrektPol, ~] = impz(Bk,nAk);

figure()
tiledlayout(1,2)
nexttile
plot(hkorrekt,'-bo')
title('Original impulse respons')
nexttile
plot(nhkorrektPol,'-bo')
title('New poles impulse respons')

%% 2 Making more of less

%The following example comes from a book on DSP. However, there is some 
% error in the book: The filter specs in the book don’t match the solution. 
% To improve the book for future generations, let’s do a solution that does 
% meet the filter criteria specified. Analytical calculations are helpful up 
% to a certain point - feel free to do them and to include them. 
% But you might as well make use of the tools built-in into Matlab to do the numerics. 
% Here you will be designing a lowpass filter that meets certain specifications. 
% The approach is similar for different filter types and what you get out is 
% something you can apply and that has properties depending on how you generated 
% it - that’s why it is neccessary to understand what is behind different routines

%% 2.1 A specific example
clear;
%Design a digital lowpass filter using bilinear transform with prewarping 
%meeting the following specifications:
% • A gain of unity at ω = 0
% • A gain of no less than -2 dB (Gp = 0.785) over the passband 0 ≤ ω ≤ 10
% • A gain no greater than -11 dB (Gs = 0.2818) over the stopband ω ≥ 15
% • The highest frequency to be processed ωh = 35 rad/s
% useful commands: butter, buttord
% Show the amplitude and phase response of the resulting filter together with 
% the filter specifications in the title of the plot. 
% Write down the transfer function of the resulting filter and specify the filter type. 
% You are pre-warping your frequencies here - what are the values after pre-warping?

%Finder order og Wn.
Gp = -2; %I dB.
Wp = 10; %I rad/s
Gs = -11; %I dB.
Ws = 15; %I rad/s
Wh = 35; %I rad/s (højste frekvens to be processed.)
%Hvis vi gør det efter det som der står i doc buttord får vi:
WpHz = Wp/(2*pi);
WsHz = Ws/(2*pi);
WhHz = Wh/(2*pi);
[n, Wn] = buttord(Wp/Wh,Ws/Wh,abs(Gp),abs(Gs));
[Bk,Ak] = butter(n,Wn);
%Show the amplitude and phase response of the resulting filter together 
% with the filter specifications in the title of the plot. 
% Write down the transfer function of the resulting filter and specify the filter type. 
% You are pre-warping your frequencies here - what are the values after pre-warping?
figure()
freqz(Bk,Ak)
title(['filter with Wp = ',num2str(WpHz/WhHz),'Ws = ',num2str(WsHz/WhHz),'Gp = ',num2str(Gp),'dB Gs = ',num2str(Gs),'dB'])

%Transferfunction =
%(b(1)*z^0+b(2)*z^-1+b(3)*z^-2+b(4)*z^-3)/a(1)*z^0+a(2)*z^-1+a(3)*z^-2.
%Man kan se fra filter responset at det er et lowpass filter.

% You are pre-warping your frequencies here - what are the values after
% pre-warping? Ved ikke hvad jeg skal svare her... Spørg Bastian.

%% 2.2 The issue of phase shifts and order
clearvars -EXCEPT Ak Bk WhHz
%Now we have a filter meeting the required specifications. Now assume your 
%filter coefficients are implemented, compiled and the source codes are lost. 
%You have a filter of the order coming out of its design and there is no way 
%to change the properties of the filter - it is already in production and 
%now you are to use the product you have in your hand.

% When passing a pure tone signal through the filter, it will be scaled and 
% shifted in phase. Assume you are asked to process a signal through your 
% filter - while the magnitude of the transfer function is less important, 
% you definitely need zero phase shift. Use the filter designed above to 
% process a sinusoidal signal such that the resulting phase shift is zero. 
% Plot the original and the processed signals on top of each other.

%A pure tone signal is just one single frequency. We technically have the
%transfer function, which means, we can predict how much each frequency is
%Scaled and shifted before hand. If we wanna counterract this, we can just
%scale and shift the pure tone (single frequency) by the oppesite amount 
%before passing it to the filter. Here we are asked to make sure that zero
%phase shift occurs, which means, we have to phaseshift the pure tone by an
%amount before passing to the filter.

%We now make a sinusoid with a frequency of 4 Hz. Normalized freqency is :
TestHz = 3; %Må ikke være større end 2*WhHz.
phase = 0;
Amp = 1;
Len = 10000;
fs = 2*WhHz;
TDur = (1/(fs))*Len;

[TimeVec,Sig0Phase] = generate_sinusoid(Amp,TestHz,phase,fs,TDur);
[Y, freq] = make_spectrum(Sig0Phase,fs);
h = freqz(Bk,Ak,freq,fs); %h = freqz(___,w) returns the frequency response vector h evaluated at the normalized frequencies supplied in w.
%h = freqz(___,f,fs)

%Finder den frekvens i frekvens vektoren, med den frekvens tættest på
%TestHz.
[ValTestHzFFT,idxTestHz] = min(abs(abs(freq)-TestHz));

%Finder ud af faseskiftet som filteret tilføjer. 
PhasePre = mean(angle(h(idxTestHz)));
%Kunne måske også bare sige (Giver det samme):
% hTestHz = freqz(Bk,Ak,[1 TestHz],fs);
% PhasePre = angle(hTestHz(2));
%Hvis denne phase nu tilføjes inden, vil resultatet se anderledes ud:
%Dog med minus fortegn da phase her er positiv.
[TimeVec2,SigSomePhase] = generate_sinusoid(Amp,TestHz,-PhasePre,fs,TDur);

figure()
plot(freq,abs(Y),'r')
xlabel('Normalized freqency')
ylabel('Amplitude')

figure()
tiledlayout('flow')
nexttile
plot(freq,abs(h),'r')
xlabel('Frequency in Hz')
ylabel('Amplitude')
nexttile
plot(freq,angle(h),'b')
xlabel('Frequency in Hz')
ylabel('Phase')


Response = filter(Bk,Ak,Sig0Phase);
figure()
hold on
plotlength = 50;
plot(TimeVec(1:plotlength),Sig0Phase(1:plotlength),'r')
plot(TimeVec(1:plotlength),Response(1:plotlength),'b')
xlabel('Time i s')
ylabel('Amplitude')
legend('Original','Processed')
title('Original signal and processed without pre-phase shift')
hold off

Response = filter(Bk,Ak,SigSomePhase);
figure()
hold on
plotlength = 50;
plot(TimeVec(1:plotlength),Sig0Phase(1:plotlength),'r')
plot(TimeVec(1:plotlength),Response(1:plotlength),'b')
xlabel('Time i s')
ylabel('Amplitude')
legend('Original','Processed')
title('Original signal and processed with pre-phase shift')
hold off
