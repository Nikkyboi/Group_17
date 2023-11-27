
%If statement to check which filter should be made.
if FilterType == "IIR" || FilterType == "iir"
    fprintf('FilterType is IIR \n');
    %Function to make the Bn and An coefficients of the transferfunction.
    [Bn, An] = Make_Filt_IIR(FilterOrder,TargetSamplingFrequency,CutOffFrequencies,ApproxType,RippledB,ApproxMethod);
elseif FilterType == "FIR" || FilterType == "fir"
    fprintf('FilterType is FIR \n');
    %Function to make the Bn and An coefficients of the transferfunction.
    [Bn] = Make_Filt_FIR(FilterOrder,TargetSamplingFrequency,CutOffFrequencies,ApproxType,WindowType);
     An = 1; %Theres no feedback, that's why An equals 1.

else
    warning('Not valid FilterType. Try IIR or FIR \n');

end

