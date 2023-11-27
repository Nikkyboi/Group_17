clc;
clear;
close all;
 
% easy to change variables
RippledB = 6; %Maximum allow ripple of pass and/or stopband. (for cauer this is the stopband ripple.)
xTimelimStart = 0; %Start of the plotting limit for time. see Plotting.m
xlimFrequencyStart = 0; %Start of the plotting limit for frequency. see Plotting.m

 
%Read Global Specs
run('ReadGlobalSpecs.m');

%Inputs: [GlobalSpecs.txt]
%Outputs: [GS, InputSignalType, FileName, TargetSamplingFrequency, TypeOfSignal, SamplingFrequency, TotalDuration, Periodicity, Frequencies_string,
%ToneFrequencies(4), SpectralRes, WindowType, Overlap, FilterType, FilterOrder, ApproxMethod, ApproxType, FrequenciesString, CutOffFrequencies, xLimTime,
%ylimAmplitude, XAxType, xlimFrequency, ylimSig] 
 
if InputSignalType == "wav"
    % Read the .Wav file 
    run('ReadFile.m');

%Inputs: [FileName]
%Outputs: [InputSignal, InputFs]
 
    % Resample?
    run('Resample.m');

%Inputs: [InputSignal, InputsFs]
%Outputs: [Signal, NewTimeAxis]
 
elseif InputSignalType == "generate"
    % Generate Signal
    run('GenerateSignal.m');

%Inputs: [TypeOfSignal, TargetSamplingFrequency, TotalDuration, ToneFrequencies, Periodicity]
%Outputs: [Signal, NewTimeAxis]
 
else 
    warning('not valid InputSignalType \n');
    warning('not wav or generate \n');
end
 
% Frequency analyser
run('FrequencyAnalyser.m');

%Inputs: [SamplingFrequency, TotalDuration, WindowType]
%Outputs: [Windowed_Signal, frequency_vec, Pos_Freq]
 
% Filter Design
run('FilterDesign.m');

%Inputs: [CutOffFrequencies, ApproxType, ApproxMethod, FilterOrder, WindowType, TargetSamplingFrequency, RippledB]
%Output: [Bn, An]

% Filtering 
run('Filtering.m');

%Inputs: [Bn, An,Signal]
%Outputs: [FilteredSignal]

% Plotting 
run('Plotting.m');

%Inputs: [XAxType, TimeAxis, YAxType, Signal, FilteredSignal, ylimEnd, XLimEnd, Bn, An, TargetSamplingFrequency]
%Outputs: [TimeSignalPlot.mat, FourierSpectrumPlot.mat, PoleZeroPlot.mat, MagnitudePhasePlot.mat, RealImaginaryPlot.mat]




