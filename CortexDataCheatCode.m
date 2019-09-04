startupCortex

%% Setting the parameters
TBlckN      = 12;               % Amount of Total Blocks
sesN        = 2;                % Amount of Sessions
BlckN       = TBlckN/sesN;      % Amount of Blocks per session
TrlN        = 192;              % Total Amount of Trials
BlckTN      = TrlN / TBlckN;    % Amount of Trials per Block

BsesStrct    = repmat([ones(1,BlckTN),ones(1,BlckTN)*2],1,BlckN)';

AudDelay    = 10 + 1;               % 10 ms Auditory delay set to depend on samples and 0.9 ms delay of headphones sound to travel rounded to 1 ms
TrigDelay   = 5;                    % 5 ms delay on average due to the trigger
Datapath    = 'Z:\Mircea\Cortex_Analysis\Study Files'; %'C:\Users\mxv796\Study Files';
DataEEG     = [Datapath, '\Data\EEG\'];
DataTest    = [Datapath, '\Data\Behav\TestData\'];
zeroPoint   = TrigDelay + AudDelay;
warning('OFF', 'MATLAB:table:ModifiedVarnames'); % Turn warning for READTABLE off because i dont use Table variable names anyway

dwnsnum         = 22;               % Factor used for downsampling the Data 
sine180Path     = strcat(Datapath,'\Materials\sounds\Theta\oneeighty\sin-oneeighty-4Hz-synth15.wav'); % 180 sine template
sine0Path       = strcat(Datapath,'\Materials\sounds\Theta\zero\sin-zero-4Hz-guitar9.wav');           % 0 sine template
%% 0 Sine
[Sound0File, sound0Fs]   =   audioread(sine0Path);
envel0Stim               =   envelope(Sound0File,2000,'rms');
sound0Times              =   0:1/sound0Fs:(133800/sound0Fs)-1/sound0Fs;

% downsample the audiofile due RAM issues (original matrices will exceed 120 GB)
DSound0File              =   downsample(Sound0File, dwnsnum);
DEnvel0Stim              =   downsample(envel0Stim, dwnsnum);
Dsound0Times             =   downsample(sound0Times, dwnsnum);

% Fit the Sine
[Sin0Sound] = FitSineCortex(1:length(DEnvel0Stim(:,1)),  DEnvel0Stim(:,1)');

%% 180 Sine

[Sound180File, sound180Fs] =   audioread(sine180Path);
envel180Stim               =   envelope(Sound180File,2000,'rms');
sound180Times              =   0:1/sound180Fs:(133800/sound180Fs)-1/sound180Fs;

% downsample the audiofile due RAM issues (original matrices will exceed 120 GB)
DSound180File              =   downsample(Sound180File, dwnsnum);
DEnvel180Stim              =   downsample(envel180Stim, dwnsnum);
Dsound180Times             =   downsample(sound180Times, dwnsnum);

% Fit the Sine
[Sin180Sound] = FitSineCortex(1:length(DEnvel180Stim(:,1)),  DEnvel180Stim(:,1)');

%% Run Script for every participant and every session
for subjID = 1:length(dir([DataEEG, 's*.*']))     % Subject counter
    if mod(subjID,2) == 1       % Even number means:    Session 1: Experimental Session;    Session 2: Control Session
        SesMont{subjID} = [1,2];
    elseif  mod(subjID,2) == 0  % Odd number means:     Session 1: Control Session;          Session 2: Experimental Session
        SesMont{subjID} = [2,1];
    end
    
    for sescnt = 1:sesN       % Session counter
        CondID = SesMont{subjID}(sescnt);
        %% Load Test CSV Behavioral Data
        
        for b = (1:BlckN) + ((BlckN)*(sescnt-1))
            AllRep  = readtable([DataTest, 'subj', num2str(subjID),'\subj', num2str(subjID),'-block-',num2str(b),'-Test.csv'], 'ReadVariableNames',true); %'Format', '%d%d%d%s%s%s%d%s%s%s%s%s%d%d%d');
            if sescnt == 1
                Rep{subjID,CondID}((1:BlckTN)+(BlckTN)*(b-1),:)             = [table2array(AllRep(:,13)),table2array(AllRep(:,14))];
                RepS{subjID,CondID}((1:BlckTN)+(BlckTN)*(b-1),:)            = [table2array(AllRep(:,5)), table2array(AllRep(:,6))];
                React{subjID,CondID}((1:BlckTN)+(BlckTN)*(b-1),:)           = table2array(AllRep(:,15));
            elseif sescnt == 2
                Rep{subjID,CondID}((1:BlckTN)+(BlckTN)*(b-1)-(192/2),:)     = [table2array(AllRep(:,13)),table2array(AllRep(:,14))];
                RepS{subjID,CondID}((1:BlckTN)+(BlckTN)*(b-1)-(192/2),:)    = [table2array(AllRep(:,5)), table2array(AllRep(:,6))];
                React{subjID,CondID}((1:BlckTN)+(BlckTN)*(b-1)-(192/2),:)           = table2array(AllRep(:,15));
            else
                warning('WARNING: WRONG SESSION ID')
            end
            if b == 1 || b == 7
                AllRepConc{subjID, CondID} = [AllRep];
            else
                AllRepConc{subjID, CondID} = [AllRepConc{subjID, CondID}; AllRep];
            end
            
        end
        
        %% Reading in the .EEG data
        
        cfg = [];
        cfg.datafile     = [DataEEG,'s',num2str(subjID),'\ses',num2str(sescnt),'.eeg'];
        cfg.headerfile   = [DataEEG,'s',num2str(subjID),'\ses',num2str(sescnt),'.vhdr'];
        cfg.demean       = 'yes';
        [data{subjID,CondID}] = ft_preprocessing(cfg); % Data split by montage, not session
        
        %cfg = []; cfg.viewmode = 'vertical'; ft_databrowser(cfg,data{7,1})
        % can be uncommented for checking the dataquality and doublecheck that stimulation
        %always starts on the same Phase. In some cases may benefit from : 
        %cfg.preproc.bpfreq =   [3,5];
        %cfg.preproc.bpfilter =	'yes';
        %cfg.preproc.bpfilttype =   'fir';
        
        AllTriggers = ft_read_event([DataEEG,'s',num2str(subjID),'\ses',num2str(sescnt),'.vmrk']);
        fs = data{subjID,CondID}.hdr.Fs;
        t = 1;
        t2 = t;
        et = t;
        %%
        if subjID == 1
            TrlTrig = 'S  2';
            ISITrig = 'S  8';
        elseif subjID ==2  && sescnt == 1
            continue;
        else
            TrlTrig = 'S  4';
            ISITrig = 'S  8';
        end
        
        for x = 1:size(AllTriggers, 2)
            
            if  strcmp(AllTriggers(1,x).value, TrlTrig)
                trl{subjID,CondID}(t,1) = AllTriggers(1,x).sample - fs;
                trl{subjID,CondID}(t,2) = AllTriggers(1,x).sample + fs;
                trl{subjID,CondID}(t,3) = -fs;
                t = t+1;
            elseif strcmp(AllTriggers(1,x).value, ISITrig)
                ISI(t2) = AllTriggers(1,x).sample;
                t2 = t2+1;
            else
                empT(et) = AllTriggers(1,x).sample;
                et = et+1;
            end
        end
        clear ISI et
        
        trev = TrlN-1:-1:1-1 ; %% Creation of TrialInfo where 1 = encoding trial and 2 = retrieval Trial and 0 = Practice Trial
        
        % !!!!!!!!! IMPORTANT!!!!!!!!!! DOESNT WORK IF EXPERIMENT EVER WAS PREMATURLY FINISHED
        
        for t = TrlN:-1:1 %% correctly label retrieval trials and encoding trial, Implementation is meant to take into account cancelled first blocks or too late starts
            if length(trl{subjID,CondID}) == trev(t)
                break;
            end
            indt = length(trl{subjID,CondID})-trev(t); % Account for fact that practice trial or false starts are included in the experiment
            trl{subjID,CondID}(indt,4) = BsesStrct(t,1);
        end
        
        NewTrl = trl{subjID,CondID}(find(trl{subjID,CondID}(:,4)==1),:);
        
        cfg = [];
        cfg.trl = NewTrl;
        trlData{subjID,CondID} = ft_redefinetrial(cfg, data{subjID,CondID});
        
        %% Determine Phase
        cfg                             =   [];
        cfg.bpfreq                      =   [3,5];
        cfg.bpfilter                    =	'yes';
        cfg.bpfilttype                  =   'fir';
        Dataprefilt{subjID,CondID} =	ft_preprocessing(cfg,  trlData{subjID,CondID}); % Filtering of Data in 4Hz band to account for Noise in the data
        
        %wrapN = @(x, n) (1 + mod(x-1, n));
        
        %% apply Phase Info to All trials in respective conditions (Sound starting at 0 and at 180 respectively
        for trlidx = find( table2array(AllRepConc{subjID,CondID}(:,7)) == 0 )'
            
            clear PhaseDiff
            PhaInf  = angle(hilbert(Dataprefilt{subjID,CondID}.trial{1,trlidx}));
            PhaseInf0(1,1) = PhaInf(1000+round(zeroPoint*fs/1000)); %rad2deg(PhaInf(1000+round(zeroPoint*fs/1000)));        %
            %% LOAD SOUNDFILE
            % Determine Phase
            PhaSine     = angle(hilbert([Sin0Sound])); %unwrap(angle(hilbert(SinSound)));
            PhaSound    = PhaSine(1,1); %rad2deg(PhaSine(1,1));
            
            % Subtract Stim phase from EEG phase for Phase-difference
            PhaseDiff = rad2deg(angdiff(PhaseInf0(1,1), PhaSound));
            
            %
            %             sPath                   =   strcat(Datapath ,'\Materials\sounds\Theta\',RepS{subjID,CondID}(trlidx,1),'\',table2array(AllRepConc{subjID,CondID}(trlidx,6)));
            %             [SoundFile, soundFs]    =   audioread(sPath{1,1});
            %             envelStim               =   envelope(SoundFile,2000,'rms');
            %             %envelAmp                =   envelope(SoundFile,50000,'rms');
            %             %envelAmpNorm            =   envelStim-max(envelStim)+((max(envelStim)-min(envelStim))/2);
            %
            %             soundTimes              =   0:1/soundFs:(133800/soundFs)-1/soundFs;
            %
            %             % downsample the audiofile due RAM issues (original matrices will exceed 120 GB)
            %             DSoundFile              =   downsample(SoundFile, dwnsnum);
            %             DEnvelStim              =   downsample(envelStim, dwnsnum);
            %             DsoundTimes             =   downsample(soundTimes, dwnsnum);
            %
            %
            %             figure;
            %             hold on
            %             plot(DsoundTimes, DSoundFile(:,1)');
            %             plot(DsoundTimes, DEnvelStim(:,1)');
            %             plot(DsoundTimes, Sin0Sound      - min(Sin0Sound))
            %             %plot(DsoundTimes, -SinSound     + min(SinSound));
            %             hold off
            %
            %             Filename = table2array(AllRepConc{subjID,CondID}(trlidx,6));
            %             saveas(gcf,[Datapath,'/Data/StimuliSine/',Filename{1,1}(1:end-4),'.png'])
            %             close all
            
            %% compare with EEG
            
            if -45<PhaseDiff(1,1) && PhaseDiff(1,1)<=45    % No need to correct for Hilber Transform Phaseshift, since both signals subtracted are affected equally
                PhaseDiff(1,2) = int32(1);
            elseif 45<PhaseDiff(1,1) && PhaseDiff(1,1)<=135
                PhaseDiff(1,2) = int32(2);
            elseif (135<PhaseDiff(1,1) && PhaseDiff(1,1)<=180) || (-180<=PhaseDiff(1,1) && PhaseDiff(1,1)<=-135)
                PhaseDiff(1,2) = int32(3);
            elseif -135<PhaseDiff(1,1) && PhaseDiff(1,1)<=-45
                PhaseDiff(1,2) = int32(4);
            else
                disp('Value Not Good')
                PhaseDiff(1,2) = int32(0);
            end
            AllPhaseInf{subjID,CondID}(trlidx,:) = PhaseDiff;
        end
        
        %% 180 Condition
        for trlidx = find( table2array(AllRepConc{subjID,CondID}(:,7)) == 180 )'
            
            clear PhaseDiff
            PhaInf  = angle(hilbert(Dataprefilt{subjID,CondID}.trial{1,trlidx}));
            PhaseInf0(1,1) = PhaInf(1000+round(zeroPoint*fs/1000)); %rad2deg(PhaInf(1000+round(zeroPoint*fs/1000)));        %
            %% LOAD SOUNDFILE
            
            % Determine Phase
            PhaSine     = angle(hilbert([Sin180Sound])); %unwrap(angle(hilbert(SinSound)));
            PhaSound    = PhaSine(1,1); %rad2deg(PhaSine(1,1));
            
            % Subtract Stim phase from EEG phase for Phase-difference
            PhaseDiff = rad2deg(angdiff(PhaseInf0(1,1), PhaSound));
            
            %             sPath                   =   strcat(Datapath ,'\Materials\sounds\Theta\',RepS{subjID,CondID}(trlidx,1),'\',table2array(AllRepConc{subjID,CondID}(trlidx,6)));
            %             [SoundFile, soundFs]    =   audioread(sPath{1,1});
            %             envelStim               =   envelope(SoundFile,2000,'rms');
            %             %envelAmp                =   envelope(SoundFile,50000,'rms');
            %             %envelAmpNorm            =   envelStim-max(envelStim)+((max(envelStim)-min(envelStim))/2);
            %
            %             soundTimes              =   0:1/soundFs:(133800/soundFs)-1/soundFs;
            %
            %             % downsample the audiofile due RAM issues (original matrices will exceed 120 GB)
            %             DSoundFile              =   downsample(SoundFile, dwnsnum);
            %             DEnvelStim              =   downsample(envelStim, dwnsnum);
            %             DsoundTimes             =   downsample(soundTimes, dwnsnum);
            %
            %
            %             figure;
            %             hold on
            %             plot(DsoundTimes, DSoundFile(:,1)');
            %             plot(DsoundTimes, DEnvelStim(:,1)');
            %             plot(DsoundTimes, Sin180Sound      - min(Sin180Sound))
            %             %plot(DsoundTimes, -SinSound     + min(SinSound));
            %             hold off
            %
            %             Filename = table2array(AllRepConc{subjID,CondID}(trlidx,6));
            %             saveas(gcf,[Datapath,'/Data/StimuliSine/',Filename{1,1}(1:end-4),'.png'])
            %             close all
            
            %% compare with EEG
            
            if -45<PhaseDiff(1,1) && PhaseDiff(1,1)<=45    
                PhaseDiff(1,2) = int32(1);
            elseif 45<PhaseDiff(1,1) && PhaseDiff(1,1)<=135
                PhaseDiff(1,2) = int32(2);
            elseif (135<PhaseDiff(1,1) && PhaseDiff(1,1)<=180) || (-180<=PhaseDiff(1,1) && PhaseDiff(1,1)<=-135)
                PhaseDiff(1,2) = int32(3);
            elseif -135<PhaseDiff(1,1) && PhaseDiff(1,1)<=-45
                PhaseDiff(1,2) = int32(4);
            else
                disp('Value Not Good')
                PhaseDiff(1,2) = int32(0);
            end
            AllPhaseInf{subjID,CondID}(trlidx,:) = PhaseDiff;
        end
        
        %% Exclude <40% performance
        CorrectTrl{subjID,CondID}   = find(Rep{subjID,CondID}(:,1) == Rep{subjID,CondID}(:,2));
        HitRate{subjID,CondID}      = length(CorrectTrl{subjID,CondID})/size(Rep{subjID,CondID},1);
        BadPerfSubj{subjID,CondID}  = HitRate{subjID,CondID}<0.40;
        OutputRep{subjID,CondID}    = [Rep{subjID,CondID},Rep{subjID,CondID}(:,1) == Rep{subjID,CondID}(:,2), React{subjID,CondID},AllPhaseInf{subjID,CondID}];
        
        for y = 1:4
            OutCond{subjID,CondID}{y,1}     = OutputRep{subjID,CondID}(OutputRep{subjID,CondID}(:,6)==y,:);
            HitCond{subjID,CondID}{y,1}     = sum(OutCond{subjID,CondID}{y,1}(:,3))/size(OutCond{subjID,CondID}{y,1}(:,3),1);
        end
        writetable(array2table(OutputRep{subjID,CondID},'VariableNames',{'Response', 'Target','Correct', 'ReactionTime','PhaseDifference', 'PhaseBin'}),[Datapath, '/Data/ReadyFiles/OutputS',num2str(subjID),'C',num2str(CondID),'.csv'])
        
    end
    %     histbinsDeg = 12;
    %
    %     figure;
    %     subplot(3,1,1)
    %     hist(OutputRep{subjID,1}(:,4))
    %     xlabel('RT in S')
    %     subplot(3,1,2)
    %     hist(OutputRep{subjID,1}(:,6),4)
    %     xlabel('Phase-Bin')
    %     xticks([1.25,2,2.75,3.5])
    %     xticklabels({'0','90','180','270'})
    %     subplot(3,1,3)
    %     hist(OutputRep{subjID,1}(:,5), histbinsDeg )
    %     xlabel('Phase Bin')
    %     axis('tight')
    %     title(['Sanity Check S', num2str(subjID), ' Experimental Montage'])
    %
    %
    %     figure;
    %     subplot(3,1,1)
    %     hist(OutputRep{subjID,2}(:,4))
    %     xlabel('RT in S')
    %     subplot(3,1,2)
    %     hist(OutputRep{subjID,2}(:,6),4)
    %     xlabel('Phase-Bin')
    %     xticks([1.25,2,2.75,3.5])
    %     xticklabels({'0','90','180','270'})
    %     subplot(3,1,3)
    %     hist(OutputRep{subjID,2}(:,5), histbinsDeg )
    %     xlabel('Phase Bin')
    %     axis('tight')
    %     title(['Sanity Check S', num2str(subjID), ' Control Montage'])
    %     % both sessions
    OutputRepC{subjID} = [OutputRep{subjID,1}; OutputRep{subjID,2}];
    writetable(array2table(OutputRepC{subjID},'VariableNames',{'Response', 'Target','Correct', 'ReactionTime','PhaseDifference', 'PhaseBin'}),[Datapath, '/Data/ReadyFiles/OutputS',num2str(subjID),'.csv'])
    StimDif(subjID,:) =   [HitCond{subjID,1}{1,1}, HitCond{subjID,1}{2,1}, HitCond{subjID,1}{3,1}, HitCond{subjID,1}{4,1}];
    if subjID == 2
        continue
    end
    ContDif(subjID,:) =   [HitCond{subjID,2}{1,1}, HitCond{subjID,2}{2,1}, HitCond{subjID,2}{3,1}, HitCond{subjID,2}{4,1}];
    
end

writetable(array2table([StimDif,ContDif], 'VariableNames',{'Stim_0','Stim_90','Stim_180','Stim_270', 'Cont_0','Cont_90', 'Cont_180','Cont_270'}),[Datapath, '/Data/ReadyFiles/SubjDiffs.csv'])

