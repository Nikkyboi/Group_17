function [Y, freq] = make_spectrum(signal, fs)
% This function takes the input time spectrum (signal) and converts it to frequency,
% with a correct frequency axis, made form the samplingfrequency fs.
% compute spectrum (note: it will be complex-valued).
Y = fft(signal);
% The FFT needs to be scaled in order to give a physically plausible scaling.
Y = Y/(length(Y));
% NOTE: If you do an IFFT, this scaling must NOT be done.
% We’ll get to this in the lecture. If you are only interested
% in the positive frequencies, you need to scale by <length(Y)/2>.
% frequency vector
delta_f = fs/length(Y); %from slide 8 week 3.
%Positive part of frequency axis.
freqpos = 0:delta_f:(fs-delta_f)/2;
%Negative part of frequency axis.
freqneg = -fs/2:delta_f:-delta_f;
% NOTE: The first element that comes out of the FFT is the DC offset
% (i.e., frequency 0). Each subsequent
% bin is spaced by the frequency resolution <delta_f> which you can
% calculate from the properties of the inpnut signal. Remember the highest
% frequency you can get in a digitized signal just below nyquest.
% %Concatates positive and negative frequencies.
freq = cat(2,freqpos,freqneg);
% convert into column vector (if required)
% eof
end

