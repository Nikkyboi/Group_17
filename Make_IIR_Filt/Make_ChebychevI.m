%Function making a ChebychevI filter using Matlabs own function 'cheby1'

function [Bn,An] = Make_ChebychevI(n,fs,CuttOffFreqencies,ApproxType,RippledB)
            
    TypeFilt = Make_Type(ApproxType);
    NormCuttOffFreqencies = CuttOffFreqencies./(fs/2);
    [Bn, An] = cheby1(n,RippledB,NormCuttOffFreqencies,TypeFilt);

end