%Hands on uge 3.
%TIME TO FREQUENCY AND FREQUENCY TO TIME
%% 1.1 Toolbox: Spectrum
clear;
%Generate a sinusoid of frequency 500 Hz, duration of 0.5 seconds, and amplitude of 1. Pass
%the signal to your new function. Plot the result over the frequency and make sure the peak
%is on the correct frequency.
%og:
%Change the frequency of the signal to 499 Hz and plot the result in the same graphs as
%above. Please comment on the result.

%generere variable:
Amp = 1;
Tdur = 0.5;
fhz500 = 500;
fhz499 = 499;
fs = 1500;
phase = 0;
[TimeVec500,F500] = generate_sinusoid(Amp,fhz500,phase,fs,Tdur);
[TimeVec499,F499] = generate_sinusoid(Amp,fhz499,phase,fs,Tdur);
[FFT500,FrqAxis500] = make_spectrum(F500,fs);
[FFT499,FrqAxis499] = make_spectrum(F499,fs);
DBFFT500 = TodB(FFT500);
DBFFT499 = TodB(FFT499);
figure()
tiledlayout('flow')
nexttile
hold on
plot(FrqAxis500,DBFFT500,'r')
xlabel('Frequency in Hz')
ylabel('Amplitude in dB')
legend('500 Hz')
nexttile
plot(FrqAxis499,DBFFT499,'b')
xlabel('Frequency in Hz')
ylabel('Amplitude in dB')
legend('499 Hz')
hold off
%Fordi at frekvensen 499 Hz ikke går direkte op i 1500, fås et peak ved den
%nærmeste frekvens 500 Hz og hele spektrummet bliver shiftet lidt ned og
%får en anden form. Der er nemlig ikke 500 Hz i signalet, kun 499, men det
%kan man kun vide hvis man har en sampling frekvens der passer. Selv hvis
%sampling frekvensen bliver meget stor løber man ind i samme problem (prøv
%selv 100000). Dette lader dog ikke til at være hele problemet da selv en
%sampling frekvens på 4*499 = 1996 heller ikke løser det. Måske kan fft
%bare bedst lide lige tals frekvenser?.

