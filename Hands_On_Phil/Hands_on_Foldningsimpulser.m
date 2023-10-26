
%% Exercise 1.1
clear;
%Deklarere variable.
TDur = 0.1;
T0 = 0.01;
fs = 0.0005;
%Laver signalerne:
ramp = generate_ramp(T0,fs);
square = generate_square(T0,fs);
%Tilføjer zero padding
ramp = zero_pad(TDur,ramp,fs);
square = zero_pad(TDur,square,fs);
%Laver en tidsvektor:
TimeVec = 0:fs:TDur;
%Laver en figur med signalerne:
tiledlayout('flow');
hold on
nexttile
plot(TimeVec,ramp,'r')
xlabel('Time in s')
ylabel('Amplitude of signal')
legend('Ramp signal')
set(gca,'FontSize',12);
nexttile
plot(TimeVec,square,'b')
xlabel('Time in s')
ylabel('Amplitude of signal')
legend('Square signal')
set(gca,'FontSize',12);
hold off
%Now we do the convolution part.
ConvRR = conv(ramp,ramp);
ConvRS = conv(ramp,square);
ConvSS = conv(square,square);
%New time axis:
TimeVec2 = 0:fs/2:TDur;
figure()
tiledlayout('flow')
hold on
nexttile
plot(TimeVec2,ConvRR,'r')
xlabel('Time in s')
ylabel('Amplitude of Convolution')
legend('Convolution of ramp with ramp')
set(gca,'FontSize',12);
nexttile
plot(TimeVec2,ConvRS,'g')
xlabel('Time in s')
ylabel('Amplitude of Convolution')
legend('Convolution of ramp with square')
set(gca,'FontSize',12);
nexttile
plot(TimeVec2,ConvSS,'b')
xlabel('Time in s')
ylabel('Amplitude of Convolution')
legend('Convolution of Square with square')
set(gca,'FontSize',12);
hold off

%% Optional
%Now we do the correlation part.
CorrRR = xcorr(ramp,ramp);
CorrRS = xcorr(ramp,square);
CorrSS = xcorr(square,square);
%New time axis:
TimeVec2 = 0:fs/2:TDur;
figure()
tiledlayout('flow')
hold on
nexttile
plot(TimeVec2,CorrRR,'r')
xlabel('Time in s')
ylabel('Amplitude of Corralation function')
legend('Corralation of ramp with ramp')
set(gca,'FontSize',12);
nexttile
plot(TimeVec2,CorrRS,'g')
xlabel('Time in s')
ylabel('Amplitude of Corralation function')
legend('Corralation of ramp with square')
set(gca,'FontSize',12);
nexttile
plot(TimeVec2,CorrSS,'b')
xlabel('Time in s')
ylabel('Amplitude of Corralation function')
legend('Corralation of Square with square')
set(gca,'FontSize',12);
hold off
%Difference seems to be shifted in the corralation case, and ramp ramp is
%differencet.
%% Exercise 1.2
clear;
%Deklarere variable.
fs = 10e4;%Burde være 10e3 men who cares? Altså den højeste frekves er 4050Hz
%Dermed siger nyquist at vi mindst skal sample med 8100 Hz. Så 10e3 intet
%problem, denne her ser bare bedre ud.
dt = 1/fs;
Duration = 0.1;
TimeVec = 0:dt:Duration-dt;
%Order of moving average
n = 21;
%impulse respons of moving average. se slide 5. alle værdier er bare 1/n+1
h2 = ones(1,n+1)/(n+1);
h = zeros(1,length(TimeVec));
h(1:n+1) = h2;
%Sinosoiual parameters:
tDur = 1;
f1 = 500;
f2 = 2200;
f3 = 4050;
Amp = 1;
phase = 0;
[TimeVecSin,Sin1] = generate_sinusoid(Amp,f1,phase,fs,tDur);
[~,Sin2] = generate_sinusoid(Amp,f2,phase,fs,tDur);
[~,Sin3] = generate_sinusoid(Amp,f3,phase,fs,tDur);
%Plotter signalerne fra og til variablen nedenunder:
Indx = find(TimeVec==0.0025);
figure()
hold on
plot(TimeVecSin(1:Indx),Sin1(1:Indx),'r')
plot(TimeVecSin(1:Indx),Sin2(1:Indx),'g')
plot(TimeVecSin(1:Indx),Sin3(1:Indx),'b')
plot(TimeVecSin(1:Indx),h(1:Indx),'c')
xlim([TimeVecSin(1) TimeVecSin(Indx)])

