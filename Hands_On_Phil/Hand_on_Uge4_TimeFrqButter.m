%% Time, frequency and butterflies

%% Equivalence of linear and circular convolution
clear;
%Generate x(n) and h(n)
xn = rand([1 50]);
hn = rand([1 50]);
N = length(xn); % length of first vector
M = length(hn); % length of second vector
LengthConvout=N+M-1; % length of output vector (se slide 6)
% Erhm, zero_pad gør ikke dette pt. den tager fs og Tdur som argumenter,
% dermed giver det mening at "finde på" én Tdur og fs der giver længen af
% convolution produktet...
Tdur = LengthConvout-1; %Zeropad vil gerne have nul med i intervallet, dermed skal man minus med 1.
fs = 1;
xnzerop = zero_pad(Tdur,xn,fs);
hnzerop = zero_pad(Tdur,hn,fs);
%Bruger laver convolution i frekvens domænet. se slide 5 uge 4.
%Laver begge signaler til frekvens domæne.
fftxn = fft(xnzerop);
ffthn = fft(hnzerop);
fftConv = fftxn.*ffthn;%pointwise multiplication.
%Laver den til tidsdomæne igen via invers fourier.
ConvxnhnFreq = ifft(fftConv);
%Gør det samme med conv funktionen, altså bare laver convolution i
%tidsdomænet.
Convxnhn = conv(xn,hn);
%Kigger nu på "summed absolute difference of the two results"
AbsdiffConv = sum(abs(ConvxnhnFreq)-abs(Convxnhn));
disp(['Sum of absolut differences is ',num2str(AbsdiffConv)]);
%Very small, which means the two methods are equivalent. 

%• Compare your implemented algorithm in its performance with the conv function provided
%by Matlab. Use different combinations of input vectors (e.g., a short click together with a
%speech signal, or a speech signal together with the impulse response of a church - NOTE:
%remember the sampling frequencies might differ! In this case, use resample() to match
%the sampling frequencies).
%Får man ikke noget ud af at gøre. Kan se fra Sum of absolut differences at
%de er ækvivalente.

%% 2 Convolution theorem applied to CORONA-numbers
clear;
%Better than just looking at what the newspapers show in terms of CORONA numbers, we can as
%well just get the raw data and process them ourselves. Let’s check out if the convolution theorem
%also can be applied to the count of positive detections of a lipid based nano particle.

%Smoothening
%Generate a moving average filter of order N and convolve its impulse response with the latest
%numbers of the pandemic in all Denmark. Please implement the solution in a way so you can
%easily change the order of your filter:
%loader data.
% load the data
dat = readtable('C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\22051_CORONA_20200920\dat\Municipality_cases_time_series.csv');

% let's check out what it looks like.
dat(1,:);
%Select the column number for the municipality your are interested in. We'll also summ all up to get the overall over DK.
% municipality of interest (moi)
dat_moi = dat.Copenhagen;   % for Copenhagen

% all DK
dat_dk = sum(dat{:,[2:end]},2);

% Let's look at it in a plot
plot(dat.date_sample,dat_moi)
xlabel('date of sample')
ylabel(['nr cases'])

% add all DK data on top
hold on;
plot(dat.date_sample,dat_dk,'r')

