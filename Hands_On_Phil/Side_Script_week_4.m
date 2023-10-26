%Side scrpit for week 4.

%% Her forsøges det at estimere tidsforsinkelsen som index som funktion af orderen af filteret N


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

Ni = 1:50;
for i = 1:50
%• Define the order of the filter and based on that generate the impulse response (IR)
%Husk moving average er bare et sampled square, der er N+1 langt og 1/(N+1) højt.
N2 = Ni(i); %order of filter
h = ones(1,N2+1)*(1/(N2+1)); %Impulse respons.
%• Convolve the IR with the raw data
dat_moi_conv = conv(dat_moi,h);
dat_dk_conv = conv(dat_dk,h);
%• Plot the raw data and the data filtered with the moving average filter on top of each other.
%• Use averages over three days, one week and four weeks. 
%Bare ændre N til 2, 6, 27. 
%Estimate the shift you observe in the filtered signal compared to the raw data as a function
%of the order of the filter. 

%Hvis det antages at maks værdierne ikke ændre sig efter filtering, kan det
%gøres således. Gør det kun for, municipality of interest.
[Max,MaxI] = max(dat_moi(1:100));
[MaxAverage,MaxAverageI] = max(dat_moi_conv(1:100));
%Vi ved at den absolutte forskel mellem disse må være mængden som den
%langsommeste (forsinkede), skal forsinkes med. I dette tilfælde er det 
%Running average der er den langsomme. 

%Laver en vektor med zeros således at den moving average vektoren kan
%rykkes tilbage. 
shift(N2) = abs(MaxI-MaxAverageI);
end

figure()
plot(Ni,shift,'g')
xlabel('order of filter N')
ylabel('Shift of indices')
title('Shift as a function of order N')
