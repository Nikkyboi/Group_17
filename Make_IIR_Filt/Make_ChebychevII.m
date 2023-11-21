%Function making a ChebychevI filter using Matlabs own function 'cheby2'

function [Bn,An] = Make_ChebychevII(n,fs,CuttOffFreqencies,ApproxType,RippledB)
            
    TypeFilt = Make_Type(ApproxType);
    NormCuttOffFreqencies = CuttOffFreqencies./(fs/2);
    [Bn, An] = cheby2(n,RippledB,NormCuttOffFreqencies,TypeFilt);

end