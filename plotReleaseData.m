% clear; clc; close all

baseDir = 'G:\My Drive\UW NMBL\LigamentTensiometer\nihR21EB024957_2018-04-01\data\exVivoRelease\' ;
DirInfo = dir( baseDir ) ; % Use directory from top of code, DirInfo is now a structure with info from baseDir
specMatFilenames = dir( fullfile( baseDir , '*.mat' ) )' ; % Find files in base directory with .mat extension
numMatSpec = size( specMatFilenames , 2 ) ; % Number of specimans with .mat extension


% for iSpec = 1 : numMatSpec
%     load( specMatFilenames( iSpec ).name );
%     releaseData.(specMatFilenames( iSpec ).name(1:end-4)) = Data;
% end

% Could improve above "for" loop, I could figure out how to concatenate
% structures
% For now, it produces structures within structures


figure()
ylabel('Tension (N)')
xlabel('Wave Speed Squared (m^2/s^2)')

hold on
specIds = fieldnames( releaseData ) ;

lclIds = transpose(find(contains(specIds,'LCL')));
mclIds = transpose(find(contains(specIds,'MCL')));

numSpec = length( specIds ) ;

colors = ['y','y','m','c','m','c','r','g','r','g','b','k'] ;

ligamentsToPlot=mclIds;

for iSpec = ligamentsToPlot
    tempNumRelCycles = size( releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).ws, 1 ) ;
    for iTrial = 1 : tempNumRelCycles
        tempWaveSpeeds = releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).ws{ iTrial } ;
        notNanIdx = ~isnan( tempWaveSpeeds ) ;
        tension( iTrial ) = mean( cellfun( @mean, releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).tension{ iTrial }( notNanIdx ) ) ) ;
        waveSpeedMean( iTrial ) = mean( tempWaveSpeeds ) ;
        waveSpeedSd( iTrial ) = std( tempWaveSpeeds ) ;
    end
    
    if tension(1)>100
         tempLinearRegression = fitlm( waveSpeedMean.^2 , tension , 'RobustOpts' , 'on' ) ;
        plot([0:max(waveSpeedMean.^2)],tempLinearRegression.Coefficients.Estimate(1)+[0:max(waveSpeedMean.^2)].*tempLinearRegression.Coefficients.Estimate(2),colors(iSpec),'handleVisibility','off') ;
        scatter(waveSpeedMean.^2, tension, 25, 'filled',colors(iSpec))
    else
        tempLinearRegression = fitlm( waveSpeedMean.^2 , tension*30 , 'RobustOpts' , 'on' ) ;
        plot([0:max(waveSpeedMean.^2)],tempLinearRegression.Coefficients.Estimate(1)+[0:max(waveSpeedMean.^2)].*tempLinearRegression.Coefficients.Estimate(2),colors(iSpec),'handleVisibility','off') ;
        scatter(waveSpeedMean.^2, tension*30, 25, 'filled',colors(iSpec))
    end
  %   errorbar( xData*30, yDataMean, yDataSd )
    clear tension waveSpeed* temp*
end

legend( specIds(ligamentsToPlot), 'Interpreter', 'none' )