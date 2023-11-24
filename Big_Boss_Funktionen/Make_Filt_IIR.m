function [Bn, An] = Make_Filt_IIR(n,fs,CuttOffFreqencies,ApproxType,RippledB,ApproxMethod)
    %Checks which filter generation metod is used and outputs the
    %corresponing Bn and An coefficients of the transferfunction.
    %It uses the inputs n filter order, fs sampling frequency, 
    %CuttOffFreqencies which are the Cut off frequencies, Approxtype, which
    %is the type of filter (Lowpass, HighPass, Bandpass, Bandstop),
    %RippledB which is the allowed maximum ripple of the filter in the pass
    %and stop band, ApproxMetod which is butterworth, chebychev 1 or 2, or
    %cauer.
    if ApproxMethod == "butterworth"
        [Bn, An] = Make_Butt(n,fs,CuttOffFreqencies,ApproxType);
    elseif ApproxMethod == "chebychevI"
        [Bn, An] = Make_ChebychevI(n,fs,CuttOffFreqencies,ApproxType,RippledB);
    elseif ApproxMethod == "chebychevII"
        [Bn, An] = Make_ChebychevII(n,fs,CuttOffFreqencies,ApproxType,RippledB);
    elseif ApproxMethod == "cauer"
        [Bn,An] = Make_Cauer(n,fs,CuttOffFreqencies,ApproxType,RippledB);
    else 
        warning('Error in Make_Filt_IIR, method not specified, try butterworth, chebychevI, chebychevII or cauer');
    end
        
        
end