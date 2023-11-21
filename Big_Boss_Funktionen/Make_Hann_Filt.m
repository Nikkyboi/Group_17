function [bn] = Make_Hann_Filt(n,fs,CuttOffFreqencies,ApproxType)

        NormCuttOffFreqencies = CuttOffFreqencies./(fs/2);
        bn = fir1(n-1,NormCuttOffFreqencies,ApproxType,hann(n));
        
end
