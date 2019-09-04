clc
clear
%% Load in Data files

Basepath = ['D:\Project\'];
cd([Basepath, '\Memory_Exp\csv']);
[~,~,sset{1}] = xlsread('material_sets_new','Sound','A2:A97'); % 0 Phase
[~,~,sset{2}] = xlsread('material_sets_new','Sound','B2:B97'); % 180 Phase

sound_0     = sset{1}; % could be left out and done earlier...
sound_180   = sset{2};

for x = 1:numel(sset{1})
    sound_0{x,2} = 0;
    sound_180{x,2} = 180;
    
    sound_0{x,3} = 'zero';
    sound_180{x,3} = 'oneeighty';
end

[~,~,mset{1}] = xlsread('material_sets_new','Movie','A2:A25'); % Acoustic
[~,~,mset{2}] = xlsread('material_sets_new','Movie','B2:B25'); % Choir
[~,~,mset{3}] = xlsread('material_sets_new','Movie','C2:C25'); % Dar
[~,~,mset{4}] = xlsread('material_sets_new','Movie','D2:D25'); % Ep
[~,~,mset{5}] = xlsread('material_sets_new','Movie','E2:E25'); % Guitar
[~,~,mset{6}] = xlsread('material_sets_new','Movie','F2:F25'); % Orchestral
[~,~,mset{7}] = xlsread('material_sets_new','Movie','G2:G25'); % Synthesizer
[~,~,mset{8}] = xlsread('material_sets_new','Movie','H2:H25'); % Yann

%% parameters
for sub = 1:25
    rng('shuffle')
    
    subject = sub;
    
    scat    = 12;                       % Number of sounds in a category for a given set: 12 for 2 sets, 6 for 4 sets, 4 for 6 sets
    nblocks = 12;                       % Number of blocks in the experiment
    ntrials = 192;                      % Total number of trials
    session = 2;                        % Number of Sessions
    tblocks = 16;                       % Number of trials per block
    tcat    = 4;                        % number of categories per block
    
    nphases = length(sset);             % Number of Phase Categories for Sounds
    ncat    = length(mset);             % Number of Instrumental categories
    ttrl    = tblocks / (tcat*nphases); % trials per block from same category
    
    clabels = {'acoustic','choir','dar','ep','guitar','orch','synth','yann'};
    %% Organize Sounds into Danyings structure
    for x = 1:ncat
        for y = 1:scat
            sounds{1,x}{y,1}.name      = ['sin-zero-4Hz-', sound_0{y+((x-1)*(scat)),1}];
            sounds{1,x}{y,2}.name      = ['sin-oneeighty-4Hz-', sound_180{y+((x-1)*(scat)),1}];
            sounds{1,x}{y,1}.phase     = sound_0{y+((x-1)*(scat)),2};
            sounds{1,x}{y,2}.phase     = sound_180{y+((x-1)*(scat)),2};
            sounds{1,x}{y,1}.folder    = sound_0{y+((x-1)*(scat)),3};
            sounds{1,x}{y,2}.folder    = sound_180{y+((x-1)*(scat)),3};
        end
    end
    
    %% Random permutation of Videos and Audio in set (one set per sound category for movies)(one set of trials for sound)
    for c = 1:ncat
        m{c,1} = mset{c}(randperm(numel(mset{c})),1);
        for p = 1:nphases
            randsound{c,1}(p,:) = randperm(scat);
        end
    end
    
    %% Create Blocks and pick one random stimulus assigned to a condtion so that each condition occurs exactly once per block
    % Column of sBlock represents trials in block
    for b = 1:nblocks
        tt= 0;
        switch b
            case 1
                ccat = [1,2,3,4];
                x=1;
            case 2
                ccat = [5,6,7,8];
                x=1;
            case 3
                ccat = [2,3,4,5];
                x=3;
            case 4
                ccat = [6,7,8,1];
                x=3;
            case 5
                ccat = [3,4,5,6];
                x=5;
            case 6
                ccat = [7,8,1,2];
                x=5;
            case 7
                ccat = [4,5,6,7];
                x=7;
            case 8
                ccat = [8,1,2,3];
                x=7;
            case 9
                ccat = [1,2,5,6];
                x=9;
            case 10
                ccat = [3,4,7,8];
                x=9;
            case 11
                ccat = [2,3,6,7];
                x=11;
            case 12
                ccat = [1,4,5,8];
                x=11;
        end
        for c = ccat
            for p = 1:nphases
                tt=tt+1;
                sblock{tt,b} =          sounds{1,c}{randsound{c,1}(p,x),p};
                sblock{tt,b}.freq       = 'Theta';
                sblock{tt,b}.cat        = clabels{1, c};
                sblockt{tt,b}           = sounds{1,c}{randsound{c,1}(p,x+1),p}.name;
                
                tt =tt+1;
                sblock{tt,b}            = sounds{1,c}{randsound{c,1}(p,x+1),p};
                sblock{tt,b}.freq       = 'Theta';
                sblock{tt,b}.cat        = clabels{1, c};
                sblockt{tt,b}           = sounds{1,c}{randsound{c,1}(p,x+1),p}.name;
                
            end
        end
    end
    
    %% Encoding for Movies
    
    for b = 1:nblocks
        tt = 1;
        for c = 1:ncat
            for p = 1:nphases
                mblock{tt,b}           = m{c,1}{b+(nblocks*(p-1))};
                tt=tt+1;
            end
        end
    end
    
    
    %% Test Block
    
    tblock = sblock;
    choiceseq = [1:4;1:4;1:4;1:4;5:8;5:8;5:8;5:8;9:12;9:12;9:12;9:12;13:16;13:16;13:16;13:16]; % length as many as trials
    for b= 1:nblocks
        for i = 1:tblocks
            tblock{i,b}.moviename = [num2str(mblock{i,b}), '.avi'];
            randchoice = randsample(choiceseq(i,:),4);
            
            tblock{i,b}.movie1 = mblock{randchoice(1),b};
            tblock{i,b}.movie2 = mblock{randchoice(2),b};
            tblock{i,b}.movie3 = mblock{randchoice(3),b};
            tblock{i,b}.movie4 = mblock{randchoice(4),b};
            
            if      strcmp(tblock{i,b}.moviename,    [num2str(tblock{i,b}.movie1), '.avi'])
                tblock{i,b}.corrresp = 1;
            elseif  strcmp(tblock{i,b}.moviename,    [num2str(tblock{i,b}.movie2), '.avi'])
                tblock{i,b}.corrresp = 2;
            elseif  strcmp(tblock{i,b}.moviename,    [num2str(tblock{i,b}.movie3), '.avi'])
                tblock{i,b}.corrresp = 3;
            elseif  strcmp(tblock{i,b}.moviename,    [num2str(tblock{i,b}.movie4), '.avi'])
                tblock{i,b}.corrresp = 4;
            end
        end
    end
    
    %% permute the orders in each enclding block
    
    for b = 1:nblocks
        s(b,:) = randperm(tblocks);
    end
    
    % permute orders of block presention
    po = randperm(nblocks);
    
    % Create the CSV file
    mkdir([Basepath, '\Memory_Exp\csv\subj',num2str(subject)]);
    cd([Basepath, '\Memory_Exp\csv\subj',num2str(subject)]);
    
    for b = 1:nblocks
        for i = 1:tblocks
            blocks{b}{i,1} = i;
            blocks{b}{i,2} = [num2str(mblock{s(po(b),i),po(b)}), '.avi'];
            blocks{b}{i,3} = sblock{s(po(b),i),po(b)}.folder;
            blocks{b}{i,4} = [sblock{s(po(b),i),po(b)}.name,'.wav'];
            blocks{b}{i,5} = sblock{s(po(b),i),po(b)}.freq;
            blocks{b}{i,6} = sblock{s(po(b),i),po(b)}.phase;
            blocks{b}{i,7} = sblock{s(po(b),i),po(b)}.cat;
        end
        t = cell2table(blocks{b},'VariableNames',{'trialnumber','moviename','soundfolder','soundname','frequency','soundphase','soundcat'});
        writetable(t,['gtb_s',num2str(subject),'_block',num2str(b),'.csv'],'Delimiter',',','QuoteStrings',true);
    end
    
    save(['gtb_s',num2str(subject)],'blocks');
    
    %% permute the orders in each test block and create CSVs
    for b = 1:nblocks
        st(b,:) = randperm(tblocks);
    end
    
    for b = 1:nblocks
        for i = 1:tblocks
            blockt{b}{i,1}  = i;
            blockt{b}{i,2}  = tblock{st(po(b),i),po(b)}.moviename;
            blockt{b}{i,3}  = tblock{st(po(b),i),po(b)}.folder;
            blockt{b}{i,4}  = [tblock{st(po(b),i),po(b)}.name,'.wav'];
            blockt{b}{i,5}  = tblock{st(po(b),i),po(b)}.freq;
            blockt{b}{i,6}  = tblock{st(po(b),i),po(b)}.phase;
            blockt{b}{i,7}  = tblock{st(po(b),i),po(b)}.cat;
            blockt{b}{i,8}  = [num2str(tblock{st(po(b),i),po(b)}.movie1), '.avi'];
            blockt{b}{i,9}  = [num2str(tblock{st(po(b),i),po(b)}.movie2), '.avi'];
            blockt{b}{i,10} = [num2str(tblock{st(po(b),i),po(b)}.movie3), '.avi'];
            blockt{b}{i,11} = [num2str(tblock{st(po(b),i),po(b)}.movie4), '.avi'];
            blockt{b}{i,12} = tblock{st(po(b),i),po(b)}.corrresp;
        end
        t = cell2table(blockt{b},'VariableNames',{'trialnumber','moviename','soundfolder','soundname','frequency','soundphase','soundcat','movie1','movie2','movie3','movie4','correctresponse'});
        writetable(t,['gtb_t',num2str(subject),'_block',num2str(b),'.csv'],'Delimiter',',','QuoteStrings',true);
    end
    
    save(['gtb_t',num2str(subject)],'blockt');
end