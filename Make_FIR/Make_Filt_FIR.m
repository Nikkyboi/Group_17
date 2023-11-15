function [Bn] = Make_Filt_FIR(n,fs,CuttOffFreqencies,ApproxType,WindowType)
    
    Type = Make_Type(ApproxType);
    if WindowType == 'rect'
        Bn = Make_Rect_Filt(n,fs,CuttOffFreqencies,Type);
    elseif WindowType == 'hann'
        Bn = Make_Hann_Filt(n,fs,CuttOffFreqencies,Type);
    elseif WindowType == 'hamming'
        Bn = Make_Hann_Filt(n,fs,CuttOffFreqencies,Type);
    else 
        error(WindowType,'Not supported in this version, try using hann, hamming or rect')
    end
    
        
end