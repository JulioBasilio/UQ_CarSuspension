clc
clear all
close all


rng(100,'twister')
uqlab

% Aceleration
ModelOpts.mFile = 'uq_suspension_acel';
% Force
%ModelOpts.mFile = 'uq_suspension_force';
myModel = uq_createModel(ModelOpts);


InputOpts.Marginals(1).Name = 'ks';  % stifness
InputOpts.Marginals(1).Type = 'Gamma';
InputOpts.Marginals(1).Parameters =  [15.731e3 4.641e3];

InputOpts.Marginals(2).Name = 'bs';  % damping
InputOpts.Marginals(2).Type = 'Gamma';
InputOpts.Marginals(2).Parameters = [1.001e3 295];

InputOpts.Marginals(3).Name = 'ms';  % mass
InputOpts.Marginals(3).Type = 'Gamma';
InputOpts.Marginals(3).Parameters = [398 118];

myInput = uq_createInput(InputOpts);

SobolOpts.Type = 'Sensitivity';
SobolOpts.Method = 'Sobol';
SobolOpts.Sobol.Order = 2;
SobolOpts.Sobol.SampleSize = 5e4;%5

mySobolAnalysisMC = uq_createAnalysis(SobolOpts);
mySobolResultsMC = mySobolAnalysisMC.Results;

uq_print(mySobolAnalysisMC)

SobolTotal = [...
    mySobolResultsMC.Total ...
                    ];
    
SobolFirstOrder = [...
    mySobolResultsMC.FirstOrder ...
                            ];
    
% Create the plot
uq_figure('Name', 'Total Sobol'' Indices')
barWidth = 1;
uq_bar(1:3, SobolTotal(:,1), barWidth)
% Set axes limits
ylim([0 1])
xlim([0 5])
% Set labels
xlabel('Variable name')
ylabel('Total Sobol'' indices')
set(...
    gca,...
    'XTick', 1:length(InputOpts.Marginals),...
    'XTickLabel', mySobolResultsMC.VariableNames)
% Set legend
uq_legend({...
    sprintf('MC-based (%.0e simulations)', mySobolResultsMC.Cost)},...
    'Location', 'northeast')
   
    
% Create the plot
uq_figure('Name', 'First-order Sobol'' Indices')
uq_bar(1:3, SobolFirstOrder(:,1), barWidth)
% Set axes limits
xlim([0 5])
ylim([0 1])
% Set labels
xlabel('Variable name')
ylabel('First-order Sobol'' indices')
set(...
    gca,...
    'XTick', 1:length(InputOpts.Marginals),...
    'XTickLabel', mySobolResultsMC.VariableNames)
% Set legend
uq_legend({...
    sprintf('MC-based (%.0e simulations)', mySobolResultsMC.Cost)},...
    'Location', 'northeast')
