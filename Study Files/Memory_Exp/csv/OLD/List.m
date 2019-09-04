for b = 1:nblocks
    switch b 
        case 1
            ccat = [1,,2,2,2,2,3,3,3,3,4,4,4,4];
            x=1;
        case 2
            ccat = [5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8];
            x=1;
        case 3
            ccat = [2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5];
            x=3;
        case 4
            ccat = [6,6,6,6,7,7,7,7,8,8,8,8,1,1,1,1];
            x=3;
        case 5
            ccat = [3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6];
            x=5;
        case 6
            ccat = [7,7,7,7,8,8,8,8,1,1,1,1,2,2,2,2];
            x=5;
        case 7
            ccat = [4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7];
            x=7;
        case 8
            ccat = [8,8,8,8,1,1,1,1,2,2,2,2,3,3,3,3];
            x=7;
        case 9
            ccat = [1,1,1,1,2,2,2,2,5,5,5,5,6,6,6,6];
            x=9;
        case 10
            ccat = [3,3,3,3,4,4,4,4,7,7,7,7,8,8,8,8];
            x=9;
        case 11
            ccat = [2,2,2,2,3,3,3,3,6,6,6,6,7,7,7,7];
            x=11;
        case 12
            ccat = [1,1,1,1,4,4,4,4,5,5,5,5,8,8,8,8];
            x=11;
    end
    for c = ccat
        for p = 1:nphases
            sblock{tt,b} = sounds{1,c}{randsound{c,1}(p,x),p};
            tt=tt+1
            sblock{tt,b} = sounds{1,c}{randsound{c,1}(p,x+1),p};
            tt =tt+1
        end
    end
end

%% block 1

sblock{1,1} = sounds{1,1}{randsound{1,1}(1,1),1};
sblock{2,1} = sounds{1,1}{randsound{1,1}(1,2),1};
sblock{3,1} = sounds{1,1}{randsound{1,1}(2,1),2};
sblock{4,1} = sounds{1,1}{randsound{1,1}(2,2),2};

sblock{5,1} = sounds{1,2}{randsound{2,1}(1,1),1};
sblock{6,1} = sounds{1,2}{randsound{2,1}(1,2),1};
sblock{7,1} = sounds{1,2}{randsound{2,1}(2,1),2};
sblock{8,1} = sounds{1,2}{randsound{2,1}(2,2),2};

sblock{9,1} = sounds{1,3}{randsound{3,1}(1,1),1};
sblock{10,1} = sounds{1,3}{randsound{3,1}(1,2),1};
sblock{11,1} = sounds{1,3}{randsound{3,1}(2,1),2};
sblock{12,1} = sounds{1,3}{randsound{3,1}(2,2),2};

sblock{13,1} = sounds{1,4}{randsound{4,1}(1,1),1};
sblock{14,1} = sounds{1,4}{randsound{4,1}(1,2),1};
sblock{15,1} = sounds{1,4}{randsound{4,1}(2,1),2};
sblock{16,1} = sounds{1,4}{randsound{4,1}(2,2),2};

%% block 2
sblock{1,2} = sounds{1,5}{randsound{5,1}(1,1),1};
sblock{2,2} = sounds{1,5}{randsound{5,1}(1,2),1};
sblock{3,2} = sounds{1,5}{randsound{5,1}(2,1),2};
sblock{4,2} = sounds{1,5}{randsound{5,1}(2,2),2};

sblock{5,2} = sounds{1,6}{randsound{6,1}(1,1),1};
sblock{6,2} = sounds{1,6}{randsound{6,1}(1,2),1};
sblock{7,2} = sounds{1,6}{randsound{6,1}(2,1),2};
sblock{8,2} = sounds{1,6}{randsound{6,1}(2,2),2};

sblock{9,2} = sounds{1,7}{randsound{7,1}(1,1),1};
sblock{10,2} = sounds{1,7}{randsound{7,1}(1,2),1};
sblock{11,2} = sounds{1,7}{randsound{7,1}(2,1),2};
sblock{12,2} = sounds{1,7}{randsound{7,1}(2,2),2};

sblock{13,2} = sounds{1,8}{randsound{8,1}(1,1),1};
sblock{14,2} = sounds{1,8}{randsound{8,1}(1,2),1};
sblock{15,2} = sounds{1,8}{randsound{8,1}(2,1),2};
sblock{16,2} = sounds{1,8}{randsound{8,1}(2,2),2};

