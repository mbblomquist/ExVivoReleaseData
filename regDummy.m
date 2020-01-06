function mdl = regDummy(wsLCLConc,wsMCLConc,tensionLCLConc,...
    tensionMCLConc)

%%%% DETAILS %%%%
% Does a dummy variable regression on wave speed vs stress for LCL and MCL

%%%% INPUTS %%%%
% concatenated arrays of all wave speed and stress data in all LCLs and all
% MCLs

% Must be row vector (125x1)

    dataMatrix = cat(1,[zeros(length(tensionLCLConc),1) wsLCLConc.^2 ...
        tensionLCLConc],[ones(length(tensionMCLConc),1) ...
        wsMCLConc.^2 tensionMCLConc]);

    tbl = table(dataMatrix(:,1),dataMatrix(:,2),dataMatrix(:,3),...
        'VariableNames',{'Binary','WS','Tension'});

    mdl = fitlm(tbl,'Tension ~ 1 + WS + Binary + WS*Binary','RobustOpts','off');

end