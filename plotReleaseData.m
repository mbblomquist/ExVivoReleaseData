%% Define params

% clear; clc; close all

baseDir = '/Users/MBlomquist/Google Drive File Stream/My Drive/UW NMBL/LigamentTensiometer/nihR21EB024957_2018-04-01/data/exVivoRelease' ;
% baseDir = 'G:\My Drive\UW NMBL\LigamentTensiometer\nihR21EB024957_2018-04-01\data\exVivoRelease\' ;
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
mclIds = [mclIds(1),mclIds(2),mclIds(4),mclIds(5),mclIds(7)] ; % for SB3C abstract

numSpec = length( specIds ) ; % total number of specimans
colors = ['y','y','m','c','m','c','r','g','r','g','b','k'] ; % color array when plotting
% colors = ['r','r','r','r','r','b','b','b','b','b'];
ligamentsToPlot=[lclIds,mclIds]; % lclIds: LCLs, mclIds: MCLs, or a number 1 to numSpec to plot specific speciman


%% Plot wave speed squared vs tension

% figure()
% ylabel('Tension (N)') % y axis
% xlabel('Wave Speed Squared (m^2/s^2)') % x axis
% xticks([0,10^2,20^2,30^2,40^2,50^2,60^2]);
% xticklabels({'0','10^2','20^2','30^2','40^2','50^2','60^2'});
% axis([0 1600 0 260]);
% 
% hold on
% 
% for iSpec = ligamentsToPlot % plots only ligaments set above
%     tempNumRelCycles = size( releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).ws, 1 ) ; % looks through num of release cycles for ligament
%     for iTrial = 1 : tempNumRelCycles % loop through cycles
%         tempWaveSpeeds = releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).ws{ iTrial } ; % wave speed values for this speciman
%         notNanIdx = ~isnan( tempWaveSpeeds ) ; % checks for non Nan values
%         tension( iTrial ) = mean( cellfun( @mean, releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).tension{ iTrial }( notNanIdx ) ) ) ; % average of tension values
%         waveSpeedMean( iTrial ) = mean( tempWaveSpeeds ) ; % average of wave speed values
%         waveSpeedSd( iTrial ) = std( tempWaveSpeeds ) ; % std of wave speed values
%     end
%     
%     if tension(1)>100 % For data measuring load, not volts (below)
%         tensionInd = (tension > 25) ; % min tension value cutoff
%         waveSpeedMean = waveSpeedMean( tensionInd ) ; % cuts off wave speed values that have tension below value in above line
%         tension = tension( tensionInd ) ; % cuts off tension values that have tension below value in two lines above
%         tempLinearRegression = fitlm( waveSpeedMean.^2 , tension , 'RobustOpts' , 'on' ) ; % linear regression for speciman
%         plot([0:max(waveSpeedMean.^2)],tempLinearRegression.Coefficients.Estimate(1)+[0:max(waveSpeedMean.^2)].*tempLinearRegression.Coefficients.Estimate(2),colors(iSpec),'handleVisibility','off') ; % plot linear regression fit
%         scatter(waveSpeedMean.^2, tension, 25, 'filled',colors(iSpec)) % plot scatter plot of values
%     else
%         tensionInd = (tension * 30 > 25) ; % For data measuring volts, not load (above)
%         waveSpeedMean = waveSpeedMean( tensionInd ) ; % same as above
%         tension = tension( tensionInd ) ; % same as above
%         tempLinearRegression = fitlm( waveSpeedMean.^2 , tension*30 , 'RobustOpts' , 'on' ) ;
%         plot([0:max(waveSpeedMean.^2)],tempLinearRegression.Coefficients.Estimate(1)+[0:max(waveSpeedMean.^2)].*tempLinearRegression.Coefficients.Estimate(2),colors(iSpec),'handleVisibility','off') ;
%         scatter(waveSpeedMean.^2, tension*30, 25, 'filled',colors(iSpec))
%     end
% %     errorbar( xData*30, yDataMean, yDataSd )
%     clear tension waveSpeed* temp*
% end
% 
% legend( specIds(ligamentsToPlot), 'Interpreter', 'none' ) % legend for specimans plotted

%% Plot tension vs wave speed squared - all lig types included

