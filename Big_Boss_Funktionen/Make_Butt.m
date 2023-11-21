function [Bn, An] = Make_Butt(n,fs,CuttOffFreqencies,ApproxType)
    
    TypeFilt = Make_Type(ApproxType);
    NormCuttOffFreqencies = CuttOffFreqencies./(fs/2);
    [Bn, An] = butter(n,NormCuttOffFreqencies,TypeFilt);

end