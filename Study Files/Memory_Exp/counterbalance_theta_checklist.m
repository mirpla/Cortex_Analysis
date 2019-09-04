clc
clear

cd '/Users/danying/Documents/Experiments/GTB/materials/materials_sheets'
[~,~,sset1] = xlsread('material_sets','Sound','A2:A33');
[~,~,sset2] = xlsread('material_sets','Sound','B2:B33');
[~,~,sset3] = xlsread('material_sets','Sound','C2:C33');
[~,~,sset4] = xlsread('material_sets','Sound','D2:D33');
[~,~,sset5] = xlsread('material_sets','Sound','E2:E33');
[~,~,sset6] = xlsread('material_sets','Sound','F2:F33');

[~,~,mset1] = xlsread('material_sets','Movie','A2:A25');
[~,~,mset2] = xlsread('material_sets','Movie','B2:B25');
[~,~,mset3] = xlsread('material_sets','Movie','C2:C25');
[~,~,mset4] = xlsread('material_sets','Movie','D2:D25');
[~,~,mset5] = xlsread('material_sets','Movie','E2:E25');
[~,~,mset6] = xlsread('material_sets','Movie','F2:F25');
[~,~,mset7] = xlsread('material_sets','Movie','G2:G25');
[~,~,mset8] = xlsread('material_sets','Movie','H2:H25');

rng('shuffle')

subject = 1;

% modify here: subject-specific sound phase assignment (refer to the
% counterbalance excel sheet2)
sound_0 = sset1; 
sound_90 = sset2; 
sound_180 = sset3; 
sound_270 = sset4;
sound_t0 = sset5;
sound_t180 = sset6;

for i = 1:numel(sset1)
    sound_0{i,2} = 0;
    sound_90{i,2} = 90;
    sound_180{i,2} = 180;
    sound_270{i,2} = 270;
    sound_t0{i,2} = 0;
    sound_t180{i,2} = 180;
    
    sound_0{i,3} = 'zero';
    sound_90{i,3} = 'ninety';
    sound_180{i,3} = 'oneeighty';
    sound_270{i,3} = 'twoseventy';
    sound_t0{i,3} = 'zero-4Hz';
    sound_t180{i,3} = 'oneeighty-4Hz';
end

% modify here: subject-specific movie sound category assignment (refer to
% the counterbalance excel sheet2)
% ma = mset1; % mc = mset2; % md = mset3; % me = mset4; % mg = mset5; % mo = mset6; % ms = mset7; % my = mset8;

%modify mset number
randseqa = randperm(numel(mset1));
randseqc = randperm(numel(mset2));
randseqd = randperm(numel(mset3));
randseqe = randperm(numel(mset4));
randseqg = randperm(numel(mset5));
randseqo = randperm(numel(mset6));
randseqs = randperm(numel(mset7));
randseqy = randperm(numel(mset8));

%modify mset number
for i = 1:numel(mset1)
    ma{i,1} = mset1{randseqa(i),1};
    mc{i,1} = mset2{randseqc(i),1};
    md{i,1} = mset3{randseqd(i),1};
    me{i,1} = mset4{randseqe(i),1};
    mg{i,1} = mset5{randseqg(i),1};
    mo{i,1} = mset6{randseqo(i),1};
    ms{i,1} = mset7{randseqs(i),1};
    my{i,1} = mset8{randseqy(i),1};
end

