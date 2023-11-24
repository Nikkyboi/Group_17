function [Bn,An] = Make_ChebychevII(n,fs,CuttOffFreqencies,ApproxType,RippledB)
    %Function to generate the
    %corresponing Bn and An coefficients of the transferfunction.
    %It uses the inputs n filter order, fs sampling frequency, 
    %CuttOffFreqencies which are the Cut off frequencies, Approxtype, which
    %is the type of filter (Lowpass, HighPass, Bandpass, Bandstop),
    %RippledB which is the allowed maximum ripple of the filter in the pass
    %and stop band. It outputs the filter coefficients of the corresponding
    %ChebychevII filter.   
    TypeFilt = Make_Type(ApproxType);
    NormCuttOffFreqencies = CuttOffFreqencies./(fs/2);
    [Bn, An] = cheby2(n,RippledB,NormCuttOffFreqencies,TypeFilt);

end