% add a legend
legend({'Municipality of interest','DK wide'})
%• Define the order of the filter and based on that generate the impulse response (IR)
%Husk moving average er bare et sampled square, der er N+1 langt og 1/(N+1) højt.
N = 100; %order of filter
h = ones(1,N+1)*(1/(N+1)); %Impulse respons.
%• Convolve the IR with the raw data
dat_moi_conv = conv(dat_moi,h);
dat_dk_conv = conv(dat_dk,h);
%• Plot the raw data and the data filtered with the moving average filter on top of each other.
figure()
tiledlayout('flow')
nexttile
hold on
plot(dat.date_sample,dat_dk,'r')
plot(dat.date_sample,dat_dk_conv(1:length(dat_dk)),'b')
title(['DK wide original vs. moving average of order ',num2str(N),' from conv'])
legend('Orginal data','Moving average filtered data')
xlabel('date of sample')
ylabel(['nr cases'])
hold off
nexttile
hold on
plot(dat.date_sample,dat_moi,'r')
plot(dat.date_sample,dat_moi_conv(1:length(dat_dk)),'b')
title(['Municipality of interest vs. moving average of order ',num2str(N),' from conv'])
legend('Orginal data','Moving average filtered data')
xlabel('date of sample')
ylabel(['nr cases'])
hold off
%• Use averages over three days, one week and four weeks. 
%Bare ændre N til 2, 6, 27. 
%Estimate the shift you observe in the filtered signal compared to the raw data as a function
%of the order of the filter. 

%Hvis det antages at maks værdierne ikke ændre sig efter filtering, kan det
%gøres således. Gør det kun for, municipality of interest.
[Max,MaxI] = max(dat_moi(1:50));
[MaxAverage,MaxAverageI] = max(dat_moi_conv);
%Vi ved at den absolutte forskel mellem disse må være mængden som den
%langsommeste (forsinkede), skal forsinkes med. I dette tilfælde er det 
%Running average der er den langsomme. 

%Laver en vektor med zeros således at den moving average vektoren kan
%rykkes tilbage. 
shift = abs(MaxI-MaxAverageI);
Shift_dat_moi_conv = cat(1,dat_moi_conv((shift+1):end), zeros(shift,1));
%Nyt plot med dette:
figure()
hold on
plot(dat.date_sample,dat_moi,'r')
plot(Shift_dat_moi_conv,'b')
title(['Municipality of interest vs. moving average of order (shifted)',num2str(N)])
legend('Orginal data','Moving average filtered data (shifted)')
xlabel('date of sample')
ylabel(['nr cases'])
hold off

%Laver en figur at sammenligne med, til næste afsnit.
figure()
hold on
plot(dat.date_sample,dat_moi,'r')
plot(dat.date_sample,dat_moi_conv(1:length(dat_moi)),'b')
title(['Municipality of interest vs. moving average of order',num2str(N),' from conv'])
legend('Orginal data','Moving average filtered data')
xlabel('date of sample')
ylabel(['nr cases'])
hold off

%Dette er én måde at gører det på. En anden er at se på fase skift fra
%filteret, dog ikke helt sikker på hvordan man benytter det i praksis.
%% Sammenhæng mellem N og forsinkelse i emperisk forstand.
run Side_Script_week_4.m

%fra sammenhængen ovenover kan det ses at shift er ca. lig N-7, så jo
%højrere order, jo højrere index/time shift.

%Spørgsmål til denne her:
%How can the resulting delay be predicted?
%Ud fra den emperiske sammenhæng måske, eller noget med faseskift af
%filteret. Man kunne evt. kigge på filteret i kontinuert tid eller noget.
%Er ikke helt sikker. Man kan måske fasesskifte i frekvens domænet???
%% 2.2 Filtering by multiplication
clearvars -EXCEPT N;
%Knowing that we also can do the processing in the frequency domain, this is probably what we
%want to do. So let’s try to replicate the results of the previous session - just by operating in the
%frequency domain rather than the time domain:

%N = 27; %Kan også ændre N her hvis ikke man vil have det andet kode kører
%først.
%Loader data igen.
dat = readtable('C:\Users\phili\OneDrive\Dokumenter\Signaler og lineære systemer i diskret tid\Hands-on\22051_CORONA_20200920\dat\Municipality_cases_time_series.csv');
%Select the column number for the municipality your are interested in. We'll also summ all up to get the overall over DK.
% municipality of interest (moi)
dat_moi = dat.Copenhagen;   % for Copenhagen
% all DK
dat_dk = sum(dat{:,[2:end]},2);

%• Define the order of the filter and based on that generate the impulse response (IR)

h = ones(1,N+1)*(1/(N+1)); %Impulse respons.

