% This will read the audio signal specified by the Global Specs, and store
% the Input signal and the frequency of that signal
[InputSignal, InputFs] = audioread(convertCharsToStrings(FileName));

% The audioread makes a row vector, so we flip it to a collomn vector.
InputSignal = InputSignal';