%get randomised trials for each sound category
for i = 1:4
    acoustic{i,1}.name = ['sin-zero-',sound_0{i,1}];
    acoustic{i,2}.name = ['sin-ninety-', sound_90{i,1}];
    acoustic{i,3}.name = ['sin-oneeighty-', sound_180{i,1}];
    acoustic{i,4}.name = ['sin-twoseventy-', sound_270{i,1}];
    acoustic{i,5}.name = ['sin-zero-4Hz-', sound_t0{i,1}];
    acoustic{i,6}.name = ['sin-oneeighty-4Hz-', sound_t180{i,1}];
    
    choir{i,1}.name = ['sin-zero-', sound_0{i+4,1}];
    choir{i,2}.name = ['sin-ninety-', sound_90{i+4,1}];
    choir{i,3}.name = ['sin-oneeighty-', sound_180{i+4,1}];
    choir{i,4}.name = ['sin-twoseventy-', sound_270{i+4,1}];
    choir{i,5}.name = ['sin-zero-4Hz-', sound_t0{i+4,1}];
    choir{i,6}.name = ['sin-oneeighty-4Hz-', sound_t180{i+4,1}];
    
    dar{i,1}.name = ['sin-zero-', sound_0{i+8,1}];
    dar{i,2}.name = ['sin-ninety-', sound_90{i+8,1}];
    dar{i,3}.name = ['sin-oneeighty-', sound_180{i+8,1}];
    dar{i,4}.name = ['sin-twoseventy-', sound_270{i+8,1}];
    dar{i,5}.name = ['sin-zero-4Hz-', sound_t0{i+8,1}];
    dar{i,6}.name = ['sin-oneeighty-4Hz-', sound_t180{i+8,1}];
    
    ep{i,1}.name = ['sin-zero-', sound_0{i+12,1}];
    ep{i,2}.name = ['sin-ninety-', sound_90{i+12,1}];
    ep{i,3}.name = ['sin-oneeighty-', sound_180{i+12,1}];
    ep{i,4}.name = ['sin-twoseventy-', sound_270{i+12,1}];
    ep{i,5}.name = ['sin-zero-4Hz-', sound_t0{i+12,1}];
    ep{i,6}.name = ['sin-oneeighty-4Hz-', sound_t180{i+12,1}];
    
    guitar{i,1}.name = ['sin-zero-', sound_0{i+16,1}];
    guitar{i,2}.name = ['sin-ninety-', sound_90{i+16,1}];
    guitar{i,3}.name = ['sin-oneeighty-', sound_180{i+16,1}];
    guitar{i,4}.name = ['sin-twoseventy-', sound_270{i+16,1}];
    guitar{i,5}.name = ['sin-zero-4Hz-', sound_t0{i+16,1}];
    guitar{i,6}.name = ['sin-oneeighty-4Hz-', sound_t180{i+16,1}];
    
    orch{i,1}.name = ['sin-zero-', sound_0{i+20,1}];
    orch{i,2}.name = ['sin-ninety-', sound_90{i+20,1}];
    orch{i,3}.name = ['sin-oneeighty-', sound_180{i+20,1}];
    orch{i,4}.name = ['sin-twoseventy-', sound_270{i+20,1}];
    orch{i,5}.name = ['sin-zero-4Hz-', sound_t0{i+20,1}];
    orch{i,6}.name = ['sin-oneeighty-4Hz-', sound_t180{i+20,1}];
    
    synth{i,1}.name = ['sin-zero-', sound_0{i+24,1}];
    synth{i,2}.name = ['sin-ninety-', sound_90{i+24,1}];
    synth{i,3}.name = ['sin-oneeighty-', sound_180{i+24,1}];
    synth{i,4}.name = ['sin-twoseventy-', sound_270{i+24,1}];
    synth{i,5}.name = ['sin-zero-4Hz-', sound_t0{i+24,1}];
    synth{i,6}.name = ['sin-oneeighty-4Hz-', sound_t180{i+24,1}];
    
    yann{i,1}.name = ['sin-zero-', sound_0{i+28,1}];
    yann{i,2}.name = ['sin-ninety-', sound_90{i+28,1}];
    yann{i,3}.name = ['sin-oneeighty-', sound_180{i+28,1}];
    yann{i,4}.name = ['sin-twoseventy-', sound_270{i+28,1}];
    yann{i,5}.name = ['sin-zero-4Hz-', sound_t0{i+28,1}];
    yann{i,6}.name = ['sin-oneeighty-4Hz-', sound_t180{i+28,1}];
    
    acoustic{i,1}.phase = sound_0{i,2};
    acoustic{i,2}.phase = sound_90{i,2};
    acoustic{i,3}.phase = sound_180{i,2};
    acoustic{i,4}.phase = sound_270{i,2};
    acoustic{i,5}.phase = sound_t0{i,2};
    acoustic{i,6}.phase = sound_t180{i,2};
    
    choir{i,1}.phase = sound_0{i+4,2};
    choir{i,2}.phase = sound_90{i+4,2};
    choir{i,3}.phase = sound_180{i+4,2};
    choir{i,4}.phase = sound_270{i+4,2};
    choir{i,5}.phase = sound_t0{i+4,2};
    choir{i,6}.phase = sound_t180{i+4,2};
    
    dar{i,1}.phase = sound_0{i+8,2};
    dar{i,2}.phase = sound_90{i+8,2};
    dar{i,3}.phase = sound_180{i+8,2};
    dar{i,4}.phase = sound_270{i+8,2};
    dar{i,5}.phase = sound_t0{i+8,2};
    dar{i,6}.phase = sound_t180{i+8,2};
    
    ep{i,1}.phase = sound_0{i+12,2};
    ep{i,2}.phase = sound_90{i+12,2};
    ep{i,3}.phase = sound_180{i+12,2};
    ep{i,4}.phase = sound_270{i+12,2};
    ep{i,5}.phase = sound_t0{i+12,2};
    ep{i,6}.phase = sound_t180{i+12,2};

    guitar{i,1}.phase = sound_0{i+16,2};
    guitar{i,2}.phase = sound_90{i+16,2};
    guitar{i,3}.phase = sound_180{i+16,2};
    guitar{i,4}.phase = sound_270{i+16,2};
    guitar{i,5}.phase = sound_t0{i+16,2};
    guitar{i,6}.phase = sound_t180{i+16,2};
    
    orch{i,1}.phase = sound_0{i+20,2};
    orch{i,2}.phase = sound_90{i+20,2};
    orch{i,3}.phase = sound_180{i+20,2};
    orch{i,4}.phase = sound_270{i+20,2};
    orch{i,5}.phase = sound_t0{i+20,2};
    orch{i,6}.phase = sound_t180{i+20,2};
    
    synth{i,1}.phase = sound_0{i+24,2};
    synth{i,2}.phase = sound_90{i+24,2};
    synth{i,3}.phase = sound_180{i+24,2};
    synth{i,4}.phase = sound_270{i+24,2};
    synth{i,5}.phase = sound_t0{i+24,2};
    synth{i,6}.phase = sound_t180{i+24,2};
    
    yann{i,1}.phase = sound_0{i+28,2};
    yann{i,2}.phase = sound_90{i+28,2};
    yann{i,3}.phase = sound_180{i+28,2};
    yann{i,4}.phase = sound_270{i+28,2};
    yann{i,5}.phase = sound_t0{i+28,2};
    yann{i,6}.phase = sound_t180{i+28,2};
    
    acoustic{i,1}.folder = sound_0{i,3};
    acoustic{i,2}.folder = sound_90{i,3};
    acoustic{i,3}.folder = sound_180{i,3};
    acoustic{i,4}.folder = sound_270{i,3};
    acoustic{i,5}.folder = sound_t0{i,3};
    acoustic{i,6}.folder = sound_t180{i,3};
    
    choir{i,1}.folder = sound_0{i+4,3};
    choir{i,2}.folder = sound_90{i+4,3};
    choir{i,3}.folder = sound_180{i+4,3};
    choir{i,4}.folder = sound_270{i+4,3};
    choir{i,5}.folder = sound_t0{i+4,3};
    choir{i,6}.folder = sound_t180{i+4,3};
    
    dar{i,1}.folder = sound_0{i+8,3};
    dar{i,2}.folder = sound_90{i+8,3};
    dar{i,3}.folder = sound_180{i+8,3};
    dar{i,4}.folder = sound_270{i+8,3};
    dar{i,5}.folder = sound_t0{i+8,3};
    dar{i,6}.folder = sound_t180{i+8,3};
    
    ep{i,1}.folder = sound_0{i+12,3};
    ep{i,2}.folder = sound_90{i+12,3};
    ep{i,3}.folder = sound_180{i+12,3};
    ep{i,4}.folder = sound_270{i+12,3};
    ep{i,5}.folder = sound_t0{i+12,3};
    ep{i,6}.folder = sound_t180{i+12,3};

    guitar{i,1}.folder = sound_0{i+16,3};
    guitar{i,2}.folder = sound_90{i+16,3};
    guitar{i,3}.folder = sound_180{i+16,3};
    guitar{i,4}.folder = sound_270{i+16,3};
    guitar{i,5}.folder = sound_t0{i+16,3};
    guitar{i,6}.folder = sound_t180{i+16,3};
    
    orch{i,1}.folder = sound_0{i+20,3};
    orch{i,2}.folder = sound_90{i+20,3};
    orch{i,3}.folder = sound_180{i+20,3};
    orch{i,4}.folder = sound_270{i+20,3};
    orch{i,5}.folder = sound_t0{i+20,3};
    orch{i,6}.folder = sound_t180{i+20,3};
    
    synth{i,1}.folder = sound_0{i+24,3};
    synth{i,2}.folder = sound_90{i+24,3};
    synth{i,3}.folder = sound_180{i+24,3};
    synth{i,4}.folder = sound_270{i+24,3};
    synth{i,5}.folder = sound_t0{i+24,3};
    synth{i,6}.folder = sound_t180{i+24,3};
    
    yann{i,1}.folder = sound_0{i+28,3};
    yann{i,2}.folder = sound_90{i+28,3};
    yann{i,3}.folder = sound_180{i+28,3};
    yann{i,4}.folder = sound_270{i+28,3};
    yann{i,5}.folder = sound_t0{i+28,3};
    yann{i,6}.folder = sound_t180{i+28,3};
    
end


%randomise the order of the trials in each sound category
for rs = 1:6
    randsa(rs,:) = randperm(4);
    randsc(rs,:) = randperm(4);
    randsd(rs,:) = randperm(4);
    randse(rs,:) = randperm(4);
    randsg(rs,:) = randperm(4);
    randso(rs,:) = randperm(4);
    randss(rs,:) = randperm(4);
    randsy(rs,:) = randperm(4);
end