% totColors = ['r','b'];
% 
% figure()
% ylabel('Tension (N)') % y axis
% xlabel('Wave Speed Squared (m^2/s^2)') % x axis
% % xlabel('Wave Speed (m/s)')
% xticks([0,10^2,20^2,30^2,40^2,50^2,60^2]);
% xticklabels({'0','10^2','20^2','30^2','40^2','50^2','60^2'});
% axis([0 1600 0 260]);
% % xticks([0,10,20,30,40,50,60]);
% % xticklabels({'0','10','20','30','40','50','60'});
% % axis([0 40 0 260]);
% 
% hold on
% 
% totWSvalues = [];
% totTenvalues = [];
% 
% 
% for iSpec = ligamentsToPlot % plots only ligaments set above
%     tempNumRelCycles = size( releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).ws, 1 ) ; % looks through num of release cycles for ligament
%     for iTrial = 1 : tempNumRelCycles % loop through cycles
%         tempWaveSpeeds = releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).ws{ iTrial } ; % wave speed values for this speciman
%         notNanIdx = ~isnan( tempWaveSpeeds ) ; % checks for non Nan values
%         tension( iTrial ) = mean( cellfun( @mean, releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).tension{ iTrial }( notNanIdx ) ) ) ; % average of tension values
%         waveSpeedMean( iTrial ) = mean( tempWaveSpeeds ) ; % average of wave speed values
%         waveSpeedSd( iTrial ) = std( tempWaveSpeeds ) ; % std of wave speed values
%     end
%     
%     if tension(1)>100 % For data measuring load, not volts (below)
%         tensionInd = (tension > 25) ; % min tension value cutoff
%         waveSpeedMean = waveSpeedMean( tensionInd ) ; % cuts off wave speed values that have tension below value in above line
%         totWSvalues = [totWSvalues waveSpeedMean] ;
%         tension = tension( tensionInd ) ; % cuts off tension values that have tension below value in two lines above
%         totTenvalues = [totTenvalues tension] ;
% 
%     else
%         tensionInd = (tension * 30 > 25) ; % For data measuring volts, not load (above)
%         waveSpeedMean = waveSpeedMean( tensionInd ) ; % same as above
%         totWSvalues = [totWSvalues waveSpeedMean] ;
%         tension = 30*tension( tensionInd ) ; % same as above
%         totTenvalues = [totTenvalues tension] ;
% 
%     end
%     
%     clear tension waveSpeed* temp*
% end
% 
% scatter(totWSvalues.^2, totTenvalues, 25, 'filled', 'r')
% LCLlinearRegression = fitlm( totWSvalues.^2 , totTenvalues , 'RobustOpts' , 'on' ) ;
% plot([0:max(totWSvalues.^2)],LCLlinearRegression.Coefficients.Estimate(1)+[0:max(totWSvalues.^2)].*LCLlinearRegression.Coefficients.Estimate(2),'r','handleVisibility','off') ;
% alpha = 0.5;
% color = 'r';
% x = [0: max(totWSvalues.^2)];
% x2 = [x, fliplr(x)];
% inBetween = [(LCLlinearRegression.Coefficients.Estimate(1)+LCLlinearRegression.RMSE)+[0:max(totWSvalues.^2)].*LCLlinearRegression.Coefficients.Estimate(2),fliplr((LCLlinearRegression.Coefficients.Estimate(1)-LCLlinearRegression.RMSE)+[0:max(totWSvalues.^2)].*LCLlinearRegression.Coefficients.Estimate(2))] ;
% shade=fill(x2, inBetween, 'g');
% set(shade,'FaceColor',color,'EdgeColor',color,'FaceAlpha',alpha,'EdgeAlpha',alpha);
% 
% 
% legend( specIds(ligamentsToPlot), 'Interpreter', 'none' ) % legend for specimans plotted






figure()
ylabel('Tension (N)') % y axis
xlabel('Wave Speed Squared (m^2/s^2)') % x axis
% xlabel('Wave Speed (m/s)')
xticks([0,10^2,20^2,30^2,40^2,50^2,60^2]);
xticklabels({'0','10^2','20^2','30^2','40^2','50^2','60^2'});
axis([0 1500 0 260]);
% xticks([0,10,20,30,40,50,60]);
% xticklabels({'0','10','20','30','40','50','60'});
% axis([0 40 0 260]);
grid on
hold on



ligamentType = [lclIds , mclIds];
ligTypeColors = ['r','b'];
n = 0 ; % help for looping through first five 
xMax = 1600 ; % max x value for fit curves

