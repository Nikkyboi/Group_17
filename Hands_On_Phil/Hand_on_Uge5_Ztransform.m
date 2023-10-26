%% 1 Simple filters

%% 1.1 Impulse responses, transfer functions
%Running sum filteret kan beskrives med en picewise function som i opgave
%beskrivelsen. Det er i virkeligheden bare et langt delta pulse train.
%Dermed kan man nemt z-transformere det via de transform pairs der er i
%tabellen på side 231 i tabel 4.3. Der er også et billede i denne mappe.

%Den generelle z transformation kan ses fra filen ZTransSumFilt.jpg. Det er
%lavet i hånden og via tabel 4.3. Her ser vi at det bare er
%z^-0+z^-1+z^-2+z^-3 ... z^-N. Altså en rimlig dejlig ztransformation.

%Find the poles and zeros of the filters with order 3 and 5 by calculating the roots of the
%corresponding polynomial with the root function

%Se evt. maple fil med løsningen.

%Deklarere variable:
N = [3 5];

ZerosRun3Coef = ones(1,(N(1))+1);
ZerosRun5Coef = ones(1,(N(2))+1);

PolesRun3Coef = zeros(1,(N(1))+1);
PolesRun5Coef = zeros(1,(N(2))+1);

PolesRun3Coef(1) = 1;
PolesRun5Coef(1) = 1;
%For at det skal gøres korrekt mht. roots, skal man udtrykke polynomiet på
%en hvis måde. Se nærmere her:
%doc roots %(Fjern procenttegn for at se mere.)

ZerosRun3 = roots(ZerosRun3Coef);
ZerosRun5 = roots(ZerosRun5Coef);

PolesRun3 = roots(PolesRun3Coef);
PolesRun5 = roots(PolesRun5Coef);

%Plot the poles, the zeros and the frequency response of the filters using zplane and freqz
figure()
subplot(2,1,1);
zplane(ZerosRun3,PolesRun3)
grid
title('Poles and Zeros for N = 3')
subplot(2,1,2);
zplane(ZerosRun5,PolesRun5)
grid
title('Poles and Zeros for N = 5')

%For at plotte frekvens responset med freqz, skal vi først udtrykke 
%filteret i An og Bn coefficienter, se side 213. eq. 4.5 i Holten.
%Hvis vi ser i Maple, så ligner det sku lidt at vi kun har at gøre med
%feedforward komponenter Bz. Og det kan ses at alle Bk*z^(-n) har koefficienter på 1.
%Dermed kan vi plotte med freqz. i Ak er der kun 1 koponent A1 = 1.
BkRun3 = ZerosRun3Coef;
BkRun5 = ZerosRun5Coef;
AkRun3 = PolesRun3Coef;
AkRun5 = PolesRun5Coef;


figure()
freqz(BkRun3,AkRun3)
grid
title('Freqency response for N = 3, running sum')
figure()
freqz(BkRun5,AkRun5)
grid
title('Freqency response for N = 5, running sum')

%Tjekker om freqz gør det korrekt.
n = linspace(0,pi,512);
UnitCirc = exp(1i.*n);
%Finder magnitude først.
%Finder afstand fra hver pol. Denne er dog 1, så det droppes(Alle poler er på positionen 0).
%Finder afstand fra hver zero.

for i = 1:length(ZerosRun3)
    for j = 1:length(n)
        Rel(j) = real(ZerosRun3(i))-real(UnitCirc(j));
        im(j) = imag(ZerosRun3(i))-imag(UnitCirc(j));
        Dist(i,j) = sqrt(Rel(j)^2+im(j)^2);
    end
end

%Vi husker her at produktet mellem magnituderne af hvert zero giver os den
%samlede. Hvis det var fase skulle de summes istedet.
SlutMag = Dist(1,:).*Dist(2,:).*Dist(3,:);

%Laver fase delen for zeros:
for i = 1:length(ZerosRun3)
    for j = 1:length(n)
        PhaseZero(i,j) = angle(UnitCirc(j)-ZerosRun3(i));
    end
end

%Laver fase delen for poles:
for i = 1:length(PolesRun3)
    for j = 1:length(n)
        PhasePol(i,j) = angle(UnitCirc(j)-PolesRun3(i));
    end
end

