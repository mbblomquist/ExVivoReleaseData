%% Define params

% clear; clc; close all

baseDir = 'G:\My Drive\UW NMBL\LigamentTensiometer\nihR21EB024957_2018-04-01\data\exVivoRelease\' ;
DirInfo = dir( baseDir ) ; % Use directory from top of code, DirInfo is now a structure with info from baseDir
specMatFilenames = dir( fullfile( baseDir , '*.mat' ) )' ; % Find files in base directory with .mat extension
numMatSpec = size( specMatFilenames , 2 ) ; % Number of specimans with .mat extension


% for iSpec = 1 : numMatSpec
%     load( fullfile(baseDir , specMatFilenames( iSpec ).name ));
%     releaseData.(specMatFilenames( iSpec ).name(1:end-4)) = Data;
% end

% Could improve above "for" loop, I could figure out how to concatenate
% structures
% For now, it produces structures within structures


specIds = fieldnames( releaseData ) ; % Speciman filenames

lclIds = transpose(find(contains(specIds,'LCL'))); % Finds specIds with LCL
mclIds = transpose(find(contains(specIds,'MCL'))); % Finds specIds with MCL

numSpec = length( specIds ) ; % total number of specimans
colors = ['y','y','m','c','m','c','r','g','r','g','b','k'] ; % color array when plotting
ligamentsToPlot=lclIds; % lclIds: LCLs, mclIds: MCLs, or a number 1-numSpec to plot specific speciman


%% Plot wave speed squared vs tension

figure()
ylabel('Tension (N)') % y axis
xlabel('Wave Speed Squared (m^2/s^2)') % x axis
% xlabel('Wave Speed (m/s)')
xticks([0,10^2,20^2,30^2,40^2,50^2,60^2]);
xticklabels({'0','10^2','20^2','30^2','40^2','50^2','60^2'});
axis([0 1600 0 260]);
% xticks([0,10,20,30,40,50,60]);
% xticklabels({'0','10','20','30','40','50','60'});
% axis([0 40 0 260]);

hold on


for iSpec = ligamentsToPlot % plots only ligaments set above
    tempNumRelCycles = size( releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).ws, 1 ) ; % looks through num of release cycles for ligament
    for iTrial = 1 : tempNumRelCycles % loop through cycles
        tempWaveSpeeds = releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).ws{ iTrial } ; % wave speed values for this speciman
        notNanIdx = ~isnan( tempWaveSpeeds ) ; % checks for non Nan values
        tension( iTrial ) = mean( cellfun( @mean, releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).tension{ iTrial }( notNanIdx ) ) ) ; % average of tension values
        waveSpeedMean( iTrial ) = mean( tempWaveSpeeds ) ; % average of wave speed values
        waveSpeedSd( iTrial ) = std( tempWaveSpeeds ) ; % std of wave speed values
    end
    
    if tension(1)>100 % For data measuring load, not volts (below)
        tensionInd = (tension > 25) ; % min tension value cutoff
        waveSpeedMean = waveSpeedMean( tensionInd ) ; % cuts off wave speed values that have tension below value in above line
        tension = tension( tensionInd ) ; % cuts off tension values that have tension below value in two lines above
        tempLinearRegression = fitlm( waveSpeedMean.^2 , tension , 'RobustOpts' , 'on' ) ; % linear regression for speciman
        plot([0:max(waveSpeedMean.^2)],tempLinearRegression.Coefficients.Estimate(1)+[0:max(waveSpeedMean.^2)].*tempLinearRegression.Coefficients.Estimate(2),colors(iSpec),'handleVisibility','off') ; % plot linear regression fit
        scatter(waveSpeedMean.^2, tension, 25, 'filled',colors(iSpec)) % plot scatter plot of values
    else
        tensionInd = (tension * 30 > 25) ; % For data measuring volts, not load (above)
        waveSpeedMean = waveSpeedMean( tensionInd ) ; % same as above
        tension = tension( tensionInd ) ; % same as above
        tempLinearRegression = fitlm( waveSpeedMean.^2 , tension*30 , 'RobustOpts' , 'on' ) ;
        plot([0:max(waveSpeedMean.^2)],tempLinearRegression.Coefficients.Estimate(1)+[0:max(waveSpeedMean.^2)].*tempLinearRegression.Coefficients.Estimate(2),colors(iSpec),'handleVisibility','off') ;
        scatter(waveSpeedMean.^2, tension*30, 25, 'filled',colors(iSpec))
    end
  %   errorbar( xData*30, yDataMean, yDataSd )
    clear tension waveSpeed* temp*
end

legend( specIds(ligamentsToPlot), 'Interpreter', 'none' ) % legend for specimans plotted

%% Plot force vs trial
% 
% 
% figure()
% ylabel('Tension (N)')
% xlabel('Trial')
% 
% hold on
% 
% for iSpec = ligamentsToPlot
%     tempNumRelCycles = size( releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).ws, 1 ) ;
%     for iTrial = 1 : tempNumRelCycles
%         tempWaveSpeeds = releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).ws{ iTrial } ;
%         notNanIdx = ~isnan( tempWaveSpeeds ) ;
%         tension( iTrial ) = mean( cellfun( @mean, releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).tension{ iTrial }( notNanIdx ) ) ) ;
%     end
%     
%     if tension(1)>100
%         scatter(1:tempNumRelCycles, tension, 25, 'filled',colors(iSpec))
%     else
%         scatter(1:tempNumRelCycles, tension*30, 25, 'filled',colors(iSpec))
%     end
%     clear tension temp*
% end
% 
% legend( specIds(ligamentsToPlot), 'Interpreter', 'none' )
