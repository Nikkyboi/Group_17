% Making a function, that makes an IIR filter and gives the bn and an
% coefficients as output

function [Bn, An] = Make_Filt_IIR(n,fs,CuttOffFreqencies,ApproxType,RippledB,ApproxMethod)
    %This function takes 6 input (n, fs, CutOffFrequencies,ApproxType,RippledB,ApproxMethod) from global specs and outputs
    %the coefficients in order to make the filter. We have made butterworth, chebychevI,
    %chebychevII and cauer into other strings which Make_filt_IIR can use. 

    if ApproxMethod == "butterworth"
        [Bn, An] = Make_Butt(n,fs,CuttOffFreqencies,ApproxType); %RippledB does not exist in Butterworth
    elseif ApproxMethod == "chebychevI"
        [Bn, An] = Make_ChebychevI(n,fs,CuttOffFreqencies,ApproxType,RippledB);
    elseif ApproxMethod == "chebychevII"
        [Bn, An] = Make_ChebychevII(n,fs,CuttOffFreqencies,ApproxType,RippledB);
    elseif ApproxMethod == "cauer"
        [Bn,An] = Make_Cauer(n,fs,CuttOffFreqencies,ApproxType,RippledB);
    else
        error('Error in ApproxMethod, approximation type not recognized. Try "butterworth", "chebychevI","chebychevII" or "cauer"')
    end
        
        
end