function [dBScale] = TodB(InVec)
%This function converst the input vector to dB
dBScale = 20*log10(abs(InVec));
end