%encoding block A
for i = 1:2 % amount of trials per category 
    sblock{i,1} = acoustic{randsa(1,i),1};
    sblock{i+2,1} = acoustic{randsa(2,i),2};
    sblock{i+4,1} = choir{randsc(3,i),3};
    sblock{i+6,1} = choir{randsc(4,i),4};
    sblock{i+8,1} = dar{randsd(5,i),5};
    sblock{i+10,1} = dar{randsd(6,i),6};
    
    sblock{i,1}.freq = 'Gamma';
    sblock{i+2,1}.freq = 'Gamma';
    sblock{i+4,1}.freq = 'Gamma';
    sblock{i+6,1}.freq = 'Gamma';
    sblock{i+8,1}.freq = 'Theta';
    sblock{i+10,1}.freq = 'Theta';
    
    sblock{i,1}.cat = 'acoustic';
    sblock{i+2,1}.cat = 'acoustic';
    sblock{i+4,1}.cat = 'choir';
    sblock{i+6,1}.cat = 'choir';
    sblock{i+8,1}.cat = 'dar';
    sblock{i+10,1}.cat = 'dar';
   
    sblockt{i,1} = acoustic{randsa(1,i),1}.name;
    sblockt{i+2,1} = acoustic{randsa(2,i),2}.name;
    sblockt{i+4,1} = choir{randsc(3,i),3}.name;
    sblockt{i+6,1} = choir{randsc(4,i),4}.name;
    sblockt{i+8,1} = dar{randsd(5,i),5}.name;
    sblockt{i+10,1} = dar{randsd(6,i),6}.name;    
end

%block B
for i = 1:2
    sblock{i,2} = ep{randse(1,i),1};
    sblock{i+2,2} = ep{randse(2,i),2};
    sblock{i+4,2} = guitar{randsg(3,i),3};
    sblock{i+6,2} = guitar{randsg(4,i),4};
    sblock{i+8,2} = orch{randso(5,i),5};
    sblock{i+10,2} = orch{randso(6,i),6};
    
    sblock{i,2}.freq = 'Gamma';
    sblock{i+2,2}.freq = 'Gamma';
    sblock{i+4,2}.freq = 'Gamma';
    sblock{i+6,2}.freq = 'Gamma';
    sblock{i+8,2}.freq = 'Theta';
    sblock{i+10,2}.freq = 'Theta';
    
    sblock{i,2}.cat = 'ep';
    sblock{i+2,2}.cat = 'ep';
    sblock{i+4,2}.cat = 'guitar';
    sblock{i+6,2}.cat = 'guitar';
    sblock{i+8,2}.cat = 'orch';
    sblock{i+10,2}.cat = 'orch';
    
    sblockt{i,2} = ep{randse(1,i),1}.name;
    sblockt{i+2,2} = ep{randse(2,i),2}.name;
    sblockt{i+4,2} = guitar{randsg(3,i),3}.name;
    sblockt{i+6,2} = guitar{randsg(4,i),4}.name;
    sblockt{i+8,2} = orch{randso(5,i),5}.name;
    sblockt{i+10,2} = orch{randso(6,i),6}.name;
end  

%block C
for i = 1:2
    sblock{i,3} = synth{randss(1,i),1};
    sblock{i+2,3} = synth{randss(2,i),2};
    sblock{i+4,3} = yann{randsy(3,i),3};
    sblock{i+6,3} = yann{randsy(4,i),4};
    sblock{i+8,3} = acoustic{randsa(5,i),5};
    sblock{i+10,3} = acoustic{randsa(6,i),6};
    
    sblock{i,3}.freq = 'Gamma';
    sblock{i+2,3}.freq = 'Gamma';
    sblock{i+4,3}.freq = 'Gamma';
    sblock{i+6,3}.freq = 'Gamma';
    sblock{i+8,3}.freq = 'Theta';
    sblock{i+10,3}.freq = 'Theta';
    
    sblock{i,3}.cat = 'synth';
    sblock{i+2,3}.cat = 'synth';
    sblock{i+4,3}.cat = 'yann';
    sblock{i+6,3}.cat = 'yann';
    sblock{i+8,3}.cat = 'acoustic';
    sblock{i+10,3}.cat = 'acoustic';
    
    sblockt{i,3} = synth{randss(1,i),1}.name;
    sblockt{i+2,3} = synth{randss(2,i),2}.name;
    sblockt{i+4,3} = yann{randsy(3,i),3}.name;
    sblockt{i+6,3} = yann{randsy(4,i),4}.name;
    sblockt{i+8,3} = acoustic{randsa(5,i),5}.name;
    sblockt{i+10,3} = acoustic{randsa(6,i),6}.name;
end  

%block D
for i = 1:2
    sblock{i,4} = choir{randsc(1,i),1};
    sblock{i+2,4} = choir{randsc(2,i),2};
    sblock{i+4,4} = dar{randsd(3,i),3};
    sblock{i+6,4} = dar{randsd(4,i),4};
    sblock{i+8,4} = ep{randse(5,i),5};
    sblock{i+10,4} = ep{randse(6,i),6};
    
    sblock{i,4}.freq = 'Gamma';
    sblock{i+2,4}.freq = 'Gamma';
    sblock{i+4,4}.freq = 'Gamma';
    sblock{i+6,4}.freq = 'Gamma';
    sblock{i+8,4}.freq = 'Theta';
    sblock{i+10,4}.freq = 'Theta';
    
    sblock{i,4}.cat = 'choir';
    sblock{i+2,4}.cat = 'choir';
    sblock{i+4,4}.cat = 'dar';
    sblock{i+6,4}.cat = 'dar';
    sblock{i+8,4}.cat = 'ep';
    sblock{i+10,4}.cat = 'ep';
    
    sblockt{i,4} = choir{randsc(1,i),1}.name;
    sblockt{i+2,4} = choir{randsc(2,i),2}.name;
    sblockt{i+4,4} = dar{randsd(3,i),3}.name;
    sblockt{i+6,4} = dar{randsd(4,i),4}.name;
    sblockt{i+8,4} = ep{randse(5,i),5}.name;
    sblockt{i+10,4} = ep{randse(6,i),6}.name;
end  

%block E
for i = 1:2
    sblock{i,5} = guitar{randsg(1,i),1};
    sblock{i+2,5} = guitar{randsg(2,i),2};
    sblock{i+4,5} = orch{randso(3,i),3};
    sblock{i+6,5} = orch{randso(4,i),4};
    sblock{i+8,5} = synth{randss(5,i),5};
    sblock{i+10,5} = synth{randss(6,i),6};
    
    sblock{i,5}.freq = 'Gamma';
    sblock{i+2,5}.freq = 'Gamma';
    sblock{i+4,5}.freq = 'Gamma';
    sblock{i+6,5}.freq = 'Gamma';
    sblock{i+8,5}.freq = 'Theta';
    sblock{i+10,5}.freq = 'Theta';
    
    sblock{i,5}.cat = 'guitar';
    sblock{i+2,5}.cat = 'guitar';
    sblock{i+4,5}.cat = 'orch';
    sblock{i+6,5}.cat = 'orch';
    sblock{i+8,5}.cat = 'synth';
    sblock{i+10,5}.cat = 'synth';
    
    sblockt{i,5} = guitar{randsg(1,i),1}.name;
    sblockt{i+2,5} = guitar{randsg(2,i),2}.name;
    sblockt{i+4,5} = orch{randso(3,i),3}.name;
    sblockt{i+6,5} = orch{randso(4,i),4}.name;
    sblockt{i+8,5} = synth{randss(5,i),5}.name;
    sblockt{i+10,5} = synth{randss(6,i),6}.name;
end  

