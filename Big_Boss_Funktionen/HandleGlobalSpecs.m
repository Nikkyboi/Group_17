clc;
clear;
close all;

% easy to change variables
RippledB = 6;

%Read Global Specs
run('ReadGlobalSpecs.m');

% Read the .Wav file 
run('ReadFile.m');

% Generate Signal
run('GenerateSignal.m');

% Resample?
run('Resample.m');

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