
if WindowType == "hann";
    fprintf('FilterType is IIR \n');
elseif WindowType == "hamming";
    fprintf('WindowType is hamming \n');
elseif WindowType == "rect";
    fprintf('WindowType is rect \n');
end