filtSin1 = conv(Sin1,h);
filtSin2 = conv(Sin2,h);
filtSin3 = conv(Sin3,h);
%Signalet må stadig være samme tidslængde, altså 1 sekund. Dermed laves en
%tidsvektor der afspejler dette.
IndxSin = find(TimeVec==0.005);
IndxStart = find(TimeVec==0);
figure()
tiledlayout('flow')
nexttile
hold on
plot(TimeVec(1:IndxSin),filtSin1(1:IndxSin),'r')
plot(TimeVec(1:IndxSin),Sin1(1:IndxSin),'g')
nexttile
hold on
plot(TimeVec(1:IndxSin),filtSin2(1:IndxSin),'r')
plot(TimeVec(1:IndxSin),Sin2(1:IndxSin),'g')
nexttile
hold on
plot(TimeVec(1:IndxSin),filtSin3(1:IndxSin),'r')
plot(TimeVec(1:IndxSin),Sin3(1:IndxSin),'g')
% Det ses tydeligt her at attinuationen er højst ved de højere frekvenser,
% dermed er det et lavpass filter. Kan også ses at det er faseskiftet en
% smule.
%Ser i et enkelt tilfælde om der er forskel mellem conv og filter:
h3=1/22*[ones(1,22)];
FiltSin3_Filter = filter(h3,1,Sin3);
figure()
hold on 
plot(TimeVec(1:IndxSin),filtSin3(1:IndxSin),'g')
plot(TimeVec(1:IndxSin),FiltSin3_Filter(1:IndxSin),'r')
%De ligger lige oven i hinanden. Ser om de er ens:
DiffFilt = sum(abs(FiltSin3_Filter(1:end)-filtSin3(1:length(FiltSin3_Filter))));
%Praktisk talt ens.
%By hand bliver en anden dag.

%% 2.1 Room reverberation
clear;
%Deklarere variable
delay_samples = 100000;
alpha = 1;
h_ir = [1; zeros(delay_samples,1); alpha];
fileName1 = ['C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\Sounds\''PihalvePhase_' num2str(50) 'N.wav'];
%
[y1,Fs1] = audioread(fileName1);
filt1kHz = filter(h_ir,1,y1);
figure()
Tid = 0:1/Fs1:(length(y1)-1).*(1/Fs1);
PlotSamps = 500;
hold on
plot(Tid(1:PlotSamps),y1(1:PlotSamps),'r')
plot(Tid(1:PlotSamps),filt1kHz(1:PlotSamps),'g')
xlabel('Tid i s')
ylabel('Amplitude')
legend('Original','Efter filter')
title(['alpha = ' num2str(alpha) ' delay = ' num2str(delay_samples)])

fileName = ['C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\Sounds\spoken_sentence.wav'];
[y,Fs] = audioread(fileName);
%Før filter
%sound(y,Fs)
%Efter filter
Filt_y = filter(h_ir,1,y);
%sound(Filt_y,Fs)

% Skal nu tilføje flere reverbrations. men det har jeg ikke tid til lige
% nu.

%% 2.2 Putting sounds into different places
%Tester impulse respons fra rum og folder dem med hende damen der snakker
clear;
fileName = ['C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\Sounds\spoken_sentence.wav'];
[DameSnakke,FsDameSnakke] = audioread(fileName);
fileName = ['C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\Sounds\Grundtvigs_church.wav'];
[gKirke,FsgKirke] = audioread(fileName);
fileName = ['C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\Sounds\large_hall.wav'];
[Hall,FsHall] = audioread(fileName);
fileName = ['C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\Sounds\room.wav'];
[Rum,FsRum] = audioread(fileName);
fileName = ['C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\Sounds\church.wav'];
[Kirke,FsKirke] = audioread(fileName);
fileName = ['C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\Sounds\Sax12.wav'];
[Sax,FsSax] = audioread(fileName);
SaxChurch = conv(gKirke(:,1),DameSnakke);
SaxChurch1 = SaxChurch./(max(SaxChurch));

sound(SaxChurch1,FsDameSnakke)
