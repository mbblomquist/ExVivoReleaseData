%==========================================================================
% Purpose:  Batch process data collected during ex vivo testing of ligament
%           releases.
% 
% Inputs:
%   - none
% 
% Outputs:
%   - Data      (structure) ...
% 
% Written By: 
%       Matthew Blomquist (2019-10-16)
% 
% Modified Code from : 
%       Joshua D. Roth (2019-04-30)
%       batchProcessExVivoWaveSpeed.m
% 
% Project: nihR21_2018
% 
% See Also: waveSpeedCalcGit
%--------------------------------------------------------------------------
% Revision history:
% -----------------
% v1    2019-04-30(JDR)     inital release
% v2    2019-10-16(MBB)     
% 
%==========================================================================
clear; clc; close all

%% Define params
%===============

% baseDir = 'G:\My Drive\UW NMBL\LigamentTensiometer\nihR21EB024957_2018-04-01\data\pilot\2019-05-01_releasesPorcineMclLcl' ;
baseDir = 'G:\My Drive\UW NMBL\LigamentTensiometer\nihR21EB024957_2018-04-01\data\exVivoRelease\' ;

% ----------- wave speed calc method params ----------- %

options.waveSpeedMethod = 'XCorr'; % specify which methods to use to calculate wave speed; options: 'XCorr', 'frequency', 'P2P', 'kneedle', 'leastSquare'

switch options.waveSpeedMethod
    case 'XCorr' % cross-correlation method
        options.window = [ 0, 0.5 ] ; % specify which section of first signal will be time-shifted to best match the second; options [ <#>, <#> ], adaptive1, adaptive2
%         options.window = 'adaptive1' ;
    case 'frequency' % frequency method, which is useful during ex vivo testing with non-contact sensors when a standing wave develops
       options.peakFindMethod = 'auto' ; % specify whethre peak of FFT is computed automatically (auto) or manually (manual)
       options.window = [ 4, 15 ] ; % specify time window over which frequencies are analyzed
       options.tendonLength = 63 ; % specify the grip-to-grip length of the specimen
end
options.signCorrection = [ 1, 1 ] ; % allows for correcting data if one accelerometer was flipped
options.maxDelay = 1 ; % specify the max time shift in ms for the cross-correlation
options.travelDist = 5 ; % specify the distance between accelerometers/lasers
options.takeDerivYesNo = 0 ; % specify whether to compute the derivative of the input signals; sometimes useful with laser data
options.filterBandWave = [150 5000] ; % specify limits of band pass filter; lower limit usually 100-150, upper limit usually 1500-5000
options.deltaWSThresh = 25 ; % specify theshold for changes in wave speed from one data point to the next
options.minCorr = 0.5 ; % specify the minimum correlation between the two signals that can be considered the peak
options.minSegLength = 1 ; % specity the minimum number of points in a row that are not excluded by deltaWSThresh or minCorr

% ----------- input sensor params ----------- %
options.numAcc = 2 ; % specify number of accelerometers/lasers used
options.accColumns = [ 3, 2 ] ; % specify columns in data file that contain accelerometer/laser data
options.collectionMethod = 'accelerometer' ; % specify which sensors were used to collect the data; options: accelerometer, laser, ultrasound

% ----------- input sensor params ----------- %
options.loadDataYesNo = 1 ; % specify whether load data is included ( 1 = yes, 0 = no )
options.loadColumns = [ 4 ] ; % specify columns in data file that contain load data
options.tapDataYesNo = 1 ; % specify whether tapper data is included ( 1 = yes, 0 = no )
options.tapperColumns = 5 ; % specify columns in data file that contain tapper data
% options.filterLowPass = 2; % specify the low pass filter level on input data other than accelerometers/lasers

% ----------- input sensor params ----------- %
options.plotYesNo = 0; % specify whether to plot data ( 1 = yes, 0 = no )
options.nanFill = 1 ; % specify whether to fill excluded data that was assigned a nan value; must be on in R2019+
options.plotCorr = 0 ; % specify whether to plot the correlation between the two signals
% options.wsLowPass = 4; % specify the low pass filter level on the computed wave speeds

%% 

DirInfo = dir( baseDir ) ; % Use directory from top of code, DirInfo is now a structure with info from baseDir

specFldIdx = find( [ DirInfo.isdir ] & ~contains( { DirInfo.name }, { '.', '..' } ) )' ; % Finds directories in DirInfo that does not include '.' and '..'
numSpec = size( specFldIdx, 1 ) ; % Number of directories (in this case, number of ligaments) in baseDir

% for iSpec = 1 : numSpec % go through each speciman
    iSpec = 9; % individual speciman
    iteration = 1; % accumulator
    TempSpecDirInfo = dir( fullfile( baseDir, DirInfo( specFldIdx( iSpec ) ).name, '\*.lvm' ) ) ; % temp directory
    tempNumTrials = size( TempSpecDirInfo, 1 ) ; % num trials in temp directory
    tempSpecName = strrep( DirInfo( specFldIdx( iSpec ) ).name, '-', '_' ) ; % replaces all hyphens with underscores in names of files
    tempTrialArray = 1 : tempNumTrials ;
    
    poorTrials = [1, 5, 6, 7, 8, 9, 10, 11, 12, 13] ;
    
    goodTrials = ~ismember(tempTrialArray,poorTrials).*tempTrialArray;
    goodTrials = goodTrials(goodTrials~=0);
    
    for iTrial = goodTrials % go through each good trial of speciman      
        filenames.lvm = ... % ... is continuation
            fullfile( baseDir, DirInfo( specFldIdx( iSpec ) ).name, TempSpecDirInfo( iTrial ).name ) ; % concatenates original filename with numTrial name
        Output = waveSpeedCalcGit(filenames,options); % waveSpeedCalcGit on filenames with options set earlier
        Data.( tempSpecName ).ws{ iteration, 1 } = Output.processedData.waveSpeed.filt.push{ 1 } ; % Wave speed values stored in Data
        Data.( tempSpecName ).tension{ iteration, 1 } = Output.processedData.load.push ; % Tension values stored in Data
        iteration = iteration + 1;
    end
    
    %poorTrials=~ismember(x,y).*x
    %poorTrials = poorTrials(poorTrials~=0)
    
%     clear Temp* temp*
% end

save('G:\My Drive\UW NMBL\LigamentTensiometer\nihR21EB024957_2018-04-01\data\exVivoRelease\porcine_18_0476_01_L_LCL.mat','Data')

% %% ----------------- Plot data ----------------- %%
% 
% figure()
% hold on
% specIds = fieldnames( Data ) ;
% numSpec = length( specIds ) ;
% for iSpec = 1 : numSpec
%     tempNumRelCycles = size( Data.( specIds{ iSpec } ).ws, 1 ) ;
%     for iTrial = 1 : 21
%         tempWaveSpeeds = Data.( specIds{ iSpec } ).ws{ iTrial } ;
%         notNanIdx = ~isnan( tempWaveSpeeds ) ;
%         xData( iTrial ) = mean( cellfun( @mean, Data.( specIds{ iSpec } ).tension{ iTrial }( notNanIdx ) ) ) ;
%         yDataMean( iTrial ) = mean( tempWaveSpeeds ) ;
%         yDataSd( iTrial ) = std( tempWaveSpeeds ) ;
%     end
%     
%     errorbar( xData, yDataMean, yDataSd )
%     clear xData yData* temp*
% end
% 
% legend( specIds, 'Interpreter', 'none' )
