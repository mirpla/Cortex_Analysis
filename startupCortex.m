% When working locally      Comp = 1
% When working on Server    Comp = 2
% When working on Castles   Comp = 3

Comp = 1;
switch Comp
    case 1
        Basepath = 'Z:\';
    case 2
        Basepath = '/media/mxv796/rds-share/';
    case 3 
        Basepath = '/rds/projects/2016/hanslmas-02/';
end 
addpath(...
    [Basepath, 'Mircea/Tools/fieldtrip-20190224'], ...
    [Basepath, 'Common/tools'], ...
    [Basepath, 'Mircea/Cortex_Analysis'],...
    genpath([Basepath, 'Mircea/Tools/Wave_clus_newest']),...
    genpath([Basepath, 'Common/releaseDec2015']),...
    genpath([Basepath, 'Mircea/Tools/LittleScripts'])...
)
ft_defaults
cd([Basepath, 'Mircea/Datasaves'])

clear Comp