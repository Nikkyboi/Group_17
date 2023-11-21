
if FilterType == "IIR"
    fprintf('FilterType is IIR \n');
    [Bn, An] = Make_Filt_IIR(FilterOrder,TargetSamplingFrequency,CutOffFrequencies,ApproxType,RippledB,ApproxMethod);
elseif FilterType == "FIR"
    fprintf('FilterType is FIR \n');
    [Bn] = Make_Filt_FIR(FilterOrder,TargetSamplingFrequency,CutOffFrequencies,ApproxType,WindowType);
     An = 1; %Theres no feedback, that's why An equals 1.

else
    warning('Not valid FilterType. Try IIR or FIR \n');

end

