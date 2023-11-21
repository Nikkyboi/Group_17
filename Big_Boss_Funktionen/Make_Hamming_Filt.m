function [bn] = Make_Hamming_Filt(n,fs,CuttOffFreqencies,ApproxType)

        NormCuttOffFreqencies = CuttOffFreqencies./(fs/2);
        bn = fir1(n-1,NormCuttOffFreqencies,ApproxType,hamming(n));
        
end
