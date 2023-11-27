function [bn] = Make_Rect_Filt(n,fs,CuttOffFreqencies,ApproxType)
    %A function which outputs the feedforward coefficients of a FIR filter.
    %It takes the inputs: n which is the filter order. fs which is the
    %sampling frequency. CuttOffFreqencies which are the cut off
    %frequencies- ApproxType which is the type of filter, either lowpass
    %highpass, bandpass, or bandstop (as a string lp,hp,bp or bs).
    %It outputs the feedforward coefficients of the transferfunction, for a
    %filter using the rect windowing function. It uses the inbuild fir1
    %function to do this.
        NormCuttOffFreqencies = CuttOffFreqencies./(fs/2);
        bn = fir1(n-1,NormCuttOffFreqencies,ApproxType,rectwin(n));
        
end