TestMag = TodB(SlutMag);
nplot = n./max(n);%Normalizere range så den går fra 0 til 1.
figure()
tiledlayout('flow')
nexttile
plot(nplot,TestMag,'r')
xlabel('Frekvens i radianer (normaliseret)')
ylabel('Magnitude i dB')
ylim([-40 20])
xlim([0 1])
title('Test af magnitude plot')

%Summer fase sammen.
PhaseZero = sum(PhaseZero,1).*(180/pi); %Konvertere til grader.
PhasePol = sum(PhasePol,1).*(180/pi);

%Samlet fase er Zeros fase minus poles fase.
Phaseslut = PhaseZero-PhasePol;

nexttile
plot(nplot,Phaseslut)
xlabel('Frekvens i radianer (normaliseret)')
ylabel('Fase i grader')
ylim([-532 180])
xlim([0 1])
title('Test af fase')

%Det kan ses at det passer bortset fra at vi kun har essencial fase
%diskontinuiteter, mens den første har begge. Koden der tjekker her er for
%N=3 filteret.

%% Laver section da det andet plotter for meget allerede.
%What happens to the frequency response when considering a moving average rather than
%a running sum? Recall, that the impulse response of the moving average hMA(n) is the
%impulse response of the running sum normalized by the length of the impulse response
%N0 = N + 1:

%Moving average er vitterligt bare det samme, men divideret med N+1.
%Dermed har alle z koeficienterne bare magnitude 1/(N+1). Benytter bare
%freqz til at lave det. Alle coeficienter for Bk er bare 1/(N+1), og Ak er
%igen bare 1, for A0 og der er ikke andre.
RunningAverage3Bk = 1/(length(BkRun3)+1).*BkRun3;
RunningAverage5Bk = 1/(length(BkRun5)+1).*BkRun5;
%Ak er det samme, husker vi her.
figure()
freqz(RunningAverage3Bk,AkRun3)
grid
title('Freqency response for N = 3, running average')
figure()
freqz(RunningAverage5Bk,AkRun5)
grid
title('Freqency response for N = 5, running average')
%Some frequencies are heavily suppressed (attenuated) in these filters. Is there a simple way
%to enhance (that means to amplify) these frequencies rather than to attenuate them?
%Ja det er rimlig lige til. Man kan bare flytte zeroet længere væk, altså
%ud i det komplekse plan. Da afstanden mellem enhedscirklen og et zero
%svare til mængden af attenuation/amplification, så vil større afstand
%giver bedre amplification. Det er også muligt at rykke polerne tætter på
%zerosene på enhedscirklen, amp/attenuation for poler er bare 1/(afstanden
%mellem pol og enhedscirkel), hvis de dermed er tæt på, så er attenuation
%ikke lige så slem.

%% Laver lige en section mere da denne er ok omfattende.
clear;
%Design a filter that blocks the normalized frequency of 0.1 by placing 4 zeros in the z-plane.
%Make sure the filter returns real-values outputs when fed with real-valued inputs by placing
%complex-conjugate pairs of poles and zeros.
%Her kan vi placere et zero på denne frekvens plads for at attenuate den.

Frq = 0.1*pi;
%Første zero er dermed:
FirstZero = exp(1i*Frq);
%Skal også have et på den komplekst konjugeredes plads.
SecondZero = conj(FirstZero);
%Hvis det skal være causal, skal der være mindst lige så mange poler som
%zeros. Dermed kan man evt. bare placere 2 poler i 0. z^2. Så er der
%"Mindst" lige mange.

%En z-transformation for dette er:
% Filtz = (z-0.9511+0.309*i)*(z-0.9511-0.309*i)/z^2

%""""A right-sided system is causal if the number of poles is greater than or equal to the
%number of zeros.""""
%For at benytte freqz skal man dog udtrykke det på en lidt sjov måde. Altså
%i form af z^(-1)'er.

%Hvis vi ser på Design Flit afsnittet fra maple filen kaldet
%Maple_Udledning_Af_Uge5.mw, så er Bk koefficenterne klare:
Bk = [0 1 -1.9022 1.00007221];
Ak = [1 0 0 0];
figure()
freqz(Bk,Ak)
grid
title('Freqency response for filter with attenuation at 0.1')
%Dette var dog kun for 2 zeros. Vi kan sætte to andre zeros reletivt tæt
%på, men måske med en længde på 0.5 istedet. Og så 4 eller flere poler ved
%0.
ThirdZero = FirstZero*0.5;
FourthZero = conj(ThirdZero);

