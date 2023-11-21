%Function making an Elliptic Cauer filter using Matlabs own function 'ellip'


function [Bn,An] = Make_Cauer(n,fs,CuttOffFreqencies,ApproxType,RippledB)
                
    TypeFilt = Make_Type(ApproxType);
    NormCuttOffFreqencies = CuttOffFreqencies./(fs/2);
    [Bn, An] = ellip(n,RippledB,RippledB,NormCuttOffFreqencies,TypeFilt);

end