function [bn] = Make_Rect_Filt(n,fs,CuttOffFreqencies,ApproxType)

        NormCuttOffFreqencies = CuttOffFreqencies./(fs/2);
        bn = fir1(n-1,NormCuttOffFreqencies,ApproxType,rectwin(n));
        
end