%En z-transformation for dette er:
% Filtz =
% (z-0.9511+0.309*i)*(z-0.9511-0.309*i)*(z-0.4755+0.1545i)*(z-0.4755-0.1545i)/z^4


%Vi ser igen fra maple at vores bk koefficienter er:
[TestBk4, TestAk4] = zp2tf([FirstZero SecondZero ThirdZero FourthZero]',[0 0 0 0]',1); %Forsøger en anden funktion og ser om det kan passe.
%Linjen ovenover ser ud til at virke.
Bk4 = [1 -2.85 3.05 -1.42 0.25];
%Og Ak er:
Ak4 = [1 0 0 0 0];
figure()
freqz(Bk4,Ak4)
grid
title('Freqency response for filter with attenuation at 0.1 with 4 zeros')


%% Ny opgave ny section:
%Add to the previous filter 4 poles lying on a circle with a radius R < 1 (you chose R) at
%angles identical to the angles of the zeros. How does the frequency response change when
%you increase R and when R approaches 1?

%Sætter polerne meget tæt på zeros.
FirstPol = FirstZero*0.9;
SecondPol = conj(FirstPol);
%Trejde og fjerde kan man lave ved bare at sætte begge i anden. Et forslag
%til en z-transformation kan ses herunder.
%FiltZtransformation = 
%((z-FirstZero)*(z-SecondZero)*(z-ThirdZero)*(z-FourthZero))/((z-FirstPol)^(2)*(z-SecondPol)^(2))
%Fandt efter lang tid en funktion man kunne benytte, nemlig zp2tf, den
%laver zeros og poles til koefficienter Bk og Ak. 
%Denne funktion virker dog kun når man specificere gain, men denne har vi
%ikke specificeret endnu. 
%Dermed benyttes en anden metode. Kig i maple
%under afsnittet Design filt 4 zero 4 pole. Her divideres tæller og nævner
%hver for sig med den højste power i polynomiet, derefter partiel fraction
%expandes den. Lad os se om det funger.
Bk4poles = [1 -2.85 3.06 -1.42 0.25];
Ak4poles = [1 -3.42 4.5 -2.77 0.656];

[TestBk4poles, TestAk4poles] = zp2tf([FirstZero SecondZero ThirdZero FourthZero]',[FirstPol SecondPol FirstPol SecondPol]',1);
%Ser igen ud til at gører det korrekt, jeg har bare lavet dårlige poles i
%guess.
%kan evt. testes herunder:
AbsDiffBk4poles = sum(abs(TestBk4poles)-abs(Bk4poles));
AbsDiffAk4poles = sum(abs(TestAk4poles)-abs(Ak4poles));
%Se evt. maple for yderligere detajler.
figure()
freqz(Bk4poles,Ak4poles)
grid
title('Freqency response for filter with attenuation at 0.1 with 4 zeros and poles')

%Tjekker at det nu også passer via z-plan.
figure()
tiledlayout(2,1)
nexttile
zplane(Bk4poles,Ak4poles)
grid
title('Test om hvorvidt poler og zeros ligger korrekt.')
nexttile
zplane([FirstZero SecondZero ThirdZero FourthZero]',[FirstPol SecondPol FirstPol SecondPol]')
grid
title('Korrekte poles og zeros')
%Jeg har lavet et ikke realiserbart filter fordi jeg var doven. Jeg tror
%ikke at det er muligt at have repeated poles medmindre de befinder sig i
%0, dermed må jeg tage det med til næste gang.

%% 1.2 The power of poles and zeros

clear;
%Place poles and zeros such that you generate a 
%low-pass filter (i.e., passing the low frequencies)

%Afstanden fra enhedscirklen til zeros er magnituden, eller 1/afstand for
%poles er magnituden. Man kan dermed "bare" placere zeros ved de høje
%frekveser og poles ved de lave frekvenser. 
%Hvis man placere zeros ved de høje frekvser (men tæt på enhedscirklen), så
%bliver afstanden her kort, og dermed bliver disse frekvenser dæmpet. Man
%kan også placere poles, tæt på enhedscirklen (gerne inden i hvis filteret
%skal være stabilt), og demed bliver 1/afstanden høj og frekvenserne her
%forstærkes. 
%Fremover benyttes zp2tf da den er nem at bruge ift. maple udregninger osv.