%% 1.2 Fourier transform of a synthetic signal
clear;
%Synthesize the following signal of duration T = 4 seconds with a suitable sampling frequency:
%Formelen kan ses fra handson.
%Deklarere variable.
T = 4;
f0 = 25; % Da nyquist skal overholdes er det vigtigt at sampling frekvensen er tilpas høj.
%Den højeste frekvens i dette spektrum er 2*pi*(2^k)*f0 hvor k = 4.
%Dermed 2513.3333 Dermed skal sampling mindst være 2*2513.3333 så i hvert
%fald en smule over 5000 radianer pr. sekund, så ca. 5000/(2*pi) =
%795.7747. Bare over 800. (Kunne bare have sagt over 2^4*f0=400 400*2 er 800 Hz lol ;()
%
kend = 4;
fs = 1800;
dt = 1/fs;
TimeVec = 0:dt:4-dt;
ker = 0:kend;
ToneMatrix = zeros(length(ker),length(TimeVec));
for k=1:length(ker)
ToneMatrix(k,:) = cos(2*pi.*(2^ker(k))*f0.*TimeVec+ker(k)*(1/3));
end
SumTone = sum(ToneMatrix,1);

%Plot the time signal in the time window from [0.8 s, 0.9 s].
StartIdx = find(TimeVec>=0.8);
SlutIdx = find(TimeVec>=0.9);

figure();
hold on
plot(TimeVec(StartIdx:SlutIdx),SumTone(StartIdx:SlutIdx),'g')
xlabel('Time in s')
ylabel('Amplitude of tone')
title('Plot of tone complex')
set(findall(gcf,'-property','FontSize'),'FontSize',12)
hold off

%Plotter de andre oven i for sjov.
figure();
hold on
plot(TimeVec(StartIdx:SlutIdx),SumTone(StartIdx:SlutIdx),'g')
plot(TimeVec(StartIdx:SlutIdx),ToneMatrix(1,StartIdx:SlutIdx),'b')
plot(TimeVec(StartIdx:SlutIdx),ToneMatrix(2,StartIdx:SlutIdx),'r')
plot(TimeVec(StartIdx:SlutIdx),ToneMatrix(3,StartIdx:SlutIdx),'c')
plot(TimeVec(StartIdx:SlutIdx),ToneMatrix(4,StartIdx:SlutIdx),'k')
plot(TimeVec(StartIdx:SlutIdx),ToneMatrix(5,StartIdx:SlutIdx),'m')
xlabel('Time in s')
ylabel('Amplitude of tone')
title('Plot of tone complex')
set(findall(gcf,'-property','FontSize'),'FontSize',12)
legend('Tone Complex','Tone when k = 0','Tone when k = 1','Tone when k = 2','Tone when k = 3','Tone when k = 4')
hold off
%Compute and plot the spectrum of the whole signal with Hz on the x-axis and linear
%amplitude on the y-axis
[FFTToneC,FrqAxis] = make_spectrum(SumTone,fs);
%Plotter.
figure()
hold on
plot(FrqAxis,abs(FFTToneC),'r')
xlabel('Frequency in Hz')
ylabel('Linear amplitude (abs)')
title('Fouirer of tone complex')
set(findall(gcf,'-property','FontSize'),'FontSize',12)
hold off

%Link med phase formel.
%https://stats.stackexchange.com/questions/190163/amplitude-and-phase-from-the-fourier-transform-equation
%phase = atan2(imag(FFTToneC),real(FFTToneC));
[phase, ~] = cart2pol(real(FFTToneC), imag(FFTToneC));
slutposidx = find(FrqAxis<0);
posFrqAxis = FrqAxis(1:slutposidx(1)-1);
posFrqTone = FFTToneC(1:slutposidx(1)-1);
posFrqphase = phase(1:slutposidx(1)-1);
posFrqIm = imag(FFTToneC(1:slutposidx(1)-1));
posFrqRe = real(FFTToneC(1:slutposidx(1)-1));
%plotter både amplitude og phase for positive frekvenser.
figure()
subplot(2,1,1);
plot(posFrqAxis,abs(posFrqTone),'g')
xlabel('Frequency')
ylabel('Linear amplitude')
title('Magnitude plot')

subplot(2,1,2); 
plot(posFrqAxis,posFrqphase,'g')
xlabel('Frequency')
ylabel('Phase')
title('Phase plot')
set(findall(gcf,'-property','FontSize'),'FontSize',12)

figure()
subplot(2,1,1);
plot(posFrqAxis,posFrqRe,'g')
xlabel('Frequency')
ylabel('Real part')
title('Real part plot')

subplot(2,1,2); 
plot(posFrqAxis,posFrqIm,'g')
xlabel('Frequency')
ylabel('Imaginary part')
title('Imaginary part plot')
set(findall(gcf,'-property','FontSize'),'FontSize',12)

%Det ses at fra eulers formel at e^{ix}=cos(x) + i*sin(x), her er hele
%signalet lavet af cossinuser. Fra wiki ser det ud til at cos(x) = Re(
%e^{ix}), og sin = Im(%e^{ix}). cos(x) = sin(x + pi/2) og cos(x−pi/2)=sinx.
%Ved k = 0 er frekvensen 25 og ingen fase forskydning, dermed har vi med en
%ren cos at gøre. Det ses også her at imagniær delen er højst. Når k stiger
%så stiger frekvens og phase også. Her er fasen vigtig, da når fasen er
%-pi/2 eller +3*pi/2 har vi med en sinus at gøre. Det ses dermed at real
%delen faler og imaniær delen stiger, da fase forskydningen for cos til at
%blive sin. Netop når k=4 burde der være maks. Her er frekvnesen så 2^4*f0
%= 400 Hz, her er faseforskydningen 4*pi/3 som er det tætteste vi kommer på
%sin. altså imagniær delen. Med andre ord, cos bliver til sin når
%faseforskydningen er -pi/2 eller +3*pi/2, siden at faseforskydningen ændre
%sig fra k=0 fase=0 til k=4 fase=4*pi/3, har vi ikke længere med en "ren"
%cossinus at gøre længere, men derimod en blanding af de to. Det ses også
%at realdelen falder og imagniær delen stiger, dette giver god mening da
%cossinus bliver mere sinus, når faseforskydningen stiger.
%Hvis signalet istedet var sin, ville man forvente at når fase
%forskydningen nærmede sig p/2 så ville realdelen blive større. Man ville
%dog starte med ren imaginær værdi da der ikke er faseforsskydning når k=0.

%% Stadig 1.2 Fourier transform of a synthetic signal
%Plot the magnitude spectrum with Hz on a log scale on the x-axis and dB on the y-axis.
%Mark the first peak in the spectrum with a circle.
dBFFTToneC = TodB(posFrqTone);
figure()
semilogx(posFrqAxis,dBFFTToneC,'g')
title('Freqency spectrum with log x and db y')
xlabel('Frequency in log scale')
ylabel('Amplitude in dB scale')
set(findall(gcf,'-property','FontSize'),'FontSize',12)

%Save the signal as a .wav file with a bit depth of 16 bits and load it again. Make sure
%the signal is not distorted by saving into a .wav file. Plot the loaded signal on top of the
%synthetic time signal using a different color in the time interval [0.85 s,0.925 s]. Provide
%comments on your coding.
filename = 'C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\Sounds\Uge_3_lyd.wav';
audiowrite(filename,SumTone,fs,'BitsPerSample',16);

[ReadTone,Fs] = audioread(filename);

StartIdx2 = find(TimeVec>=0.85);
SlutIdx2 = find(TimeVec>=0.925);
Diff = abs(ReadTone-SumTone);

figure()
hold on 
plot(TimeVec(StartIdx2(1):SlutIdx2(1)),ReadTone(StartIdx2(1):SlutIdx2(1)),'b')
plot(TimeVec(StartIdx2(1):SlutIdx2(1)),SumTone(StartIdx2(1):SlutIdx2(1)),'g')
plot(TimeVec(StartIdx2(1):SlutIdx2(1)),Diff(StartIdx2(1):SlutIdx2(1)),'m')
xlabel('Tid i s')
ylabel('Amplitude')
legend('Loadet signal','Original signal','Forskel')
set(findall(gcf,'-property','FontSize'),'FontSize',12)
%Der er clipping da bit dybden ikke er stor nok.

%% 1.3 Fourier transform of a recorded signal
clear;
%Plot the time signal in the time window from 0 s to 1 s.
filename = 'C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\Sounds\piano.wav';
[Readpiano,Fs] = audioread(filename);
dT = 1/Fs;
TimeVec = 0:dT:length(Readpiano)*dT-dT;
SlutIdx = find(TimeVec>=1);
figure()
plot(TimeVec(1:SlutIdx),Readpiano(1:SlutIdx),'b')
xlabel('Time in s')
ylabel('Amplitude')
set(findall(gcf,'-property','FontSize'),'FontSize',12)
%Compute and plot the spectrum of the whole signal (whole duration) with Hz on the x-axis
%and dB on the y-axis. Plot only the positive frequencies, including the DC component
%(0 Hz).
[FFTPiano, frqAxis] = make_spectrum(Readpiano, Fs);
%Ser kun på de positive frekvenser.
SlutPosFrq = find(frqAxis<0);
PosFrqAxis = frqAxis(1:SlutPosFrq-1);
PosFFTPiano = FFTPiano(1:SlutPosFrq-1);
dBPosFFT = TodB(PosFFTPiano);

figure()
hold on
plot(PosFrqAxis,dBPosFFT,'g')
xlabel('Frequencys in Hz')
ylabel('Amplitude in db')
title('dB fourier spectrum of positive frequencys')

figure()
hold on 
plot(PosFrqAxis,abs(PosFFTPiano),'b')
xlabel('Frequencys in Hz')
ylabel('Amplitude')
title('Power spectrum of positive frequencys')

%130 Hz ser ud til at have størst amplitude, dermed regner jeg med at denne
%er den fundamentale frekvens. Kan også lige ses her:
[~,MaxIdx] = max(abs(PosFFTPiano));
FundaFrq = PosFrqAxis(MaxIdx);
%Laver et tone complex der kan lave klaver lyde.
N = 30;
An = 200;
%Finder længden af den nye frekvens vektor.
N0 = (2/dT);
%Allokere plads:
Harmonic_P = zeros(N0,1);
FrqPrSam = Fs/N0;
%Der står sin(), og der er intet faseskift, dermed er det hele imaginært.
%Finder pladserne hvori der skal stå noget på. 
HarmonicFunda = round(FundaFrq/FrqPrSam);
%Så ca. hver 1211. bin skal der være noget i.
%Dog kun op til Fs/2 da resten er negative frekvenser.
StartNega = round((Fs/2)*FrqPrSam);
%Laver frekvens akse.
delta_f = Fs/N0; %from slide 8 week 3.
%Positive part of frequency axis.
freqpos = 0:delta_f:(Fs-delta_f)/2;
%Negative part of frequency axis.
freqneg = -Fs/2:delta_f:-delta_f;
freqHarmonic = cat(2,freqpos,freqneg);
%Nu indsættes de positive frekvenser. Regner her med eksponentielt fald fra
%begyndelses amplituden.
for j=1:N
    Harmonic_P(HarmonicFunda*j) = 1i*An;
    Harmonic_P(length(Harmonic_P)-(HarmonicFunda*j)+2) = -Harmonic_P(HarmonicFunda*j);
end
InversFFTH_P = ifft(Harmonic_P);
figure
hold on
plot(imag(Harmonic_P),'r');
plot(imag(conj(Harmonic_P([1,end:-1:2]))),'g')
plot(imag(conj(Harmonic_P([1,end:-1:2])))-imag(Harmonic_P),'b')
legend('Original','Conjugeret','Diff')
%sound(InversFFTH_P*25,Fs)

%Og nu med phase:
Harmonic_PP = zeros(N0,1);
for j=1:N
    [RE,IMG] = pol2cart(j*pi/6,An*exp(-j*0.1));
    Harmonic_PP(HarmonicFunda*j) = RE+1i*IMG;
    Harmonic_PP(length(Harmonic_PP)-(HarmonicFunda*j)+2) = conj(Harmonic_PP(HarmonicFunda*j));
end

%Hiver phase og magnitude ud så de kan plottes.
[TH,R] = cart2pol(real(Harmonic_PP),imag(Harmonic_PP)); 
figure
tiledlayout('flow')
hold on
nexttile
plot(freqHarmonic,R,'r');
legend('Magnitude')
nexttile
plot(freqHarmonic,TH,'g');
legend('Phase')
InversFFTH_PP = ifft(Harmonic_PP);
sound(InversFFTH_PP*25,Fs)

%Spørg Bastian om denne her del
%Harmonic_PP(length(Harmonic_PP)-(HarmonicFunda*j)+2), hvorfor skal jeg
%bruge +2 for at det virker??.
%% 2 Some analytical work
%Dette må laves på et tidspunkt når jeg har læst mere i bogen.