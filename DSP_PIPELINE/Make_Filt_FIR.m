function [Bn] = Make_Filt_FIR(n,fs,CuttOffFreqencies,ApproxType,WindowType)
    %A function which outputs the feedforward coefficients of a FIR filter.
    %It takes the inputs: n which is the filter order. fs which is the
    %sampling frequency. CuttOffFreqencies which are the cut off
    %frequencies- ApproxType which is the type of filter, either lowpass
    %highpass, bandpass, or bandstop (as a string lp,hp,bp or bs).
    %Windowtype which is the type of windowing function used on the ideal
    %filter representation.
    Type = Make_Type(ApproxType);
    if WindowType == 'rect'
        Bn = Make_Rect_Filt(n,fs,CuttOffFreqencies,Type);
    elseif WindowType == 'hann'
        Bn = Make_Hann_Filt(n,fs,CuttOffFreqencies,Type);
    elseif WindowType == 'hamming'
        Bn = Make_Hamming_Filt(n,fs,CuttOffFreqencies,Type);
    else 
        error(WindowType,'Not supported in this version, try using hann, hamming or rect')
    end
    
        
end