%Laver zeros ved de "høje" frekvenser:
HighFreq = pi/2:pi/6:pi;
ZerosUconj = exp(1i.*HighFreq)*2; %Giver et bedre respons når man ganger med 2. Prøv at undlade for at se hvad der sker.
%Generer de konjugerede.
ZerosConj = conj(ZerosUconj);
Zeros = [ZerosUconj ZerosConj]'; %zplane bruger colum vektore.

%Laver poles ved de "lave" frekvenser, men inde i enhedscirklen.
LowFreq = 0:pi/6:pi/2;
PolesUconj = exp(1i.*LowFreq)*0.7;
%Generer de konjugerede.
PolesConj = conj(PolesUconj);
%Sætter sammen lige som tidligere.
Poles = [PolesUconj PolesConj]';
%Plotter dem først inden at vi laver responset.
figure()
zplane(Zeros,Poles)
grid
title('Poles og zeros for lavpass')
%Plotter responset, men først skal vi udregne Bk og Ak. Det gøres via
%zp2tf.
[BkLow,AkLow] = zp2tf(Zeros,Poles,1);
figure()
freqz(BkLow,AkLow)
grid
title('Freqency response for lav pass filteret')

%% Ny section til highpass
clearvars -EXCEPT BkLow AkLow
%Place poles and zeros such that you generate a 
%high-pass filter (i.e., passing the high frequencies)

%Gør det modsatte af før, altså vi kan næsten bare vende om på hvad der er
%zeros og poles. Eller måske blot vende rundt på Bk og Ak, da dette jo er
%det samme som 1/H(z). Dog ligger de tidligere zeros på enhedscirklen,
%hvilket er et no-go for poles, dermed kan vi ikke bare vende rundt, da
%filteret ikke længere ville være stabilt.
%Kopiere bare koden fra før og ændre lidt på poles og zeros.

%Laver poles ved de "høje" frekvenser, men inde i enhedscirklen:
HighFreq = pi/2:pi/6:pi;
PolesUconj = exp(1i.*HighFreq)*0.7;
%Generer de konjugerede.
PolesConj = conj(PolesUconj);
Poles = [PolesUconj PolesConj]'; % '<-da zplane bruger colum vektore.

%Laver zeros ved de "lave" frekvenser.
LowFreq = 0:pi/6:pi/2;
ZerosUconj = exp(1i.*LowFreq)*2; %Bedre respons hvis man ganger med 2.
%Generer de konjugerede.
ZerosConj = conj(ZerosUconj);
%Sætter sammen lige som tidligere.
Zeros = [ZerosUconj ZerosConj]';
%Plotter dem først inden at vi laver responset.
figure()
zplane(Zeros,Poles)
grid
title('Poles og zeros for Highpass')
%Plotter responset, men først skal vi udregne Bk og Ak. Det gøres via
%zp2tf.
[BkHigh,AkHigh] = zp2tf(Zeros,Poles,1);
figure()
freqz(BkHigh,AkHigh)
grid
title('Freqency response for high pass filteret')
%Man kunne også bare vende rundt på Bk og Ak fra den tidligere opgave. For
%at udgå de spring man ser i responset kunne man rykke zeros enten ud af
%enhedscirklen eller ind i den, i modsætning til lige på den.

%% Ny opgave ny section.
clearvars -EXCEPT BkLow AkLow BkHigh AkHigh
%Design a filter having five poles and zeros that passes 
%all the frequencies (i.e., an all-pass filter).


%Hvilke punker i det komplekse plan, har alle afstanden 1 til
%enhedscirklen?, det har punktet 0 og ingen andre. Dermed skal alle 5 poler
%være ved nul (z^5) og alle zeros være ved nul. Altså bare H(z)=z^5/z^5.


%Denne opgave er lavet om, via side 314 i Holten section 5.7.3. Faktisk
%mest én fra 5.7.4 da der er mere end 4 poles og zeros.

%Bruger fremgangsmåden fra tidligere.
%Laver poles:
PolesUconj = [0.7*exp(1i*pi*(1/4)) 0.2*exp(1i*pi*(1/8))];
PolesReal = 0.5;
PolesConj = conj(PolesUconj);
Poles = [PolesReal PolesUconj PolesConj]';
%Laver zeros
Zeros = (1./Poles);