%block F
for i = 1:2
    sblock{i,6} = yann{randsy(1,i),1};
    sblock{i+2,6} = yann{randsy(2,i),2};
    sblock{i+4,6} = acoustic{randsa(3,i),3};
    sblock{i+6,6} = acoustic{randsa(4,i),4};
    sblock{i+8,6} = choir{randsc(5,i),5};
    sblock{i+10,6} = choir{randsc(6,i),6};
    
    sblock{i,6}.freq = 'Gamma';
    sblock{i+2,6}.freq = 'Gamma';
    sblock{i+4,6}.freq = 'Gamma';
    sblock{i+6,6}.freq = 'Gamma';
    sblock{i+8,6}.freq = 'Theta';
    sblock{i+10,6}.freq = 'Theta';
    
    sblock{i,6}.cat = 'yann';
    sblock{i+2,6}.cat = 'yann';
    sblock{i+4,6}.cat = 'acoustic';
    sblock{i+6,6}.cat = 'acoustic';
    sblock{i+8,6}.cat = 'choir';
    sblock{i+10,6}.cat = 'choir';
    
    sblockt{i,6} = yann{randsy(1,i),1}.name;
    sblockt{i+2,6} = yann{randsy(2,i),2}.name;
    sblockt{i+4,6} = acoustic{randsa(3,i),3}.name;
    sblockt{i+6,6} = acoustic{randsa(4,i),4}.name;
    sblockt{i+8,6} = choir{randsc(5,i),5}.name;
    sblockt{i+10,6} = choir{randsc(6,i),6}.name;
end  

%block G
for i = 1:2
    sblock{i,7} = dar{randsd(1,i),1};
    sblock{i+2,7} = dar{randsd(2,i),2};
    sblock{i+4,7} = ep{randse(3,i),3};
    sblock{i+6,7} = ep{randse(4,i),4};
    sblock{i+8,7} = guitar{randsg(5,i),5};
    sblock{i+10,7} = guitar{randsg(6,i),6};
    
    sblock{i,7}.freq = 'Gamma';
    sblock{i+2,7}.freq = 'Gamma';
    sblock{i+4,7}.freq = 'Gamma';
    sblock{i+6,7}.freq = 'Gamma';
    sblock{i+8,7}.freq = 'Theta';
    sblock{i+10,7}.freq = 'Theta';
    
    sblock{i,7}.cat = 'dar';
    sblock{i+2,7}.cat = 'dar';
    sblock{i+4,7}.cat = 'ep';
    sblock{i+6,7}.cat = 'ep';
    sblock{i+8,7}.cat = 'guitar';
    sblock{i+10,7}.cat = 'guitar';
    
    sblockt{i,7} = dar{randsd(1,i),1}.name;
    sblockt{i+2,7} = dar{randsd(2,i),2}.name;
    sblockt{i+4,7} = ep{randse(3,i),3}.name;
    sblockt{i+6,7} = ep{randse(4,i),4}.name;
    sblockt{i+8,7} = guitar{randsg(5,i),5}.name;
    sblockt{i+10,7} = guitar{randsg(6,i),6}.name;
end  

%block H
for i = 1:2
    sblock{i,8} = orch{randso(1,i),1};
    sblock{i+2,8} = orch{randso(2,i),2};
    sblock{i+4,8} = synth{randss(3,i),3};
    sblock{i+6,8} = synth{randss(4,i),4};
    sblock{i+8,8} = yann{randsy(5,i),5};
    sblock{i+10,8} = yann{randsy(6,i),6};
    
    sblock{i,8}.freq = 'Gamma';
    sblock{i+2,8}.freq = 'Gamma';
    sblock{i+4,8}.freq = 'Gamma';
    sblock{i+6,8}.freq = 'Gamma';
    sblock{i+8,8}.freq = 'Theta';
    sblock{i+10,8}.freq = 'Theta';
    
    sblock{i,8}.cat = 'orch';
    sblock{i+2,8}.cat = 'orch';
    sblock{i+4,8}.cat = 'synth';
    sblock{i+6,8}.cat = 'synth';
    sblock{i+8,8}.cat = 'yann';
    sblock{i+10,8}.cat = 'yann';
    
    sblockt{i,8} = orch{randso(1,i),1}.name;
    sblockt{i+2,8} = orch{randso(2,i),2}.name;
    sblockt{i+4,8} = synth{randss(3,i),3}.name;
    sblockt{i+6,8} = synth{randss(4,i),4}.name;
    sblockt{i+8,8} = yann{randsy(5,i),5}.name;
    sblockt{i+10,8} = yann{randsy(6,i),6}.name;
end  

%block I
for i = 3:4
    sblock{i-2,9} = acoustic{randsa(1,i),1};
    sblock{i,9} = acoustic{randsa(2,i),2};
    sblock{i+2,9} = choir{randsc(3,i),3};
    sblock{i+4,9} = choir{randsc(4,i),4};
    sblock{i+6,9} = dar{randsd(5,i),5};
    sblock{i+8,9} = dar{randsd(6,i),6};
    
    sblock{i-2,9}.freq = 'Gamma';
    sblock{i,9}.freq = 'Gamma';
    sblock{i+2,9}.freq = 'Gamma';
    sblock{i+4,9}.freq = 'Gamma';
    sblock{i+6,9}.freq = 'Theta';
    sblock{i+8,9}.freq = 'Theta';
    
    sblock{i-2,9}.cat = 'acoustic';
    sblock{i,9}.cat = 'acoustic';
    sblock{i+2,9}.cat = 'choir';
    sblock{i+4,9}.cat = 'choir';
    sblock{i+6,9}.cat = 'dar';
    sblock{i+8,9}.cat = 'dar';
    
    sblockt{i-2,9} = acoustic{randsa(1,i),1}.name;
    sblockt{i,9} = acoustic{randsa(2,i),2}.name;
    sblockt{i+2,9} = choir{randsc(3,i),3}.name;
    sblockt{i+4,9} = choir{randsc(4,i),4}.name;
    sblockt{i+6,9} = dar{randsd(5,i),5}.name;
    sblockt{i+8,9} = dar{randsd(6,i),6}.name;
end

%block J
for i = 3:4
    sblock{i-2,10} = ep{randse(1,i),1};
    sblock{i,10} = ep{randse(2,i),2};
    sblock{i+2,10} = guitar{randsg(3,i),3};
    sblock{i+4,10} = guitar{randsg(4,i),4};
    sblock{i+6,10} = orch{randso(5,i),5};
    sblock{i+8,10} = orch{randso(6,i),6};
    
    sblock{i-2,10}.freq = 'Gamma';
    sblock{i,10}.freq = 'Gamma';
    sblock{i+2,10}.freq = 'Gamma';
    sblock{i+4,10}.freq = 'Gamma';
    sblock{i+6,10}.freq = 'Theta';
    sblock{i+8,10}.freq = 'Theta';
    
    sblock{i-2,10}.cat = 'ep';
    sblock{i,10}.cat = 'ep';
    sblock{i+2,10}.cat = 'guitar';
    sblock{i+4,10}.cat = 'guitar';
    sblock{i+6,10}.cat = 'orch';
    sblock{i+8,10}.cat = 'orch';
    
    sblockt{i-2,10} = ep{randse(1,i),1}.name;
    sblockt{i,10} = ep{randse(2,i),2}.name;
    sblockt{i+2,10} = guitar{randsg(3,i),3}.name;
    sblockt{i+4,10} = guitar{randsg(4,i),4}.name;
    sblockt{i+6,10} = orch{randso(5,i),5}.name;
    sblockt{i+8,10} = orch{randso(6,i),6}.name;
end