%% block 3
sblock{1,3} = sounds{1,2}{randsound{2,1}(1,3),1};
sblock{2,3} = sounds{1,2}{randsound{2,1}(1,4),1};
sblock{3,3} = sounds{1,2}{randsound{2,1}(2,3),2};
sblock{4,3} = sounds{1,2}{randsound{2,1}(2,4),2};

sblock{5,3} = sounds{1,3}{randsound{3,1}(1,3),1};
sblock{6,3} = sounds{1,3}{randsound{3,1}(1,4),1};
sblock{7,3} = sounds{1,3}{randsound{3,1}(2,3),2};
sblock{8,3} = sounds{1,3}{randsound{3,1}(2,4),2};

sblock{9,3} = sounds{1,4}{randsound{4,1}(1,3),1};
sblock{10,3} = sounds{1,4}{randsound{4,1}(1,4),1};
sblock{11,3} = sounds{1,4}{randsound{4,1}(2,3),2};
sblock{12,3} = sounds{1,4}{randsound{4,1}(2,4),2};

sblock{13,3} = sounds{1,5}{randsound{5,1}(1,3),1};
sblock{14,3} = sounds{1,5}{randsound{5,1}(1,4),1};
sblock{15,3} = sounds{1,5}{randsound{5,1}(2,3),2};
sblock{16,3} = sounds{1,5}{randsound{5,1}(2,4),2};

%% Block 4
sblock{1,4} = sounds{1,6}{randsound{6,1}(1,3),1};
sblock{2,4} = sounds{1,6}{randsound{6,1}(1,4),1};
sblock{3,4} = sounds{1,6}{randsound{6,1}(2,3),2};
sblock{4,4} = sounds{1,6}{randsound{6,1}(2,4),2};

sblock{5,4} = sounds{1,7}{randsound{7,1}(1,3),1};
sblock{6,4} = sounds{1,7}{randsound{7,1}(1,4),1};
sblock{7,4} = sounds{1,7}{randsound{7,1}(2,3),2};
sblock{8,4} = sounds{1,7}{randsound{7,1}(2,4),2};

sblock{9,4} = sounds{1,8}{randsound{8,1}(1,3),1};
sblock{10,4} = sounds{1,8}{randsound{8,1}(1,4),1};
sblock{11,4} = sounds{1,8}{randsound{8,1}(2,3),2};
sblock{12,4} = sounds{1,8}{randsound{8,1}(2,4),2};

sblock{13,4} = sounds{1,1}{randsound{1,1}(1,3),1};
sblock{14,4} = sounds{1,1}{randsound{1,1}(1,4),1};
sblock{15,4} = sounds{1,1}{randsound{1,1}(2,3),2};
sblock{16,4} = sounds{1,1}{randsound{1,1}(2,4),2};

%% Block 5 
sblock{1,5} = sounds{1,3}{randsound{3,1}(1,5),1};
sblock{2,5} = sounds{1,3}{randsound{3,1}(1,6),1};
sblock{3,5} = sounds{1,3}{randsound{3,1}(2,5),2};
sblock{4,5} = sounds{1,3}{randsound{3,1}(2,6),2};

sblock{5,5} = sounds{1,4}{randsound{4,1}(1,5),1};
sblock{6,5} = sounds{1,4}{randsound{4,1}(1,6),1};
sblock{7,5} = sounds{1,4}{randsound{4,1}(2,5),2};
sblock{8,5} = sounds{1,4}{randsound{4,1}(2,6),2};

sblock{9,5} = sounds{1,5}{randsound{5,1}(1,5),1};
sblock{10,5} = sounds{1,5}{randsound{5,1}(1,6),1};
sblock{11,5} = sounds{1,5}{randsound{5,1}(2,5),2};
sblock{12,5} = sounds{1,5}{randsound{5,1}(2,6),2};

sblock{13,5} = sounds{1,6}{randsound{6,1}(1,5),1};
sblock{14,5} = sounds{1,6}{randsound{6,1}(1,6),1};
sblock{15,5} = sounds{1,6}{randsound{6,1}(2,5),2};
sblock{16,5} = sounds{1,6}{randsound{6,1}(2,6),2};

%% Block 6 
sblock{1,6} = sounds{1,7}{randsound{7,1}(1,5),1};
sblock{2,6} = sounds{1,7}{randsound{7,1}(1,6),1};
sblock{3,6} = sounds{1,7}{randsound{7,1}(2,5),2};
sblock{4,6} = sounds{1,7}{randsound{7,1}(2,6),2};

sblock{5,6} = sounds{1,8}{randsound{8,1}(1,5),1};
sblock{6,6} = sounds{1,8}{randsound{8,1}(1,6),1};
sblock{7,6} = sounds{1,8}{randsound{8,1}(2,5),2};
sblock{8,6} = sounds{1,8}{randsound{8,1}(2,6),2};

