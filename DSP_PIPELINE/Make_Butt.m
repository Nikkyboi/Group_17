function [Bn, An] = Make_Butt(n,fs,CuttOffFreqencies,ApproxType)
    %Function to generate the
    %corresponing Bn and An coefficients of the transferfunction.
    %It uses the inputs n filter order, fs sampling frequency, 
    %CuttOffFreqencies which are the Cut off frequencies, Approxtype, which
    %is the type of filter (Lowpass, HighPass, Bandpass, Bandstop), it then
    %calculates the butterworth filter coefficients for the
    %transferfunction.
    TypeFilt = Make_Type(ApproxType);
    NormCuttOffFreqencies = CuttOffFreqencies./(fs/2);
    [Bn, An] = butter(n,NormCuttOffFreqencies,TypeFilt);

end