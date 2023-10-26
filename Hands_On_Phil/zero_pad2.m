function [SigTot] = zero_pad2(Sig,hn)
%Denne funktion tilføjer zeros således at hn er samme længde som convolutionen med signalet.
N = length(Sig);
M = length(hn);
ConvLength = (N+M)-1;
SigTot = zeros(1,ConvLength);
%Tilføjer signalet til zeros vektoren.
SigTot(1:length(hn)) = hn(1:end);


end