%Plotter dem:
figure()
zplane(Zeros,Poles)
grid
title('Poles og zeros for All pass')
%Ikke så spændende når alle ligger i nul.
%Laver Bk og Ak og derefter tegnes responset.
%Siden at der står z^5/z^5 så er resultatet 1. Dermed er Bk = 1 og Ak = 1.
%Eller med fremgangsmåden fra før:
[BkAll,AkAll] = zp2tf(Zeros,Poles,prod(Poles));
figure()
freqz(BkAll,AkAll) %Det samme som bare 1,1 som jo netop er 1/1, altså 1.
grid
title('Freqency response for all pass filteret')

[h,w] = freqz(BkAll,AkAll,512);
SumH = sum(abs(TodB(h)));
%Selvom det ligner at der er diskontinuiterer er det bare en artifakt. Det
%kan ses at hvis alle amplituder summes sammen, mht dB, så giver det
%nærmest nul. Dermed forstærkes alle frekvenser lige meget, nemlig med 0 dB
%(0 dB = 1). Dermed har vi et allpass filter.

%% Ny section ny opgave 
clearvars -EXCEPT BkLow AkLow BkHigh AkHigh BkAll AkAll
%Generate a sinusoid at some sampling frequency and pass it through your filters. 
%Plot the original signal and the resulting signal in the time domain. 
%What can you observe?

%Den skipper vi, da all pass filteret fra før er et trivelt filter der
%passerer alt. Man får bare det samme ud igen efterfølgende. Vi kunne have
%lavet et all-pass filter der ændrede på fasen, men det gad vi ikke.
%Hvis vi ser på side 314 i Holten under 5.7.3 ses det hvordan man kan lave
%et all-pass filter. Derudover ved jeg ikke hvor meget jeg får ud af de
%andre filter, men kan måske lave det på et andet tidspunkt.

%Nvm, har lavet én af opgaverne om. Så nu laver vi også denne. 
filename = ['C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\Sounds\Sax12.wav']; %Vælg lyd der skal spilles
[y,Fs] = audioread(filename); %Dette er hvis man ønsker at se andre signaler.
%Laver en sinuoid:
fs = 12000;
Tdur = 2;
fhz = 4000;
Amp = 1;
phase = 0;
[TVec,Sinus] = generate_sinusoid(Amp,fhz,phase,fs,Tdur);
%Konvertere til frekvens domæne.
[FFTSin, freqAxis] = make_spectrum(Sinus, fs);
%FFTSin = fft(Sinus); Denne linje var til at tjekke om der er forskel. Det
%er der, hvilket ikke er godt.
%Regner overføringsfunktioner.
[HLow, ~] = freqz(BkLow,AkLow,length(Sinus),'whole',fs); %Whole da vi også får negative frekvenser med i make_spectrum
[HHigh, ~] = freqz(BkHigh,AkHigh,length(Sinus),'whole',fs);
[HAll, ~] = freqz(BkAll,AkAll,length(Sinus),'whole',fs);


%Ganger sammen og tager tilbage til tidsdomænet.
SinLowF = HLow.*FFTSin';
SinHighF = HHigh.*FFTSin';
SinAllF = HAll.*FFTSin';

%Invers fourier:
SinLow = ifft(SinLowF);
SinHigh = ifft(SinHighF);
SinAll = ifft(SinAllF);

%Ser på den i et lille tidsinterval. 
figure()
hold on
plot(TVec(1:200),Sinus(1:200),'r')
plot(TVec(1:200),SinLow(1:200),'g')
plot(TVec(1:200),SinHigh(1:200),'b')
plot(TVec(1:200),SinAll(1:200),'m')
xlabel('Tid i s')
ylabel('Amplitude')
legend('Original Sin','Lowpass Sin','Highpass Sin','All-pass Sin')
title('Filtreret sinus')

%Pick some sound file of your choice, process it by the filter and listen to it using sound or
%soundsc (watch the volume!)
yfiltLow = filter(BkLow,AkLow,y);
yfiltHigh = filter(BkHigh,AkHigh,y);
yfiltAll = filter(BkAll,AkAll,y);
SoundToBePlayed = yfiltAll; %Vælg filter.

%sound(SoundToBePlayed/max(SoundToBePlayed),Fs) %Spil lyd.