sblock{9,6} = sounds{1,1}{randsound{1,1}(1,5),1};
sblock{10,6} = sounds{1,1}{randsound{1,1}(1,6),1};
sblock{11,6} = sounds{1,1}{randsound{1,1}(2,5),2};
sblock{12,6} = sounds{1,1}{randsound{1,1}(2,6),2};

sblock{13,6} = sounds{1,2}{randsound{2,1}(1,5),1};
sblock{14,6} = sounds{1,2}{randsound{2,1}(1,6),1};
sblock{15,6} = sounds{1,2}{randsound{2,1}(2,5),2};
sblock{16,6} = sounds{1,2}{randsound{2,1}(2,6),2};

%% Block 7 
sblock{1,7} = sounds{1,4}{randsound{4,1}(1,7),1};
sblock{2,7} = sounds{1,4}{randsound{4,1}(1,8),1};
sblock{3,7} = sounds{1,4}{randsound{4,1}(2,7),2};
sblock{4,7} = sounds{1,4}{randsound{4,1}(2,8),2};

sblock{5,7} = sounds{1,5}{randsound{5,1}(1,7),1};
sblock{6,7} = sounds{1,5}{randsound{5,1}(1,8),1};
sblock{7,7} = sounds{1,5}{randsound{5,1}(2,7),2};
sblock{8,7} = sounds{1,5}{randsound{5,1}(2,8),2};

sblock{9,7} = sounds{1,6}{randsound{6,1}(1,7),1};
sblock{10,7} = sounds{1,6}{randsound{6,1}(1,8),1};
sblock{11,7} = sounds{1,6}{randsound{6,1}(2,7),2};
sblock{12,7} = sounds{1,6}{randsound{6,1}(2,8),2};

sblock{13,7} = sounds{1,7}{randsound{7,1}(1,7),1};
sblock{14,7} = sounds{1,7}{randsound{7,1}(1,8),1};
sblock{15,7} = sounds{1,7}{randsound{7,1}(2,7),2};
sblock{16,7} = sounds{1,7}{randsound{7,1}(2,8),2};

%% Block 8 
sblock{1,8} = sounds{1,8}{randsound{8,1}(1,7),1};
sblock{2,8} = sounds{1,8}{randsound{8,1}(1,8),1};
sblock{3,8} = sounds{1,8}{randsound{8,1}(2,7),2};
sblock{4,8} = sounds{1,8}{randsound{8,1}(2,8),2};

sblock{5,8} = sounds{1,1}{randsound{1,1}(1,7),1};
sblock{6,8} = sounds{1,1}{randsound{1,1}(1,8),1};
sblock{7,8} = sounds{1,1}{randsound{1,1}(2,7),2};
sblock{8,8} = sounds{1,1}{randsound{1,1}(2,8),2};

sblock{9,8} = sounds{1,2}{randsound{2,1}(1,7),1};
sblock{10,8} = sounds{1,2}{randsound{2,1}(1,8),1};
sblock{11,8} = sounds{1,2}{randsound{2,1}(2,7),2};
sblock{12,8} = sounds{1,2}{randsound{2,1}(2,8),2};

sblock{13,8} = sounds{1,3}{randsound{3,1}(1,7),1};
sblock{14,8} = sounds{1,3}{randsound{3,1}(1,8),1};
sblock{15,8} = sounds{1,3}{randsound{3,1}(2,7),2};
sblock{16,8} = sounds{1,3}{randsound{3,1}(2,8),2};

%% Block 9
sblock{1,9} = sounds{1,1}{randsound{1,1}(1,9),1};
sblock{2,9} = sounds{1,1}{randsound{1,1}(1,10),1};
sblock{3,9} = sounds{1,1}{randsound{1,1}(2,9),2};
sblock{4,9} = sounds{1,1}{randsound{1,1}(2,10),2};

sblock{5,9} = sounds{1,2}{randsound{2,1}(1,9),1};
sblock{6,9} = sounds{1,2}{randsound{2,1}(1,10),1};
sblock{7,9} = sounds{1,2}{randsound{2,1}(2,9),2};
sblock{8,9} = sounds{1,2}{randsound{2,1}(2,10),2};

sblock{9,9} = sounds{1,5}{randsound{5,1}(1,9),1};
sblock{10,9} = sounds{1,5}{randsound{5,1}(1,10),1};
sblock{11,9} = sounds{1,5}{randsound{5,1}(2,9),2};
sblock{12,9} = sounds{1,5}{randsound{5,1}(2,10),2};