%block K
for i = 3:4
    sblock{i-2,11} = synth{randss(1,i),1};
    sblock{i,11} = synth{randss(2,i),2};
    sblock{i+2,11} = yann{randsy(3,i),3};
    sblock{i+4,11} = yann{randsy(4,i),4};
    sblock{i+6,11} = acoustic{randsa(5,i),5};
    sblock{i+8,11} = acoustic{randsa(6,i),6};
    
    sblock{i-2,11}.freq = 'Gamma';
    sblock{i,11}.freq = 'Gamma';
    sblock{i+2,11}.freq = 'Gamma';
    sblock{i+4,11}.freq = 'Gamma';
    sblock{i+6,11}.freq = 'Theta';
    sblock{i+8,11}.freq = 'Theta';
    
    sblock{i-2,11}.cat = 'synth';
    sblock{i,11}.cat = 'synth';
    sblock{i+2,11}.cat = 'yann';
    sblock{i+4,11}.cat = 'yann';
    sblock{i+6,11}.cat = 'acoustic';
    sblock{i+8,11}.cat = 'acoustic';
    
    sblockt{i-2,11} = synth{randss(1,i),1}.name;
    sblockt{i,11} = synth{randss(2,i),2}.name;
    sblockt{i+2,11} = yann{randsy(3,i),3}.name;
    sblockt{i+4,11} = yann{randsy(4,i),4}.name;
    sblockt{i+6,11} = acoustic{randsa(5,i),5}.name;
    sblockt{i+8,11} = acoustic{randsa(6,i),6}.name;
end

%block L
for i = 3:4
    sblock{i-2,12} = choir{randsc(1,i),1};
    sblock{i,12} = choir{randsc(2,i),2};
    sblock{i+2,12} = dar{randsd(3,i),3};
    sblock{i+4,12} = dar{randsd(4,i),4};
    sblock{i+6,12} = ep{randse(5,i),5};
    sblock{i+8,12} = ep{randse(6,i),6};
    
    sblock{i-2,12}.freq = 'Gamma';
    sblock{i,12}.freq = 'Gamma';
    sblock{i+2,12}.freq = 'Gamma';
    sblock{i+4,12}.freq = 'Gamma';
    sblock{i+6,12}.freq = 'Theta';
    sblock{i+8,12}.freq = 'Theta';
    
    sblock{i-2,12}.cat = 'choir';
    sblock{i,12}.cat = 'choir';
    sblock{i+2,12}.cat = 'dar';
    sblock{i+4,12}.cat = 'dar';
    sblock{i+6,12}.cat = 'ep';
    sblock{i+8,12}.cat = 'ep';
    
    sblockt{i-2,12} = choir{randsc(1,i),1}.name;
    sblockt{i,12} = choir{randsc(2,i),2}.name;
    sblockt{i+2,12} = dar{randsd(3,i),3}.name;
    sblockt{i+4,12} = dar{randsd(4,i),4}.name;
    sblockt{i+6,12} = ep{randse(5,i),5}.name;
    sblockt{i+8,12} = ep{randse(6,i),6}.name;
end

%block M
for i = 3:4
    sblock{i-2,13} = guitar{randsg(1,i),1};
    sblock{i,13} = guitar{randsg(2,i),2};
    sblock{i+2,13} = orch{randso(3,i),3};
    sblock{i+4,13} = orch{randso(4,i),4};
    sblock{i+6,13} = synth{randss(5,i),5};
    sblock{i+8,13} = synth{randss(6,i),6};
    
    sblock{i-2,13}.freq = 'Gamma';
    sblock{i,13}.freq = 'Gamma';
    sblock{i+2,13}.freq = 'Gamma';
    sblock{i+4,13}.freq = 'Gamma';
    sblock{i+6,13}.freq = 'Theta';
    sblock{i+8,13}.freq = 'Theta';
    
    sblock{i-2,13}.cat = 'guitar';
    sblock{i,13}.cat = 'guitar';
    sblock{i+2,13}.cat = 'orch';
    sblock{i+4,13}.cat = 'orch';
    sblock{i+6,13}.cat = 'synth';
    sblock{i+8,13}.cat = 'synth';
    
    sblockt{i-2,13} = guitar{randsg(1,i),1}.name;
    sblockt{i,13} = guitar{randsg(2,i),2}.name;
    sblockt{i+2,13} = orch{randso(3,i),3}.name;
    sblockt{i+4,13} = orch{randso(4,i),4}.name;
    sblockt{i+6,13} = synth{randss(5,i),5}.name;
    sblockt{i+8,13} = synth{randss(6,i),6}.name;
end

%block N
for i = 3:4
    sblock{i-2,14} = yann{randsy(1,i),1};
    sblock{i,14} = yann{randsy(2,i),2};
    sblock{i+2,14} = acoustic{randsa(3,i),3};
    sblock{i+4,14} = acoustic{randsa(4,i),4};
    sblock{i+6,14} = choir{randsc(5,i),5};
    sblock{i+8,14} = choir{randsc(6,i),6};
   
    sblock{i-2,14}.freq = 'Gamma';
    sblock{i,14}.freq = 'Gamma';
    sblock{i+2,14}.freq = 'Gamma';
    sblock{i+4,14}.freq = 'Gamma';
    sblock{i+6,14}.freq = 'Theta';
    sblock{i+8,14}.freq = 'Theta';
    
    sblock{i-2,14}.cat = 'yann';
    sblock{i,14}.cat = 'yann';
    sblock{i+2,14}.cat = 'acoustic';
    sblock{i+4,14}.cat = 'acoustic';
    sblock{i+6,14}.cat = 'choir';
    sblock{i+8,14}.cat = 'choir';
    
    sblockt{i-2,14} = yann{randsy(1,i),1}.name;
    sblockt{i,14} = yann{randsy(2,i),2}.name;
    sblockt{i+2,14} = acoustic{randsa(3,i),3}.name;
    sblockt{i+4,14} = acoustic{randsa(4,i),4}.name;
    sblockt{i+6,14} = choir{randsc(5,i),5}.name;
    sblockt{i+8,14} = choir{randsc(6,i),6}.name;
end

%block O
for i = 3:4
    sblock{i-2,15} = dar{randsd(1,i),1};
    sblock{i,15} = dar{randsd(2,i),2};
    sblock{i+2,15} = ep{randse(3,i),3};
    sblock{i+4,15} = ep{randse(4,i),4};
    sblock{i+6,15} = guitar{randsg(5,i),5};
    sblock{i+8,15} = guitar{randsg(6,i),6};
   
    sblock{i-2,15}.freq = 'Gamma';
    sblock{i,15}.freq = 'Gamma';
    sblock{i+2,15}.freq = 'Gamma';
    sblock{i+4,15}.freq = 'Gamma';
    sblock{i+6,15}.freq = 'Theta';
    sblock{i+8,15}.freq = 'Theta';
    
    sblock{i-2,15}.cat = 'dar';
    sblock{i,15}.cat = 'dar';
    sblock{i+2,15}.cat = 'ep';
    sblock{i+4,15}.cat = 'ep';
    sblock{i+6,15}.cat = 'guitar';
    sblock{i+8,15}.cat = 'guitar';
    
    sblockt{i-2,15} = dar{randsd(1,i),1}.name;
    sblockt{i,15} = dar{randsd(2,i),2}.name;
    sblockt{i+2,15} = ep{randse(3,i),3}.name;
    sblockt{i+4,15} = ep{randse(4,i),4}.name;
    sblockt{i+6,15} = guitar{randsg(5,i),5}.name;
    sblockt{i+8,15} = guitar{randsg(6,i),6}.name;
