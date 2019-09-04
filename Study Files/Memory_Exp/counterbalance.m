clc
clear
Basepath = ['D:\Project\'];
cd([Basepath, '\Memory_Exp\csv']);
[~,~,sset1] = xlsread('material_sets_new','Sound','A2:A97');
[~,~,sset2] = xlsread('material_sets_new','Sound','B2:B97');

[~,~,mset1] = xlsread('material_sets_new','Movie','A2:A25');
[~,~,mset2] = xlsread('material_sets_new','Movie','B2:B25');
[~,~,mset3] = xlsread('material_sets_new','Movie','C2:C25');
[~,~,mset4] = xlsread('material_sets_new','Movie','D2:D25');
[~,~,mset5] = xlsread('material_sets_new','Movie','E2:E25');
[~,~,mset6] = xlsread('material_sets_new','Movie','F2:F25');
[~,~,mset7] = xlsread('material_sets_new','Movie','G2:G25');
[~,~,mset8] = xlsread('material_sets_new','Movie','H2:H25');

% modify here: subject-specific sound phase assignment
subject = 01;

sound_0     = sset1;
sound_180   = sset2;

for i = 1:numel(sset1)
    sound_0{i,2} = 0;
    sound_180{i,2} = 180;
    
    sound_0{i,3} = 'zero';
    sound_180{i,3} = 'oneeighty';
end

% modify here: subject-specific movie sound category assignment
ma = mset1;
mc = mset2;
md = mset3;
me = mset4;
mg = mset5;
mo = mset6;
ms = mset7;
my = mset8;


nblocks = 12;
ntrials = 192;
tblocks = 16;
session = 2;

%assign each sound to different blocks
for i = 1:nblocks
    acoustic{i,1}.name = ['sin-zero-',sound_0{i,1}];
    acoustic{i,2}.name = ['sin-oneeighty-', sound_180{i,1}];
    
    choir{i,1}.name = ['sin-zero-', sound_0{i+(nblocks*1),1}];
    choir{i,2}.name = ['sin-oneeighty-', sound_180{i+(nblocks*1),1}];

    dar{i,1}.name = ['sin-zero-', sound_0{i+(nblocks*2),1}];
    dar{i,2}.name = ['sin-oneeighty-', sound_180{i+(nblocks*2),1}];

    ep{i,1}.name = ['sin-zero-', sound_0{i+(nblocks*3),1}];
    ep{i,2}.name = ['sin-oneeighty-', sound_180{i+(nblocks*3),1}];

    guitar{i,1}.name = ['sin-zero-', sound_0{i+(nblocks*4),1}];
    guitar{i,2}.name = ['sin-oneeighty-', sound_180{i+(nblocks*4),1}];
    
    orch{i,1}.name = ['sin-zero-', sound_0{i+(nblocks*5),1}];
    orch{i,2}.name = ['sin-oneeighty-', sound_180{i+(nblocks*5),1}];
    
    synth{i,1}.name = ['sin-zero-', sound_0{i+(nblocks*6),1}];
    synth{i,2}.name = ['sin-oneeighty-', sound_180{i+(nblocks*6),1}];
    
    yann{i,1}.name = ['sin-zero-', sound_0{i+(nblocks*7),1}];
    yann{i,2}.name = ['sin-oneeighty-', sound_180{i+(nblocks*7),1}];
    
    acoustic{i,1}.phase = sound_0{i,2};
    acoustic{i,2}.phase = sound_180{i,2};
    
    choir{i,1}.phase = sound_0{i+(nblocks*1),2};
    choir{i,2}.phase = sound_180{i+(nblocks*1),2};
    
    dar{i,1}.phase = sound_0{i+(nblocks*2),2};
    dar{i,2}.phase = sound_180{i+(nblocks*2),2};
    
    ep{i,1}.phase = sound_0{i+(nblocks*3),2};
    ep{i,2}.phase = sound_180{i+(nblocks*3),2};
  
    guitar{i,1}.phase = sound_0{i+(nblocks*4),2};
    guitar{i,2}.phase = sound_180{i+(nblocks*4),2};
    
    orch{i,1}.phase = sound_0{i+(nblocks*5),2};
    orch{i,2}.phase = sound_180{i+(nblocks*5),2};

    synth{i,1}.phase = sound_0{i+(nblocks*6),2};
    synth{i,2}.phase = sound_180{i+(nblocks*6),2};
    
    yann{i,1}.phase = sound_0{i+(nblocks*7),2};
    yann{i,2}.phase = sound_180{i+(nblocks*7),2};
    
    acoustic{i,1}.folder = sound_0{i,3};
    acoustic{i,3}.folder = sound_180{i,3};
    
    choir{i,1}.folder = sound_0{i+(nblocks*1),3};
    choir{i,2}.folder = sound_180{i+(nblocks*1),3};

    dar{i,1}.folder = sound_0{i+(nblocks*2),3};
    dar{i,2}.folder = sound_180{i+(nblocks*2),3};

    ep{i,1}.folder = sound_0{i+(nblocks*3),3};
    ep{i,2}.folder = sound_180{i+(nblocks*3),3};

    guitar{i,1}.folder = sound_0{i+(nblocks*4),3};
    guitar{i,2}.folder = sound_180{i+(nblocks*4),3};
    
    orch{i,1}.folder = sound_0{i+(nblocks*5),3};
    orch{i,2}.folder = sound_180{i+(nblocks*5),3};
    
    synth{i,1}.folder = sound_0{i+(nblocks*6),3};
    synth{i,2}.folder = sound_180{i+(nblocks*6),3};
    
    yann{i,1}.folder = sound_0{i+(nblocks*7),3};
    yann{i,2}.folder = sound_180{i+(nblocks*7),3};
    
end

%change for each participant
%% block1-4: 1-2 block5-8: 3-4 block9-12: 5-6
%block1 sounds
for i = 1:2
    sblock{i,1} = acoustic{i,1};
    sblock{i+2,1} = choir{i,2};
    sblock{i+4,1} = dar{i,1};
    sblock{i+6,1} = ep{i,2};
    sblock{i+8,1} = guitar{i,1};
    sblock{i+10,1} = orch{i,2};
    sblock{i+12,1} = synth{i,1};
    sblock{i+14,1} = yann{i,2};
    
    sblock{i,1}.cat = 'acoustic';
    sblock{i+2,1}.cat = 'choir';
    sblock{i+4,1}.cat = 'dar';
    sblock{i+6,1}.cat = 'ep';
    sblock{i+8,1}.cat = 'guitar';
    sblock{i+10,1}.cat = 'orch';
    sblock{i+12,1}.cat = 'synth';
    sblock{i+14,1}.cat = 'yann';
    
    sblockt{i,1} = acoustic{i,1}.name;
    sblockt{i+2,1} = choir{i,2}.name;
    sblockt{i+4,1} = dar{i,1}.name;
    sblockt{i+6,1} = ep{i,2}.name;
    sblockt{i+8,1} = guitar{i,1}.name;
    sblockt{i+10,1} = orch{i,2}.name;
    sblockt{i+12,1} = synth{i,1}.name;
    sblockt{i+14,1} = yann{i,2}.name;
end
        
%block2 sounds
for i = 1:2
    sblock{i,2} = acoustic{i,2};
    sblock{i+2,2} = choir{i,1};
    sblock{i+4,2} = dar{i,2};
    sblock{i+6,2} = ep{i,1};
    sblock{i+8,2} = guitar{i,2};
    sblock{i+10,2} = orch{i,1};
    sblock{i+12,2} = synth{i,2};
    sblock{i+14,2} = yann{i,1};
    
    sblock{i,2}.cat = 'acoustic';
    sblock{i+2,2}.cat = 'choir';
    sblock{i+4,2}.cat = 'dar';
    sblock{i+6,2}.cat = 'ep';
    sblock{i+8,2}.cat = 'guitar';
    sblock{i+10,2}.cat = 'orch';
    sblock{i+12,2}.cat = 'synth';
    sblock{i+14,2}.cat = 'yann';
    
    sblockt{i,2} = acoustic{i,2}.name;
    sblockt{i+2,2} = choir{i,1}.name;
    sblockt{i+4,2} = dar{i,2}.name;
    sblockt{i+6,2} = ep{i,1}.name;
    sblockt{i+8,2} = guitar{i,2}.name;
    sblockt{i+10,2} = orch{i,1}.name;
    sblockt{i+12,2} = synth{i,2}.name;
    sblockt{i+14,2} = yann{i,1}.name;
end  

%block3 sounds
for i = 1:2
    sblock{i,3} = acoustic{i,1};
    sblock{i+2,3} = choir{i,2};
    sblock{i+4,3} = dar{i,1};
    sblock{i+6,3} = ep{i,2};
    sblock{i+8,3} = guitar{i,1};
    sblock{i+10,3} = orch{i,2};
    sblock{i+12,3} = synth{i,1};
    sblock{i+14,3} = yann{i,2};
    
    sblock{i,3}.cat = 'acoustic';
    sblock{i+2,3}.cat = 'choir';
    sblock{i+4,3}.cat = 'dar';
    sblock{i+6,3}.cat = 'ep';
    sblock{i+8,3}.cat = 'guitar';
    sblock{i+10,3}.cat = 'orch';
    sblock{i+12,3}.cat = 'synth';
    sblock{i+14,3}.cat = 'yann';
    
    sblockt{i,3} = acoustic{i,1}.name;
    sblockt{i+2,3} = choir{i,2}.name;
    sblockt{i+4,3} = dar{i,1}.name;
    sblockt{i+6,3} = ep{i,2}.name;
    sblockt{i+8,3} = guitar{i,1}.name;
    sblockt{i+10,3} = orch{i,2}.name;
    sblockt{i+12,3} = synth{i,1}.name;
    sblockt{i+14,3} = yann{i,2}.name;
end 

%block4 sounds
for i = 1:2
    sblock{i,4} = acoustic{i,2};
    sblock{i+2,4} = choir{i,1};
    sblock{i+4,4} = dar{i,2};
    sblock{i+6,4} = ep{i,1};
    sblock{i+8,4} = guitar{i,2};
    sblock{i+10,4} = orch{i,1};
    sblock{i+12,4} = synth{i,2};
    sblock{i+14,4} = yann{i,1};
    
    sblock{i,4}.cat = 'acoustic';
    sblock{i+2,4}.cat = 'choir';
    sblock{i+4,4}.cat = 'dar';
    sblock{i+6,4}.cat = 'ep';
    sblock{i+8,4}.cat = 'guitar';
    sblock{i+10,4}.cat = 'orch';
    sblock{i+12,4}.cat = 'synth';
    sblock{i+14,4}.cat = 'yann';
    
    sblockt{i,4} = acoustic{i,2}.name;
    sblockt{i+2,4} = choir{i,1}.name;
    sblockt{i+4,4} = dar{i,2}.name;
    sblockt{i+6,4} = ep{i,1}.name;
    sblockt{i+8,4} = guitar{i,2}.name;
    sblockt{i+10,4} = orch{i,1}.name;
    sblockt{i+12,4} = synth{i,2}.name;
    sblockt{i+14,4} = yann{i,1}.name;
end

%block5 sounds
for i = 3:4
    sblock{i-2,5} = acoustic{i,1};
    sblock{i,5} = choir{i,2};
    sblock{i+2,5} = dar{i,1};
    sblock{i+4,5} = ep{i,2};
    sblock{i+6,5} = guitar{i,1};
    sblock{i+8,5} = orch{i,2};
    sblock{i+10,5} = synth{i,1};
    sblock{i+12,5} = yann{i,2};
    
    sblock{i-2,5}.cat = 'acoustic';
    sblock{i,5}.cat = 'choir';
    sblock{i+2,5}.cat = 'dar';
    sblock{i+4,5}.cat = 'ep';
    sblock{i+6,5}.cat = 'guitar';
    sblock{i+8,5}.cat = 'orch';
    sblock{i+10,5}.cat = 'synth';
    sblock{i+12,5}.cat = 'yann';
    
    sblockt{i-2,5} = acoustic{i,1}.name;
    sblockt{i,5} = choir{i,2}.name;
    sblockt{i+2,5} = dar{i,1}.name;
    sblockt{i+4,5} = ep{i,2}.name;
    sblockt{i+6,5} = guitar{i,1}.name;
    sblockt{i+8,5} = orch{i,2}.name;
    sblockt{i+10,5} = synth{i,1}.name;
    sblockt{i+12,5} = yann{i,2}.name;
end
        
%block6 sounds
for i = 3:4
    sblock{i-2,6} = acoustic{i,2};
    sblock{i,6} = choir{i,1};
    sblock{i+2,6} = dar{i,2};
    sblock{i+4,6} = ep{i,1};
    sblock{i+6,6} = guitar{i,2};
    sblock{i+8,6} = orch{i,1};
    sblock{i+10,6} = synth{i,2};
    sblock{i+12,6} = yann{i,1};
    
    sblock{i-2,6}.cat = 'acoustic';
    sblock{i,6}.cat = 'choir';
    sblock{i+2,6}.cat = 'dar';
    sblock{i+4,6}.cat = 'ep';
    sblock{i+6,6}.cat = 'guitar';
    sblock{i+8,6}.cat = 'orch';
    sblock{i+10,6}.cat = 'synth';
    sblock{i+12,6}.cat = 'yann';
    
    sblockt{i-2,6} = acoustic{i,2}.name;
    sblockt{i,6} = choir{i,1}.name;
    sblockt{i+2,6} = dar{i,2}.name;
    sblockt{i+4,6} = ep{i,1}.name;
    sblockt{i+6,6} = guitar{i,2}.name;
    sblockt{i+8,6} = orch{i,1}.name;
    sblockt{i+10,6} = synth{i,2}.name;
    sblockt{i+12,6} = yann{i,1}.name;
end  

%block7 sounds
for i = 3:4
    sblock{i-2,7} = acoustic{i,1};
    sblock{i,7} = choir{i,2};
    sblock{i+2,7} = dar{i,1};
    sblock{i+4,7} = ep{i,2};
    sblock{i+6,7} = guitar{i,1};
    sblock{i+8,7} = orch{i,2};
    sblock{i+10,7} = synth{i,1};
    sblock{i+12,7} = yann{i,2};
    
    sblock{i-2,7}.cat = 'acoustic';
    sblock{i,7}.cat = 'choir';
    sblock{i+2,7}.cat = 'dar';
    sblock{i+4,7}.cat = 'ep';
    sblock{i+6,7}.cat = 'guitar';
    sblock{i+8,7}.cat = 'orch';
    sblock{i+10,7}.cat = 'synth';
    sblock{i+12,7}.cat = 'yann';
    
    sblockt{i-2,7} = acoustic{i,1}.name;
    sblockt{i,7} = choir{i,2}.name;
    sblockt{i+2,7} = dar{i,1}.name;
    sblockt{i+4,7} = ep{i,2}.name;
    sblockt{i+6,7} = guitar{i,1}.name;
    sblockt{i+8,7} = orch{i,2}.name;
    sblockt{i+10,7} = synth{i,1}.name;
    sblockt{i+12,7} = yann{i,2}.name;
end 

%block8 sounds
for i = 3:4
    sblock{i-2,8} = acoustic{i,2};
    sblock{i,8} = choir{i,1};
    sblock{i+2,8} = dar{i,2};
    sblock{i+4,8} = ep{i,1};
    sblock{i+6,8} = guitar{i,2};
    sblock{i+8,8} = orch{i,1};
    sblock{i+10,8} = synth{i,2};
    sblock{i+12,8} = yann{i,1};
    
    sblock{i-2,8}.cat = 'acoustic';
    sblock{i,8}.cat = 'choir';
    sblock{i+2,8}.cat = 'dar';
    sblock{i+4,8}.cat = 'ep';
    sblock{i+6,8}.cat = 'guitar';
    sblock{i+8,8}.cat = 'orch';
    sblock{i+10,8}.cat = 'synth';
    sblock{i+12,8}.cat = 'yann';
    
    sblockt{i-2,8} = acoustic{i,2}.name;
    sblockt{i,8} = choir{i,1}.name;
    sblockt{i+2,8} = dar{i,2}.name;
    sblockt{i+4,8} = ep{i,1}.name;
    sblockt{i+6,8} = guitar{i,2}.name;
    sblockt{i+8,8} = orch{i,1}.name;
    sblockt{i+10,8} = synth{i,2}.name;
    sblockt{i+12,8} = yann{i,1}.name;
end

%block9 sounds
for i = 5:6
    sblock{i-4,9} = acoustic{i,1};
    sblock{i-2,9} = choir{i,2};
    sblock{i,9} = dar{i,1};
    sblock{i+2,9} = ep{i,2};
    sblock{i+4,9} = guitar{i,1};
    sblock{i+6,9} = orch{i,2};
    sblock{i+8,9} = synth{i,1};
    sblock{i+10,9} = yann{i,2};
    
    sblock{i-4,9}.cat = 'acoustic';
    sblock{i-2,9}.cat = 'choir';
    sblock{i,9}.cat = 'dar';
    sblock{i+2,9}.cat = 'ep';
    sblock{i+4,9}.cat = 'guitar';
    sblock{i+6,9}.cat = 'orch';
    sblock{i+8,9}.cat = 'synth';
    sblock{i+10,9}.cat = 'yann';
    
    sblockt{i-4,9} = acoustic{i,1}.name;
    sblockt{i-2,9} = choir{i,2}.name;
    sblockt{i,9} = dar{i,1}.name;
    sblockt{i+2,9} = ep{i,2}.name;
    sblockt{i+4,9} = guitar{i,1}.name;
    sblockt{i+6,9} = orch{i,2}.name;
    sblockt{i+8,9} = synth{i,1}.name;
    sblockt{i+10,9} = yann{i,2}.name;
end
        
%block10 sounds
for i = 5:6
    sblock{i-4,10} = acoustic{i,2};
    sblock{i-2,10} = choir{i,1};
    sblock{i,10} = dar{i,2};
    sblock{i+2,10} = ep{i,1};
    sblock{i+4,10} = guitar{i,2};
    sblock{i+6,10} = orch{i,1};
    sblock{i+8,10} = synth{i,2};
    sblock{i+10,10} = yann{i,1};
    
    sblock{i-4,10}.cat = 'acoustic';
    sblock{i-2,10}.cat = 'choir';
    sblock{i,10}.cat = 'dar';
    sblock{i+2,10}.cat = 'ep';
    sblock{i+4,10}.cat = 'guitar';
    sblock{i+6,10}.cat = 'orch';
    sblock{i+8,10}.cat = 'synth';
    sblock{i+10,10}.cat = 'yann';
    
    sblockt{i-4,10} = acoustic{i,2}.name;
    sblockt{i-2,10} = choir{i,1}.name;
    sblockt{i,10} = dar{i,2}.name;
    sblockt{i+2,10} = ep{i,1}.name;
    sblockt{i+4,10} = guitar{i,2}.name;
    sblockt{i+6,10} = orch{i,1}.name;
    sblockt{i+8,10} = synth{i,2}.name;
    sblockt{i+10,10} = yann{i,1}.name;
end  

%block11 sounds
for i = 5:6
    sblock{i-4,11} = acoustic{i,1};
    sblock{i-2,11} = choir{i,2};
    sblock{i,11} = dar{i,1};
    sblock{i+2,11} = ep{i,2};
    sblock{i+4,11} = guitar{i,1};
    sblock{i+6,11} = orch{i,2};
    sblock{i+8,11} = synth{i,1};
    sblock{i+10,11} = yann{i,2};
    
    sblock{i-4,11}.cat = 'acoustic';
    sblock{i-2,11}.cat = 'choir';
    sblock{i,11}.cat = 'dar';
    sblock{i+2,11}.cat = 'ep';
    sblock{i+4,11}.cat = 'guitar';
    sblock{i+6,11}.cat = 'orch';
    sblock{i+8,11}.cat = 'synth';
    sblock{i+10,11}.cat = 'yann';
    
    sblockt{i-4,11} = acoustic{i,1}.name;
    sblockt{i-2,11} = choir{i,2}.name;
    sblockt{i,11} = dar{i,1}.name;
    sblockt{i+2,11} = ep{i,2}.name;
    sblockt{i+4,11} = guitar{i,1}.name;
    sblockt{i+6,11} = orch{i,2}.name;
    sblockt{i+8,11} = synth{i,1}.name;
    sblockt{i+10,11} = yann{i,2}.name;
end 

%block12 sounds
for i = 5:6
    sblock{i-4,12} = acoustic{i,2};
    sblock{i-2,12} = choir{i,1};
    sblock{i,12} = dar{i,2};
    sblock{i+2,12} = ep{i,1};
    sblock{i+4,12} = guitar{i,2};
    sblock{i+6,12} = orch{i,1};
    sblock{i+8,12} = synth{i,2};
    sblock{i+10,12} = yann{i,1};
    
    sblock{i-4,12}.cat = 'acoustic';
    sblock{i-2,12}.cat = 'choir';
    sblock{i,12}.cat = 'dar';
    sblock{i+2,12}.cat = 'ep';
    sblock{i+4,12}.cat = 'guitar';
    sblock{i+6,12}.cat = 'orch';
    sblock{i+8,12}.cat = 'synth';
    sblock{i+10,12}.cat = 'yann';
    
    sblockt{i-4,12} = acoustic{i,2}.name;
    sblockt{i-2,12} = choir{i,1}.name;
    sblockt{i,12} = dar{i,2}.name;
    sblockt{i+2,12} = ep{i,1}.name;
    sblockt{i+4,12} = guitar{i,2}.name;
    sblockt{i+6,12} = orch{i,1}.name;
    sblockt{i+8,12} = synth{i,2}.name;
    sblockt{i+10,12} = yann{i,1}.name;
end

%order change for each participant
%% assign each movie to each sound in different blocks
%block1 movies
for i = 1:2
    mblock{i,1} = ma{i,1};
    mblock{i+2,1} = mc{i,1};
    mblock{i+4,1} = md{i,1};
    mblock{i+6,1} = me{i,1};
    mblock{i+8,1} = mg{i,1};
    mblock{i+10,1} = mo{i,1};
    mblock{i+12,1} = ms{i,1};
    mblock{i+14,1} = my{i,1};
end

%block2 movies
for i = 3:4
    mblock{i-2,2} = ma{i,1};
    mblock{i,2} = mc{i,1};
    mblock{i+2,2} = md{i,1};
    mblock{i+4,2} = me{i,1};
    mblock{i+6,2} = mg{i,1};
    mblock{i+8,2} = mo{i,1};
    mblock{i+10,2} = ms{i,1};
    mblock{i+12,2} = my{i,1};
end

%block3 movies
for i = 5:6
    mblock{i-4,3} = ma{i,1};
    mblock{i-2,3} = mc{i,1};
    mblock{i,3} = md{i,1};
    mblock{i+2,3} = me{i,1};
    mblock{i+4,3} = mg{i,1};
    mblock{i+6,3} = mo{i,1};
    mblock{i+8,3} = ms{i,1};
    mblock{i+10,3} = my{i,1};
end

%block4 movies
for i = 7:8
    mblock{i-6,4} = ma{i,1};
    mblock{i-4,4} = mc{i,1};
    mblock{i-2,4} = md{i,1};
    mblock{i,4} = me{i,1};
    mblock{i+2,4} = mg{i,1};
    mblock{i+4,4} = mo{i,1};
    mblock{i+6,4} = ms{i,1};
    mblock{i+8,4} = my{i,1};
end

%block5 movies
for i = 9:10
    mblock{i-8,5} = ma{i,1};
    mblock{i-6,5} = mc{i,1};
    mblock{i-4,5} = md{i,1};
    mblock{i-2,5} = me{i,1};
    mblock{i,5} = mg{i,1};
    mblock{i+2,5} = mo{i,1};
    mblock{i+4,5} = ms{i,1};
    mblock{i+6,5} = my{i,1};
end

%block6 movies
for i = 11:12
    mblock{i-10,6} = ma{i,1};
    mblock{i-8,6} = mc{i,1};
    mblock{i-6,6} = md{i,1};
    mblock{i-4,6} = me{i,1};
    mblock{i-2,6} = mg{i,1};
    mblock{i,6} = mo{i,1};
    mblock{i+2,6} = ms{i,1};
    mblock{i+4,6} = my{i,1};
end

%block7 movies
for i = 13:14
    mblock{i-12,7} = ma{i,1};
    mblock{i-10,7} = mc{i,1};
    mblock{i-8,7} = md{i,1};
    mblock{i-6,7} = me{i,1};
    mblock{i-4,7} = mg{i,1};
    mblock{i-2,7} = mo{i,1};
    mblock{i,7} = ms{i,1};
    mblock{i+2,7} = my{i,1};
end

%block8 movies
for i = 15:16
    mblock{i-14,8} = ma{i,1};
    mblock{i-12,8} = mc{i,1};
    mblock{i-10,8} = md{i,1};
    mblock{i-8,8} = me{i,1};
    mblock{i-6,8} = mg{i,1};
    mblock{i-4,8} = mo{i,1};
    mblock{i-2,8} = ms{i,1};
    mblock{i,8} = my{i,1};
end

%block9 movies
for i = 17:18
    mblock{i-16,9} = ma{i,1};
    mblock{i-14,9} = mc{i,1};
    mblock{i-12,9} = md{i,1};
    mblock{i-10,9} = me{i,1};
    mblock{i-8,9} = mg{i,1};
    mblock{i-6,9} = mo{i,1};
    mblock{i-4,9} = ms{i,1};
    mblock{i-2,9} = my{i,1};
end

%block10 movies
for i = 19:20
    mblock{i-18,10} = ma{i,1};
    mblock{i-16,10} = mc{i,1};
    mblock{i-14,10} = md{i,1};
    mblock{i-12,10} = me{i,1};
    mblock{i-10,10} = mg{i,1};
    mblock{i-8,10} = mo{i,1};
    mblock{i-6,10} = ms{i,1};
    mblock{i-4,10} = my{i,1};
end

%block11 movies
for i = 21:22
    mblock{i-20,11} = ma{i,1};
    mblock{i-18,11} = mc{i,1};
    mblock{i-16,11} = md{i,1};
    mblock{i-14,11} = me{i,1};
    mblock{i-12,11} = mg{i,1};
    mblock{i-10,11} = mo{i,1};
    mblock{i-8,11} = ms{i,1};
    mblock{i-6,11} = my{i,1};
end

%block12 movies
for i = 23:24
    mblock{i-22,12} = ma{i,1};
    mblock{i-20,12} = mc{i,1};
    mblock{i-18,12} = md{i,1};
    mblock{i-16,12} = me{i,1};
    mblock{i-14,12} = mg{i,1};
    mblock{i-12,12} = mo{i,1};
    mblock{i-10,12} = ms{i,1};
    mblock{i-8,12} = my{i,1};
end

%permutate the orders in each block
rng('shuffle')
for b = 1:nblocks
    s(b,:) = randperm(tblocks);
end

%%

%create a .csv file
mkdir([Basepath, '/csv/subj',num2str(subject)]);
cd([Basepath, '/csv/subj',num2str(subject)]);
for b = 1:nblocks
    for i = 1:tblocks
        block{b}{i,1} = i;
        block{b}{i,2} = mblock{s(b,i),b};
        block{b}{i,3} = sblock{s(b,i),b}.folder;
        block{b}{i,4} = [sblock{s(b,i),b}.name,'.wav'];
        block{b}{i,5} = sblock{s(b,i),b}.phase;
        block{b}{i,6} = sblock{s(b,i),b}.cat;
    end
    t = cell2table(block{b},'VariableNames',{'trialnumber','moviename','soundfolder','soundname','soundphase','soundcat'});
    writetable(t,['gel_m',num2str(subject),'_block',num2str(b),'.csv'],'Delimiter',',','QuoteStrings',true);    
end
    