sblock{13,9} = sounds{1,6}{randsound{6,1}(1,9),1};
sblock{14,9} = sounds{1,6}{randsound{6,1}(1,10),1};
sblock{15,9} = sounds{1,6}{randsound{6,1}(2,9),2};
sblock{16,9} = sounds{1,6}{randsound{6,1}(2,10),2};


%% Block 10
sblock{1,10} = sounds{1,3}{randsound{3,1}(1,9),1};
sblock{2,10} = sounds{1,3}{randsound{3,1}(1,10),1};
sblock{3,10} = sounds{1,3}{randsound{3,1}(2,9),2};
sblock{4,10} = sounds{1,3}{randsound{3,1}(2,10),2};

sblock{5,10} = sounds{1,4}{randsound{4,1}(1,9),1};
sblock{6,10} = sounds{1,4}{randsound{4,1}(1,10),1};
sblock{7,10} = sounds{1,4}{randsound{4,1}(2,9),2};
sblock{8,10} = sounds{1,4}{randsound{4,1}(2,10),2};

sblock{9,10} = sounds{1,7}{randsound{7,1}(1,9),1};
sblock{10,10} = sounds{1,7}{randsound{7,1}(1,10),1};
sblock{11,10} = sounds{1,7}{randsound{7,1}(2,9),2};
sblock{12,10} = sounds{1,7}{randsound{7,1}(2,10),2};

sblock{13,10} = sounds{1,8}{randsound{8,1}(1,9),1};
sblock{14,10} = sounds{1,8}{randsound{8,1}(1,10),1};
sblock{15,10} = sounds{1,8}{randsound{8,1}(2,9),2};
sblock{16,10} = sounds{1,8}{randsound{8,1}(2,10),2};


%% Block 11
sblock{1,11} = sounds{1,2}{randsound{2,1}(1,11),1};
sblock{2,11} = sounds{1,2}{randsound{2,1}(1,12),1};
sblock{3,11} = sounds{1,2}{randsound{2,1}(2,11),2};
sblock{4,11} = sounds{1,2}{randsound{2,1}(2,12),2};

sblock{5,11} = sounds{1,3}{randsound{3,1}(1,11),1};
sblock{6,11} = sounds{1,3}{randsound{3,1}(1,12),1};
sblock{7,11} = sounds{1,3}{randsound{3,1}(2,11),2};
sblock{8,11} = sounds{1,3}{randsound{3,1}(2,12),2};

sblock{9,11} = sounds{1,6}{randsound{6,1}(1,11),1};
sblock{10,11} = sounds{1,6}{randsound{6,1}(1,12),1};
sblock{11,11} = sounds{1,6}{randsound{6,1}(2,11),2};
sblock{12,11} = sounds{1,6}{randsound{6,1}(2,12),2};

sblock{13,11} = sounds{1,7}{randsound{7,1}(1,11),1};
sblock{14,11} = sounds{1,7}{randsound{7,1}(1,12),1};
sblock{15,11} = sounds{1,7}{randsound{7,1}(2,11),2};
sblock{16,11} = sounds{1,7}{randsound{7,1}(2,12),2};


%% Block 12
sblock{1,12} = sounds{1,1}{randsound{1,1}(1,11),1};
sblock{2,12} = sounds{1,1}{randsound{1,1}(1,12),1};
sblock{3,12} = sounds{1,1}{randsound{1,1}(2,11),2};
sblock{4,12} = sounds{1,1}{randsound{1,1}(2,12),2};

sblock{5,12} = sounds{1,4}{randsound{4,1}(1,11),1};
sblock{6,12} = sounds{1,4}{randsound{4,1}(1,12),1};
sblock{7,12} = sounds{1,4}{randsound{4,1}(2,11),2};
sblock{8,12} = sounds{1,4}{randsound{4,1}(2,12),2};

sblock{9,12} = sounds{1,5}{randsound{5,1}(1,11),1};
sblock{10,12} = sounds{1,5}{randsound{5,1}(1,12),1};
sblock{11,12} = sounds{1,5}{randsound{5,1}(2,11),2};
sblock{12,12} = sounds{1,5}{randsound{5,1}(2,12),2};

sblock{13,12} = sounds{1,8}{randsound{8,1}(1,11),1};
sblock{14,12} = sounds{1,8}{randsound{8,1}(1,12),1};
sblock{15,12} = sounds{1,8}{randsound{8,1}(2,11),2};
sblock{16,12} = sounds{1,8}{randsound{8,1}(2,12),2};