end

%block P
for i = 3:4
    sblock{i-2,16} = orch{randso(1,i),1};
    sblock{i,16} = orch{randso(2,i),2};
    sblock{i+2,16} = synth{randss(3,i),3};
    sblock{i+4,16} = synth{randss(4,i),4};
    sblock{i+6,16} = yann{randsy(5,i),5};
    sblock{i+8,16} = yann{randsy(6,i),6};
   
    sblock{i-2,16}.freq = 'Gamma';
    sblock{i,16}.freq = 'Gamma';
    sblock{i+2,16}.freq = 'Gamma';
    sblock{i+4,16}.freq = 'Gamma';
    sblock{i+6,16}.freq = 'Theta';
    sblock{i+8,16}.freq = 'Theta';
    
    sblock{i-2,16}.cat = 'orch';
    sblock{i,16}.cat = 'orch';
    sblock{i+2,16}.cat = 'synth';
    sblock{i+4,16}.cat = 'synth';
    sblock{i+6,16}.cat = 'yann';
    sblock{i+8,16}.cat = 'yann';
    
    sblockt{i-2,16} = orch{randso(1,i),1}.name;
    sblockt{i,16} = orch{randso(2,i),2}.name;
    sblockt{i+2,16} = synth{randss(3,i),3}.name;
    sblockt{i+4,16} = synth{randss(4,i),4}.name;
    sblockt{i+6,16} = yann{randsy(5,i),5}.name;
    sblockt{i+8,16} = yann{randsy(6,i),6}.name;
end

%block A movies
for i = 1:4
    mblock{i,1} = ma{i,1};
    mblock{i+4,1} = mc{i,1};
    %mblock{i+8,1} = [md{i,1}(1:9),'4Hz',md{i,1}(16:end)];
end

%block B movies
for i = 1:4
    mblock{i,2} = me{i,1};
    mblock{i+4,2} = mg{i,1};
    %mblock{i+8,2} = [mo{i,1}(1:9),'4Hz',mo{i,1}(16:end)];
end

%block C movies
for i = 1:4
    mblock{i,3} = ms{i,1};
    mblock{i+4,3} = my{i,1};
    %mblock{i+8,3} = [ma{i+4,1}(1:9),'4Hz',ma{i+4,1}(16:end)];
end

%block D movies
for i = 1:4
    mblock{i,4} = mc{i+4,1};
    mblock{i+4,4} = md{i+4,1};
    %mblock{i+8,4} = [me{i+4,1}(1:9),'4Hz',me{i+4,1}(16:end)];
end

%block E movies
for i = 1:4
    mblock{i,5} = mg{i+4,1};
    mblock{i+4,5} = mo{i+4,1};
    %mblock{i+8,5} = [ms{i+4,1}(1:9),'4Hz',ms{i+4,1}(16:end)];
end

%block F movies
for i = 1:4
    mblock{i,6} = my{i+4,1};
    mblock{i+4,6} = ma{i+8,1};
    %mblock{i+8,6} = [mc{i+8,1}(1:9),'4Hz',mc{i+8,1}(16:end)];
end

%block G movies
for i = 1:4
    mblock{i,7} = md{i+8,1};
    mblock{i+4,7} = me{i+8,1};
    %mblock{i+8,7} = [mg{i+8,1}(1:9),'4Hz',mg{i+8,1}(16:end)];
end

%block H movies
for i = 1:4
    mblock{i,8} = mo{i+8,1};
    mblock{i+4,8} = ms{i+8,1};
    %mblock{i+8,8} = [my{i+8,1}(1:9),'4Hz',my{i+8,1}(16:end)];
end

%block I movies
for i = 1:4
    mblock{i,9} = ma{i+12,1};
    mblock{i+4,9} = mc{i+12,1};
   % mblock{i+8,9} = [md{i+12,1}(1:9),'4Hz',md{i+12,1}(16:end)];
end

%block J movies
for i = 1:4
    mblock{i,10} = me{i+12,1};
    mblock{i+4,10} = mg{i+12,1};
    %mblock{i+8,10} = [mo{i+12,1}(1:9),'4Hz',mo{i+12,1}(16:end)];
end

%block K movies
for i = 1:4
    mblock{i,11} = ms{i+12,1};
    mblock{i+4,11} = my{i+12,1};
    %mblock{i+8,11} = [ma{i+16,1}(1:9),'4Hz',ma{i+16,1}(16:end)];
end

%block L movies
for i = 1:4
    mblock{i,12} = mc{i+16,1};
    mblock{i+4,12} = md{i+16,1};
    %mblock{i+8,12} = [me{i+16,1}(1:9),'4Hz',me{i+16,1}(16:end)];
end

%block M movies
for i = 1:4
    mblock{i,13} = mg{i+16,1};
    mblock{i+4,13} = mo{i+16,1};
    %mblock{i+8,13} = [ms{i+16,1}(1:9),'4Hz',ms{i+16,1}(16:end)];
end

%block N movies
for i = 1:4
    mblock{i,14} = my{i+16,1};
    mblock{i+4,14} = ma{i+20,1};
    %mblock{i+8,14} = [mc{i+20,1}(1:9),'4Hz',mc{i+20,1}(16:end)];
end

%block O movies
for i = 1:4
    mblock{i,15} = md{i+20,1};
    mblock{i+4,15} = me{i+20,1};
    %mblock{i+8,15} = [mg{i+20,1}(1:9),'4Hz',mg{i+20,1}(16:end)];
end

%block P movies
for i = 1:4
    mblock{i,16} = mo{i+20,1};
    mblock{i+4,16} = ms{i+20,1};
    %mblock{i+8,16} = [my{i+20,1}(1:9),'4Hz',my{i+20,1}(16:end)];
end

% test block A
tblock = sblock;
choiceseq = [1:4;1:4;1:4;1:4;5:8;5:8;5:8;5:8;9:12;9:12;9:12;9:12];
for i = 1:12
    tblock{i,1}.moviename = mblock{i,1};
    randchoice = randsample(choiceseq(i,:),4);
    
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

% test block B
for i = 1:12
    tblock{i,2}.moviename = mblock{i,2};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,2}.movie1 = mblock{randchoice(1),2};
    tblock{i,2}.movie2 = mblock{randchoice(2),2}; 
    tblock{i,2}.movie3 = mblock{randchoice(3),2};
    tblock{i,2}.movie4 = mblock{randchoice(4),2};
    
    if strcmp(tblock{i,2}.moviename,tblock{i,2}.movie1)
        tblock{i,2}.corrresp = 1;
    elseif strcmp(tblock{i,2}.moviename,tblock{i,2}.movie2)
        tblock{i,2}.corrresp = 2;
    elseif strcmp(tblock{i,2}.moviename,tblock{i,2}.movie3)
        tblock{i,2}.corrresp = 3;
    elseif strcmp(tblock{i,2}.moviename,tblock{i,2}.movie4)
        tblock{i,2}.corrresp = 4;
    end
end