for ligType = 1:2

    
    totWSvalues = [];
    totTenvalues = [];
    
    for iSpec = ligamentType((1:5) + n) % plots only ligaments set above
        tempNumRelCycles = size( releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).ws, 1 ) ;  % looks through num of release cycles for ligament
        for iTrial = 1 : tempNumRelCycles % loop through cycles
            tempWaveSpeeds = releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).ws{ iTrial } ; % wave speed values for this speciman
            notNanIdx = ~isnan( tempWaveSpeeds ) ; % checks for non Nan values
            tension( iTrial ) = mean( cellfun( @mean, releaseData.( specIds{ iSpec } ).( specIds{ iSpec } ).tension{ iTrial }( notNanIdx ) ) ) ; % average of tension values
            waveSpeedMean( iTrial ) = mean( tempWaveSpeeds ) ; % average of wave speed values
            waveSpeedSd( iTrial ) = std( tempWaveSpeeds ) ; % std of wave speed values
        end
        
        if tension(1)>100 % For data measuring load, not volts (below)
            tensionInd = (tension > 39) ; % min tension value cutoff
            waveSpeedMean = waveSpeedMean( tensionInd ) ; % cuts off wave speed values that have tension below value in above line
            totWSvalues = [totWSvalues waveSpeedMean] ;
            tension = tension( tensionInd ) ; % cuts off tension values that have tension below value in two lines above
            totTenvalues = [totTenvalues tension] ;
            % length(totTenvalues)
            
        else
            tensionInd = (tension * 30 > 39) ; % For data measuring volts, not load (above)
            waveSpeedMean = waveSpeedMean( tensionInd ) ; % same as above
            totWSvalues = [totWSvalues waveSpeedMean] ;
            tension = 30*tension( tensionInd ) ; % same as above
            totTenvalues = [totTenvalues tension] ;
            % length(totTenvalues)
            
        end
        
        clear tension waveSpeed* temp*
    end
    
%     %scatter(totWSvalues.^2, totTenvalues, 25, 'filled', ligTypeColors(ligType))
%     linearRegression = fitlm( totWSvalues.^2 , totTenvalues , 'RobustOpts' , 'on' ) ;
%     plot([0:xMax],linearRegression.Coefficients.Estimate(1)+[0:xMax].*linearRegression.Coefficients.Estimate(2),ligTypeColors(ligType),'handleVisibility','off') ;
%     alpha = 0.5;
%     x = [0:xMax];
%     x2 = [x, fliplr(x)];
%     inBetween = [(linearRegression.Coefficients.Estimate(1)+linearRegression.RMSE)+[0:xMax].*linearRegression.Coefficients.Estimate(2),fliplr((linearRegression.Coefficients.Estimate(1)-linearRegression.RMSE)+[0:xMax].*linearRegression.Coefficients.Estimate(2))] ;
%     shade=fill(x2, inBetween, 'g');
%     set(shade,'FaceColor',ligTypeColors(ligType),'EdgeColor',ligTypeColors(ligType),'FaceAlpha',alpha,'EdgeAlpha',alpha);
%     
%     linearRegression.Rsquared
%     clear totTenvalues totWSvalues
%     n = 5;


    
    %scatter(totWSvalues.^2, totTenvalues, 25, 'filled', ligTypeColors(ligType))
    linearRegression = fitlm( totWSvalues.^2 , totTenvalues , 'RobustOpts' , 'off' ) ;
    
    linearRegression.Coefficients.Estimate(1)
    linearRegression.Coefficients.Estimate(2)
    
%     plot([0:xMax],linearRegression.Coefficients.Estimate(1)+[0:xMax].*linearRegression.Coefficients.Estimate(2),ligTypeColors(ligType),'handleVisibility','off') ;
    alpha = 0.5;
    x = [0:xMax];
    x2 = [x, fliplr(x)];
    [ ypred , yci ] = predict(linearRegression,transpose(x));
%     inBetween = [(linearRegression.Coefficients.Estimate(1)+linearRegression.RMSE)+[0:xMax].*linearRegression.Coefficients.Estimate(2),fliplr((linearRegression.Coefficients.Estimate(1)-linearRegression.RMSE)+[0:xMax].*linearRegression.Coefficients.Estimate(2))] ;
%     shade=fill(x2, inBetween, 'g');
    
    plot(x,ypred,ligTypeColors(ligType))
    plot(x,yci)
    inBetween = [transpose(yci(:,1)) , transpose(flipud(yci(:,2)))];
    shade=fill(x2,inBetween,'b');
    set(shade,'FaceColor',ligTypeColors(ligType),'EdgeColor',ligTypeColors(ligType),'FaceAlpha',alpha,'EdgeAlpha',alpha);

    if n == 0
        lclTension = totTenvalues;
        lclWS = totWSvalues;
    else
        mclTension = totTenvalues;
        mclWS = totWSvalues;
    end
    
    linearRegression.Rsquared
    clear totTenvalues totWSvalues
    n = 5;
end 


legend( 'LCL','MCL', 'Interpreter', 'none' ) % legend for specimans plotted



%% Stats
mdl = regDummy(transpose(lclWS),transpose(mclWS),transpose(lclTension),transpose(mclTension))

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

