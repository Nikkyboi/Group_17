function [TimeVec,SignalVec] = generate_sinusoid(Amp,fhz,phase,fs,Tdur)
%Denne funktion laver et sinusoidalt signal, udfra 5 parametre, som her er
%beskrevet. Amp er amplituden af det genererede signal, fhz er frekvensen
%af signalet, phase er fasen på signalet i "multipels" af 2*pi, fs er
%sampling frekvensen, Tdur er tidslængden af signalet. Outputtet er først
%en tidsvektor, med en tilhørende signal vektor. tidsvektoren indeholder
%alle de korresponderende tidspunkter hvor der er genereret et signal
%punkt / blevet samplet.

%Først genereres en vektor med alle tidspunkterne.
%Finder størrelsen af tidsskridtne.
dT = 1/fs;
%Laver tidsvektor.
TimeVec = 0:dT:Tdur-dT;
%Generere signal.
SignalVec = Amp*sin(2*pi*fhz.*TimeVec+phase);


%Vend gerne tilbage til funktionen senere, da dannelsen af tidssvektoren
%kan være upræcis pga. afrundinger.


end

