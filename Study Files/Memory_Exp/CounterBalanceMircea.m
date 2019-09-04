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

rng('shuffle')

subject = 1;

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
    tt = 1;
    for c = 1:ncat
        for p = 1:nphases
                sblock{tt,b}           = sounds{1,c}{randsound{c,1}(p,b),p};
                sblock{tt,b}.freq      = 'Theta';
                sblock{tt,b}.cat       = clabels{1, c};
                sblockt{tt,b}          = sounds{1,c}{randsound{c,1}(p,b),p}.name;
                mblock{tt,b}           = m{c,1}(b+(nblocks*(p-1))); 
                tt =tt+1;
        end
    end
end

%% Test Block

tblock = sblock;
choiceseq = [1:2;1:2;3:4;3:4;5:6;5:6;7:8;7:8;9:10;9:10;11:12;11:12;13:14;13:14;15:16;15:16];

for i = 1:tblocks
    tblock{i,1}.moviename = mblock{i,1};
    randchoice = randsample(choiceseq(i,:),2);
    
    tblock{i,1}.movie1 = mblock{randchoice(1),1};
    tblock{i,1}.movie2 = mblock{randchoice(2),1}; 
    tblock{i,1}.movie3 = mblock{randchoice(3),1};
    tblock{i,1}.movie4 = mblock{randchoice(4),1};
    
    if strcmp(tblock{i,1}.moviename,tblock{i,1}.movie1)
        tblock{i,1}.corrresp = 1;
    elseif strcmp(tblock{i,1}.moviename,tblock{i,1}.movie2)
        tblock{i,1}.corrresp = 2;
    elseif strcmp(tblock{i,1}.moviename,tblock{i,1}.movie3)
        tblock{i,1}.corrresp = 3;
    elseif strcmp(tblock{i,1}.moviename,tblock{i,1}.movie4)
        tblock{i,1}.corrresp = 4;
    end
end