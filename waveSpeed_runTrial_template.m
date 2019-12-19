%==========================================================================
% Purpose: Template script to call waveSpeedCalcGit. 
% 
% Inputs:
% - path to *.lvm file containing:
%    - accelerometer/laser data
%    - tapper wave data
%    - load cell data (optional)
% - options for how to calculate wave speed from the data
% 
% Output:
% - structures of *lvm file path and options that are passed to the
% waveSpeedCalcGit function. This function then reads the specified *.lvm
% data file, computed the wave speed using the specified options, and then
% plots the data
% 
% Written by: Josh Roth (2019-09-14)
% 
% See also: waveSpeedCalcGit
%==========================================================================
clear, clc

% ----------- specify path to lvm file ----------- %
% d = 'G:\My Drive\UW NMBL\LigamentTensiometer\Users\Matthew Blomquist\2019-09-23\*.lvm';
% 
% [ fileName, filePath ] = uigetfile( [ d, '/*.lvm'], 'Please select *.lvm file.' ) ;
% 
% filenames.lvm = [ filePath, fileName ] ;

[filename, filepath] = uigetfile('G:\My Drive\UW NMBL\LigamentTensiometer\nihR21EB024957_2018-04-01\data\exVivoPrePost\C170680-R\tka\*.lvm') ;
filenames.lvm = fullfile(filepath,filename) ;


% ----------- wave speed calc method params ----------- %

options.waveSpeedMethod = 'XCorr'; % specify which methods to use to calculate wave speed; options: 'XCorr', 'frequency', 'P2P', 'kneedle', 'leastSquare'

switch options.waveSpeedMethod
    case 'XCorr' % cross-correlation method
        options.window = [ 0, 0.8 ] ; % specify which section of first signal will be time-shifted to best match the second; options [ <#>, <#> ], adaptive1, adaptive2
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
options.filterBandWave = [150 1500] ; % specify limits of band pass filter; lower limit usually 100-150, upper limit usually 1500-5000
options.deltaWSThresh = 25 ; % specify theshold for changes in wave speed from one data point to the next
options.minCorr = 0.5 ; % specify the minimum correlation between the two signals that can be considered the peak
options.minSegLength = 1 ; % specity the minimum number of points in a row that are not excluded by deltaWSThresh or minCorr

% ----------- input sensor params ----------- %
options.numAcc = 2 ; % specify number of accelerometers/lasers used
options.accColumns = [ 3, 2 ] ; % specify columns in data file that contain accelerometer/laser data
options.collectionMethod = 'accelerometer' ; % specify which sensors were used to collect the data; options: accelerometer, laser, ultrasound

% ----------- input sensor params ----------- %
options.loadDataYesNo = 0 ; % specify whether load data is included ( 1 = yes, 0 = no )
options.loadColumns = [ 4 ] ; % specify columns in data file that contain load data
options.tapDataYesNo = 1 ; % specify whether tapper data is included ( 1 = yes, 0 = no )
options.tapperColumns = 5 ; % specify columns in data file that contain tapper data
% options.filterLowPass = 2; % specify the low pass filter level on input data other than accelerometers/lasers

% ----------- input sensor params ----------- %
options.plotYesNo = 1; % specify whether to plot data ( 1 = yes, 0 = no )
options.nanFill = 1 ; % specify whether to fill excluded data that was assigned a nan value; must be on in R2019+
options.plotCorr = 0 ; % specify whether to plot the correlation between the two signals
% options.wsLowPass = 4; % specify the low pass filter level on the computed wave speeds

% ----------- call wave speed calc function ----------- %
output = waveSpeedCalcGit( filenames, options ) ;

wsVector=output.processedData.waveSpeed.filt.push{1,1};
ws = mean(wsVector)
sd = std(wsVector)
% loadVector=cellfun(@mean,output.processedData.load.push);
% load = mean(loadVector)
% save('/Users/mbb201/Documents/MATLAB/TipGeometry_9_30_2019/LaserPos2.mat','wsVector','loadVector');