%% Ny section for den aller sidste opgave i 1.2
%How do the suppressed frequencies depend on the chosen sampling frequency of the input
%signal?
%Altså man skal jo gerne være over nyquist, ellers ligner signalet slet
%ikke det man prøver at vise. Hvis man ikke er langt nok over, så får man
%et problem, i og med frekvenskomponenterne heller ikke bliver afspeljet
%ordenligt. Når man laver FFT plejer man at sige at den sidste positive
%frekvens er ved nyquist frekvensen. Hvis man ikke sampler nok, så falder
%denne, og frekvenserne der er højrer vil blive foldet tilbage oven i de
%andre, hvilket giver et dårligt billede. 
%Siden at højrer frekvenser end nyquist bliver foldet tilbage, vil effekten
%på signalet efter filtereringen afhænge af hvor grelt det her er. Man
%kunne evt. ende med at supresse nogle frekvenser der er høje, men som man
%ellers ønskede i signalet. 

%Spørg Bastian om hvordan det her helt præcist fungere.



%% 2 Making the room IIR 

%% 2.1 Bounce bounce . . .
clear;
%Se design FIR delay filt i maple, til denne uge.
%Her ses det at H(z) kan udtrykkes som 1+alpha*z^-delay. Dermed er b0 = 1,
%og anden koefficient = b(delay) = alpha. Vi kan se at der ikke divideres
%med noget, dermed er a0 = 1, og alle andre koefficienter lig 0.

%For at regne delay tror jeg dog man skal kende 
%længden af signalet  tidsmæssigt, ellers giver det ikke mengen mening. Så
%kan man finde delayet ved TDur/length(Sig) og derefter afrunde, da delay
%vidst kun giver mening som integer tal. Men altså det kan også være jeg
%tager fejl. (Tror det er korrekt.)

%Loader et vilkårligt signal ind.
filename = ['C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\Sounds\Sax12.wav']; %Vælg lyd der skal spilles
[y,Fs] = audioread(filename);
%Finder tidslængen af signalet. (1/Fs)*length(y)
Tdur = (1/Fs)*length(y); %I sekunder, hvis Fs er i Hz.
delayT = 0.5;
%Finder ud af ved hvilket index at delay optræder. Lidt bruteforced.
TAxis = 0:1/Fs:Tdur-1/Fs;
delayn = round(delayT*Fs);
%FIR filter delen:
alpha = 0.5;
bk = zeros(1,delayn+1); %+1<- da vi også gerne vil have b0 koefficienten med.
bk(1) = 1; %B0 sættes ind
bk(end) = alpha; %b_delay indsættes.
ak = zeros(1,length(bk));
ak(1) = 1;
%Viser sig jeg har ret, det giver ikke mening uden et signal.
figure()
freqz(bk,ak,length(y),'whole',Fs)
grid
[H,w] = freqz(bk,ak,length(y),'whole',Fs);
h = ifft(H);
%Potter h(n)
figure()
hold on
plot(TAxis,h);
title('h(n) over tid FIR')
xlabel('Tid i s')
ylabel('Amplitude')

%Kigger på zeros og poles: Kig kun hvis delay er tilpas lav.
%[z,p,k] = tf2zp(bk,ak);
%figure()
%zplane(z,p)
%grid
%title('Poles og zeros for FIR')

%IIR filter del:
%Se Example 4.23 på side 267 i Holten hvis der ønskes detaljer. Man kan
%benytte transformation tabellen og Y(z)/X(z)=H(z) til at finde H(z),
%derefter kan man finde koefficienterne ved inspektion.
%Vi ser at det er de samme som før, bortset fra at ak og bk er byttet
%rundt. Nu er ak = gamle bk og bk = gamle ak. Så vi bytter bare rundt.
bkIIR = ak;
akIIR = bk;
figure()
freqz(bkIIR,akIIR,length(y),'whole',Fs)
grid
[HIIR,wIIR] = freqz(bkIIR,akIIR,length(y),'whole',Fs);
hIIR = ifft(HIIR);
%Plotter h(n) for IIR.
figure()
hold on
plot(TAxis,hIIR);
title('h(n) over tid IIR')
xlabel('Tid i s')
ylabel('Amplitude')

%Kigger på zeros og poles: %Kun hvis delay er tilpass lav.
%[zIIR,pIIR,kIIR] = tf2zp(bkIIR,akIIR);
%figure()
%zplane(zIIR,pIIR)
%grid
%title('Poles og zeros for IIR')
%Nu kan man bare bruge conv eller circulær conv for at finde responset på
%y. 
OutputSigFIR = conv(y,h);
OutputSigIIR = conv(y,hIIR);

%Nu kan vi lytte til dem med sound.

%% 
Sound2BePlayed = OutputSigIIR;
%sound(Sound2BePlayed,Fs)