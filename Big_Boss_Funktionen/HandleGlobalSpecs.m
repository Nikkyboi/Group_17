clc;
clear;
close all;

% easy to change variables
RippledB = 6;

%Read Global Specs
run('ReadGlobalSpecs.m');

if InputSignalType == "wav"
    % Read the .Wav file 
    run('ReadFile.m');

    % Resample?
    run('Resample.m');

elseif InputSignalType == "generate"
    % Generate Signal
    run('GenerateSignal.m');

else 
    warning('not valid InputSignalType \n');
    warning('not wav or generate \n');



% Frequency analyser
run('FrequencyAnalyser.m');

% Filter Design
run('FilterDesign.m');

% Filtering 
run('Filtering.m');

% Plotting 
run('Plotting.m');

% Store data/plots
run('StoreData');