%• Transform the raw data and the IR into the frequency domain
%Skal huske at zero-pad her.

h_zero = zero_pad2(dat_moi,h)';
dat_moi_zero = zero_pad2(h,dat_moi)';
H = fft(h_zero);
fft_dat_moi = fft(dat_moi_zero);

%• Multiply the time series and inverse Fourier transform to get a time series

dat_moi_filt_frq = fft_dat_moi.*H; %pointwise multiplication.
dat_moi_filt = ifft(dat_moi_filt_frq); %invers fouirer.

%• Plot the raw data and the data filtered with the moving average filter on top of each other

figure()
hold on
plot(dat.date_sample,dat_moi,'r')
plot(dat.date_sample,dat_moi_filt(1:length(dat_dk)),'b')
title(['Municipality of interest vs. moving average of order',num2str(N),' From freq'])
legend('Orginal data','Moving average filtered data')
xlabel('date of sample')
ylabel(['nr cases'])
hold off

%Ser at de er ens også med sum of squared distances:
dat_moi_conv = conv(dat_moi,h);
SumSqDist = sum((abs(dat_moi_conv)-abs(dat_moi_filt)).^2);
%Det ses at SumSqDist er forsvindende lille.

%• Use averages over three days, one week and four weeks
%Tror jeg ikke man får så meget ud af, men man kan selfølgelig kører koden
%flere gange og ændre N til 3, 6 og 27. SumSqDist ændre sig ikke, så de er
%ækvivalente.

%Hopefully you get the same picture as when operating in the time domain.
%• Compare the spectra of the time series before and after processing

%Plotter spektrum før processering og efterfølgende.
%Først laves spektrumerne. 1/dag. Altså 1 sample pr. dag, fs er dermed 1.
fs = 1;
[Spek_dat_moi, freq_dat_moi] = make_spectrum(dat_moi, fs);
[Spek_dat_moi_filt, freq_dat_moi_filt] = make_spectrum(dat_moi_filt, fs);
%Plotter power spektrum vs hinanden først.
figure()
tiledlayout('flow')
nexttile
plot(freq_dat_moi,TodB(Spek_dat_moi),'r')
xlabel('Frekvens i sample pr. dag')
ylabel('Magnitude i dB')
title('Frekvens spektrum for originalt signal')
nexttile
plot(freq_dat_moi_filt,TodB(Spek_dat_moi_filt),'g')
xlabel('Frekvens i sample pr. dag')
ylabel('Magnitude i dB')
title('Frekvens spektrum for filteret signal')

%Plotter phase.

%• How can this result be explained?

%Ikke sikker på hvad der helt præcist menes her. Må stille spørgsmål næste
%gang. Altså vi ganger pointwise med en sinc???.

%• How is the frequency-specific time delay caused by filtering encoded?
%Det sker pga. phase skiftet ved filteret. Hvilket er lidt mærkeligt da det
%ellers ser rimlig linært ud. Men det er det så ikke. Men altså
%faseskift=time delay, dermed og det ses at det stiger, dermed vil højere
%frekvenser blive mere time delayed. Det ses fra det længere nede at phasen
%ikke stiger linært, dermed er time delay ikke konstant for alle
%frekvenser. Dermed vil forskellige frekvenser delays med forskellige
%mængder.

[H_spek, freq_H] = make_spectrum(h_zero, fs);
%Plotter phase af H. for at gøre klart.
figure()
tiledlayout('flow')
nexttile
plot(freq_H,abs(H_spek),'b')
xlabel('Frekvens i sample pr. dag')
ylabel('Absolut magnitude')
title('Power spektrum of H(omega)')

nexttile
plot(freq_H,angle(H_spek),'g')
xlabel('Frekvens i sample pr. dag')
ylabel('Phase')
title('Phase plot')


%Ser om fase stiger linært.
figure()
plot(cumsum(angle(H_spek(round(length(H)/2):end))))
title('Er faseskift linært?')
%Det gør det ikke, dermed vil der være artifakter fra dette.