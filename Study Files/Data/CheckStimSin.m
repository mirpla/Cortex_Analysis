for subjID = 1:length(dir([Datapath, 'EEG\s*.*']))     % Subject counter
    for sescnt = 1:sesN 
    cfg = [];
        cfg.bpfreq                      =   [3,5];
        cfg.bpfilter                    =	'yes';
        cfg.bpfilttype                  =   'fir';
        cfg.datafile                    = [DataEEG,'s',num2str(subjID),'\ses',num2str(sescnt),'.eeg'];
        cfg.headerfile                  = [DataEEG,'s',num2str(subjID),'\ses',num2str(sescnt),'.vhdr'];
        cfg.demean                      = 'yes';
        cfg.detrend                     = 'yes';
        [data{subjID,sescnt}]           = ft_preprocessing(cfg);
        
        figure
        plot(data{subjID,sescnt}.time{1,1},data{subjID,sescnt}.trial{1,1})
    end 
end 