% test block C
for i = 1:12
    tblock{i,3}.moviename = mblock{i,3};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,3}.movie1 = mblock{randchoice(1),3};
    tblock{i,3}.movie2 = mblock{randchoice(2),3}; 
    tblock{i,3}.movie3 = mblock{randchoice(3),3};
    tblock{i,3}.movie4 = mblock{randchoice(4),3};
    
    if strcmp(tblock{i,3}.moviename,tblock{i,3}.movie1)
        tblock{i,3}.corrresp = 1;
    elseif strcmp(tblock{i,3}.moviename,tblock{i,3}.movie2)
        tblock{i,3}.corrresp = 2;
    elseif strcmp(tblock{i,3}.moviename,tblock{i,3}.movie3)
        tblock{i,3}.corrresp = 3;
    elseif strcmp(tblock{i,3}.moviename,tblock{i,3}.movie4)
        tblock{i,3}.corrresp = 4;
    end
end

% test block D
for i = 1:12
    tblock{i,4}.moviename = mblock{i,4};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,4}.movie1 = mblock{randchoice(1),4};
    tblock{i,4}.movie2 = mblock{randchoice(2),4}; 
    tblock{i,4}.movie3 = mblock{randchoice(3),4};
    tblock{i,4}.movie4 = mblock{randchoice(4),4};
    
    if strcmp(tblock{i,4}.moviename,tblock{i,4}.movie1)
        tblock{i,4}.corrresp = 1;
    elseif strcmp(tblock{i,4}.moviename,tblock{i,4}.movie2)
        tblock{i,4}.corrresp = 2;
    elseif strcmp(tblock{i,4}.moviename,tblock{i,4}.movie3)
        tblock{i,4}.corrresp = 3;
    elseif strcmp(tblock{i,4}.moviename,tblock{i,4}.movie4)
        tblock{i,4}.corrresp = 4;
    end
end

% test block E
for i = 1:12
    tblock{i,5}.moviename = mblock{i,5};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,5}.movie1 = mblock{randchoice(1),5};
    tblock{i,5}.movie2 = mblock{randchoice(2),5}; 
    tblock{i,5}.movie3 = mblock{randchoice(3),5};
    tblock{i,5}.movie4 = mblock{randchoice(4),5};
    
    if strcmp(tblock{i,5}.moviename,tblock{i,5}.movie1)
        tblock{i,5}.corrresp = 1;
    elseif strcmp(tblock{i,5}.moviename,tblock{i,5}.movie2)
        tblock{i,5}.corrresp = 2;
    elseif strcmp(tblock{i,5}.moviename,tblock{i,5}.movie3)
        tblock{i,5}.corrresp = 3;
    elseif strcmp(tblock{i,5}.moviename,tblock{i,5}.movie4)
        tblock{i,5}.corrresp = 4;
    end
end

% test block F
for i = 1:12
    tblock{i,6}.moviename = mblock{i,6};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,6}.movie1 = mblock{randchoice(1),6};
    tblock{i,6}.movie2 = mblock{randchoice(2),6}; 
    tblock{i,6}.movie3 = mblock{randchoice(3),6};
    tblock{i,6}.movie4 = mblock{randchoice(4),6};
    
    if strcmp(tblock{i,6}.moviename,tblock{i,6}.movie1)
        tblock{i,6}.corrresp = 1;
    elseif strcmp(tblock{i,6}.moviename,tblock{i,6}.movie2)
        tblock{i,6}.corrresp = 2;
    elseif strcmp(tblock{i,6}.moviename,tblock{i,6}.movie3)
        tblock{i,6}.corrresp = 3;
    elseif strcmp(tblock{i,6}.moviename,tblock{i,6}.movie4)
        tblock{i,6}.corrresp = 4;
    end
end

% test block G
for i = 1:12
    tblock{i,7}.moviename = mblock{i,7};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,7}.movie1 = mblock{randchoice(1),7};
    tblock{i,7}.movie2 = mblock{randchoice(2),7}; 
    tblock{i,7}.movie3 = mblock{randchoice(3),7};
    tblock{i,7}.movie4 = mblock{randchoice(4),7};
    
    if strcmp(tblock{i,7}.moviename,tblock{i,7}.movie1)
        tblock{i,7}.corrresp = 1;
    elseif strcmp(tblock{i,7}.moviename,tblock{i,7}.movie2)
        tblock{i,7}.corrresp = 2;
    elseif strcmp(tblock{i,7}.moviename,tblock{i,7}.movie3)
        tblock{i,7}.corrresp = 3;
    elseif strcmp(tblock{i,7}.moviename,tblock{i,7}.movie4)
        tblock{i,7}.corrresp = 4;
    end
end

% test block H
for i = 1:12
    tblock{i,8}.moviename = mblock{i,8};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,8}.movie1 = mblock{randchoice(1),8};
    tblock{i,8}.movie2 = mblock{randchoice(2),8}; 
    tblock{i,8}.movie3 = mblock{randchoice(3),8};
    tblock{i,8}.movie4 = mblock{randchoice(4),8};
    
    if strcmp(tblock{i,8}.moviename,tblock{i,8}.movie1)
        tblock{i,8}.corrresp = 1;
    elseif strcmp(tblock{i,8}.moviename,tblock{i,8}.movie2)
        tblock{i,8}.corrresp = 2;
    elseif strcmp(tblock{i,8}.moviename,tblock{i,8}.movie3)
        tblock{i,8}.corrresp = 3;
    elseif strcmp(tblock{i,8}.moviename,tblock{i,8}.movie4)
        tblock{i,8}.corrresp = 4;
    end
end

% test block I
for i = 1:12
    tblock{i,9}.moviename = mblock{i,9};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,9}.movie1 = mblock{randchoice(1),9};
    tblock{i,9}.movie2 = mblock{randchoice(2),9}; 
    tblock{i,9}.movie3 = mblock{randchoice(3),9};
    tblock{i,9}.movie4 = mblock{randchoice(4),9};
    
    if strcmp(tblock{i,9}.moviename,tblock{i,9}.movie1)
        tblock{i,9}.corrresp = 1;
    elseif strcmp(tblock{i,9}.moviename,tblock{i,9}.movie2)
        tblock{i,9}.corrresp = 2;
    elseif strcmp(tblock{i,9}.moviename,tblock{i,9}.movie3)
        tblock{i,9}.corrresp = 3;
    elseif strcmp(tblock{i,9}.moviename,tblock{i,9}.movie4)
        tblock{i,9}.corrresp = 4;
    end
end

% test block J
for i = 1:12
    tblock{i,10}.moviename = mblock{i,10};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,10}.movie1 = mblock{randchoice(1),10};
    tblock{i,10}.movie2 = mblock{randchoice(2),10}; 
    tblock{i,10}.movie3 = mblock{randchoice(3),10};
    tblock{i,10}.movie4 = mblock{randchoice(4),10};
    
    if strcmp(tblock{i,10}.moviename,tblock{i,10}.movie1)
        tblock{i,10}.corrresp = 1;
    elseif strcmp(tblock{i,10}.moviename,tblock{i,10}.movie2)
        tblock{i,10}.corrresp = 2;
    elseif strcmp(tblock{i,10}.moviename,tblock{i,10}.movie3)
        tblock{i,10}.corrresp = 3;
    elseif strcmp(tblock{i,10}.moviename,tblock{i,10}.movie4)
        tblock{i,10}.corrresp = 4;
    end
end

