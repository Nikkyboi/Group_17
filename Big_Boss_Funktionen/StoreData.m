% Time Signal Plot
load('TimeSignalPlot.mat'); % Loading the plot
saveas(gcf, 'TimeSignalPlot.png'); % Saveing the figure as a PNG file in current directory

% Fourier Spectrum Plot
load('FourierSpectrumPlot.mat'); % Loading the plot
saveas(gcf, 'FourierSpectrumPlot.png'); % Saveing the figure as a PNG file in current directory

% Poles and Zeros Plot
load('PoleZeroPlot.mat'); % Loading the plot
saveas(gcf, 'PoleZeroPlot.png'); % Saveing the figure as a PNG file in current directory

% Magnitude/Phase Plot
load('MagnitudePhasePlot.mat'); % Loading the plot
saveas(gcf, 'MagnitudePhasePlot.png'); % Saveing the figure as a PNG file in current directory

% Real Imaginary part Plot
load('RealImaginaryPlot.mat'); % Loading the plot
saveas(gcf, 'RealImaginaryPlot.png'); % Saveing the figure as a PNG file in current directory