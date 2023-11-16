function [Bn, An] = Make_Filt_IIR(n,fs,CuttOffFreqencies,ApproxType,RippledB,ApproxMethod)
    
    if ApproxMethod == "butterworth"
        [Bn, An] = Make_Butt(n,fs,CuttOffFreqencies,ApproxType);
    elseif ApproxMethod == "chebychevI"
        [Bn, An] = Make_ChebychevI(n,fs,CuttOffFreqencies,ApproxType,RippledB);
    elseif ApproxMethod == "chebychevII"
        [Bn, An] = Make_ChebychevII(n,fs,CuttOffFreqencies,ApproxType,RippledB);
    elseif ApproxMethod == "cauer"
        [Bn,An] = Make_Cauer(n,fs,CuttOffFreqencies,ApproxType,RippledB);
    end
        
        
end