% test block K
for i = 1:12
    tblock{i,11}.moviename = mblock{i,11};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,11}.movie1 = mblock{randchoice(1),11};
    tblock{i,11}.movie2 = mblock{randchoice(2),11}; 
    tblock{i,11}.movie3 = mblock{randchoice(3),11};
    tblock{i,11}.movie4 = mblock{randchoice(4),11};
    
    if strcmp(tblock{i,11}.moviename,tblock{i,11}.movie1)
        tblock{i,11}.corrresp = 1;
    elseif strcmp(tblock{i,11}.moviename,tblock{i,11}.movie2)
        tblock{i,11}.corrresp = 2;
    elseif strcmp(tblock{i,11}.moviename,tblock{i,11}.movie3)
        tblock{i,11}.corrresp = 3;
    elseif strcmp(tblock{i,11}.moviename,tblock{i,11}.movie4)
        tblock{i,11}.corrresp = 4;
    end
end

% test block L
for i = 1:12
    tblock{i,12}.moviename = mblock{i,12};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,12}.movie1 = mblock{randchoice(1),12};
    tblock{i,12}.movie2 = mblock{randchoice(2),12}; 
    tblock{i,12}.movie3 = mblock{randchoice(3),12};
    tblock{i,12}.movie4 = mblock{randchoice(4),12};
    
    if strcmp(tblock{i,12}.moviename,tblock{i,12}.movie1)
        tblock{i,12}.corrresp = 1;
    elseif strcmp(tblock{i,12}.moviename,tblock{i,12}.movie2)
        tblock{i,12}.corrresp = 2;
    elseif strcmp(tblock{i,12}.moviename,tblock{i,12}.movie3)
        tblock{i,12}.corrresp = 3;
    elseif strcmp(tblock{i,12}.moviename,tblock{i,12}.movie4)
        tblock{i,12}.corrresp = 4;
    end
end

% test block M
for i = 1:12
    tblock{i,13}.moviename = mblock{i,13};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,13}.movie1 = mblock{randchoice(1),13};
    tblock{i,13}.movie2 = mblock{randchoice(2),13}; 
    tblock{i,13}.movie3 = mblock{randchoice(3),13};
    tblock{i,13}.movie4 = mblock{randchoice(4),13};
    
    if strcmp(tblock{i,13}.moviename,tblock{i,13}.movie1)
        tblock{i,13}.corrresp = 1;
    elseif strcmp(tblock{i,13}.moviename,tblock{i,13}.movie2)
        tblock{i,13}.corrresp = 2;
    elseif strcmp(tblock{i,13}.moviename,tblock{i,13}.movie3)
        tblock{i,13}.corrresp = 3;
    elseif strcmp(tblock{i,13}.moviename,tblock{i,13}.movie4)
        tblock{i,13}.corrresp = 4;
    end
end

% test block N
for i = 1:12
    tblock{i,14}.moviename = mblock{i,14};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,14}.movie1 = mblock{randchoice(1),14};
    tblock{i,14}.movie2 = mblock{randchoice(2),14}; 
    tblock{i,14}.movie3 = mblock{randchoice(3),14};
    tblock{i,14}.movie4 = mblock{randchoice(4),14};
    
    if strcmp(tblock{i,14}.moviename,tblock{i,14}.movie1)
        tblock{i,14}.corrresp = 1;
    elseif strcmp(tblock{i,14}.moviename,tblock{i,14}.movie2)
        tblock{i,14}.corrresp = 2;
    elseif strcmp(tblock{i,14}.moviename,tblock{i,14}.movie3)
        tblock{i,14}.corrresp = 3;
    elseif strcmp(tblock{i,14}.moviename,tblock{i,14}.movie4)
        tblock{i,14}.corrresp = 4;
    end
end

% test block O
for i = 1:12
    tblock{i,15}.moviename = mblock{i,15};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,15}.movie1 = mblock{randchoice(1),15};
    tblock{i,15}.movie2 = mblock{randchoice(2),15}; 
    tblock{i,15}.movie3 = mblock{randchoice(3),15};
    tblock{i,15}.movie4 = mblock{randchoice(4),15};
    
    if strcmp(tblock{i,15}.moviename,tblock{i,15}.movie1)
        tblock{i,15}.corrresp = 1;
    elseif strcmp(tblock{i,15}.moviename,tblock{i,15}.movie2)
        tblock{i,15}.corrresp = 2;
    elseif strcmp(tblock{i,15}.moviename,tblock{i,15}.movie3)
        tblock{i,15}.corrresp = 3;
    elseif strcmp(tblock{i,15}.moviename,tblock{i,15}.movie4)
        tblock{i,15}.corrresp = 4;
    end
end

% test block P
for i = 1:12
    tblock{i,16}.moviename = mblock{i,16};
    randchoice = randsample(choiceseq(i,:),4);
    
    tblock{i,16}.movie1 = mblock{randchoice(1),16};
    tblock{i,16}.movie2 = mblock{randchoice(2),16}; 
    tblock{i,16}.movie3 = mblock{randchoice(3),16};
    tblock{i,16}.movie4 = mblock{randchoice(4),16};
    
    if strcmp(tblock{i,16}.moviename,tblock{i,16}.movie1)
        tblock{i,16}.corrresp = 1;
    elseif strcmp(tblock{i,16}.moviename,tblock{i,16}.movie2)
        tblock{i,16}.corrresp = 2;
    elseif strcmp(tblock{i,16}.moviename,tblock{i,16}.movie3)
        tblock{i,16}.corrresp = 3;
    elseif strcmp(tblock{i,16}.moviename,tblock{i,16}.movie4)
        tblock{i,16}.corrresp = 4;
    end
end

%permutate the orders in each block
for b = 1:16
    s(b,:) = randperm(12);
end

%permutate the orders of block presentation
po = randperm(16);

%create a .csv file
mkdir(['/Users/danying/Documents/Experiments/GTB/csv/subj',num2str(subject)]);
cd(['/Users/danying/Documents/Experiments/GTB/csv/subj',num2str(subject)]);

for b = 1:16
    for i = 1:12
        blocks{b}{i,1} = i;
        blocks{b}{i,2} = mblock{s(po(b),i),po(b)};
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

%permutate the orders in each test block
for b = 1:16
    st(b,:) = randperm(12);
end

for b = 1:16
    for i = 1:12
        blockt{b}{i,1} = i;
        blockt{b}{i,2} = tblock{st(po(b),i),po(b)}.moviename;
        blockt{b}{i,3} = tblock{st(po(b),i),po(b)}.folder;
        blockt{b}{i,4} = [tblock{st(po(b),i),po(b)}.name,'.wav'];
        blockt{b}{i,5} = tblock{st(po(b),i),po(b)}.freq;
        blockt{b}{i,6} = tblock{st(po(b),i),po(b)}.phase;
        blockt{b}{i,7} = tblock{st(po(b),i),po(b)}.cat;
        blockt{b}{i,8} = tblock{st(po(b),i),po(b)}.movie1;
        blockt{b}{i,9} = tblock{st(po(b),i),po(b)}.movie2;
        blockt{b}{i,10} = tblock{st(po(b),i),po(b)}.movie3;
        blockt{b}{i,11} = tblock{st(po(b),i),po(b)}.movie4;
        blockt{b}{i,12} = tblock{st(po(b),i),po(b)}.corrresp;
    end
    t = cell2table(blockt{b},'VariableNames',{'trialnumber','moviename','soundfolder','soundname','frequency','soundphase','soundcat','movie1','movie2','movie3','movie4','correctresponse'});
    writetable(t,['gtb_t',num2str(subject),'_block',num2str(b),'.csv'],'Delimiter',',','QuoteStrings',true);    
end
    
save(['gtb_t',num2str(subject)],'blockt');
