
if FilterType == "IIR";
    fprintf('FilterType is IIR \n');
    [Bn, An] = Make_Filt_IIR(FilterOrder,TargetSamplingFrequency,CutOffFrequencies,ApproxType,RippledB,ApproxMethod);
elseif FilterType == "FIR";
    fprintf('FilterType is FIR \n');
    [Bn] = Make_Filt_FIR(FilterOrder,TargetSamplingFrequency,CutOffFrequencies,ApproxType,WindowType);
     An = 1; %Der er intet feedback, derfor er An lig 1.
end

