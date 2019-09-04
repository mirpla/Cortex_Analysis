% Clear the workspace
close all;
clear all;
sca;

AssertOpenGL;

% Force GetSecs and WaitSecs into memory to avoid latency later on
GetSecs;
WaitSecs(0.1);

% Initialise LabJack
lab_init;

% Setup PTB with some default values
PsychDefaultSetup(2);
InitializePsychSound(1);

%----------------------------------------------------------------------------------------------------------
%   Set up the audio
%----------------------------------------------------------------------------------------------------------
% Request latency mode 2
reqlatencyclass = 2;
% Requested output frequency. Must set this. 96000, 48000, or 44100. Ours are 44100
freq = 44100;
% Pointless to set this. Auto-selected to be optimal.
buffersize = 0;
% Set based on work with oscilliscope
suggestedLatencySecs = 0.002;
% Set based on work with oscilliscope
latbias = 0.005;
% ASIO4ALL v2. May need to change if new hardware is installed
deviceid = 14; % PC
% deviceid = -1; % Mac

% Open audio device for low-latency output
pahandle = PsychPortAudio('Open', deviceid, [], reqlatencyclass, freq, 2, buffersize, suggestedLatencySecs);

% Tell driver about hardware's inherent latency, determined via calibration once
prelat = PsychPortAudio('LatencyBias', pahandle, latbias);
postlat = PsychPortAudio('LatencyBias', pahandle);

% Generate a beep at 1000Hz, 0.1 sec, 50% amplitude, to avoid latency later on
mynoise(1,:) = 0.5*MakeBeep(1000, 0.1, freq);
mynoise(2,:) = mynoise(1,:);
% Fill buffer with audio data
PsychPortAudio('FillBuffer', pahandle, mynoise);
% Perform one audio warmup trial, to get the sound hardware fully up and running, performing whatever lazy
% initialization only happens at real first use. This useless warmup will allow for lower latency for start
% of playback during actual use of the audio driver in the real trials
PsychPortAudio('Start', pahandle, 1, 0, 1);
PsychPortAudio('Stop', pahandle, 1);
%----------------------------------------------------------------------------------------------------------
%   Ok so now the audio hardware is fully initialised and our driver is on hot-standby, ready to start playback
%   of any sound with minimal latency
%----------------------------------------------------------------------------------------------------------

% Create dialog box to gather participant number
participant_num = inputdlg('Participant Number', 'Participant Number');
participant_num = str2double(participant_num);

% Read in the experiment files
cd 'C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\CSVs'; % PC
% cd '/Users/BigSwifty/Desktop/OK for Backup/Work/2014-Birmingham/Audio-Visual Flicker/Audio-Visual Synch - EEG/Program/CSVs' % Mac
% create datasets called "BlockX" or "TestX", so that we can call/evaluate them later
BlockA = dataset('File', 'BlockA.csv', 'Delimiter' ,',');
BlockB = dataset('File', 'BlockB.csv', 'Delimiter' ,',');
BlockC = dataset('File', 'BlockC.csv', 'Delimiter' ,',');
BlockD = dataset('File', 'BlockD.csv', 'Delimiter' ,',');
BlockE = dataset('File', 'BlockE.csv', 'Delimiter' ,',');
BlockF = dataset('File', 'BlockF.csv', 'Delimiter' ,',');
BlockG = dataset('File', 'BlockG.csv', 'Delimiter' ,',');
BlockH = dataset('File', 'BlockH.csv', 'Delimiter' ,',');
BlockI = dataset('File', 'BlockI.csv', 'Delimiter' ,',');
BlockJ = dataset('File', 'BlockJ.csv', 'Delimiter' ,',');
BlockK = dataset('File', 'BlockK.csv', 'Delimiter' ,',');
BlockL = dataset('File', 'BlockL.csv', 'Delimiter' ,',');
TestA = dataset('File', 'TestA.csv', 'Delimiter' ,',');
TestB = dataset('File', 'TestB.csv', 'Delimiter' ,',');
TestC = dataset('File', 'TestC.csv', 'Delimiter' ,',');
TestD = dataset('File', 'TestD.csv', 'Delimiter' ,',');
TestE = dataset('File', 'TestE.csv', 'Delimiter' ,',');
TestF = dataset('File', 'TestF.csv', 'Delimiter' ,',');
TestG = dataset('File', 'TestG.csv', 'Delimiter' ,',');
TestH = dataset('File', 'TestH.csv', 'Delimiter' ,',');
TestI = dataset('File', 'TestI.csv', 'Delimiter' ,',');
TestJ = dataset('File', 'TestJ.csv', 'Delimiter' ,',');
TestK = dataset('File', 'TestK.csv', 'Delimiter' ,',');
TestL = dataset('File', 'TestL.csv', 'Delimiter' ,',');
BlockOrder = dataset('File', 'Participants-Block-Order.csv', 'Delimiter' ,',');
BlockP = dataset('File', 'BlockP.csv', 'Delimiter', ',');
TestP = dataset('File', 'TestP.csv', 'Delimiter', ',');
SyncTestTheta = dataset('File', 'SyncBlockTheta.csv', 'Delimiter', ',');
Sounds = dataset('File', 'Sounds.csv', 'Delimiter' ,',');
Movies = dataset('File', 'Movies.csv', 'Delimiter' ,',');

try
    % Comment this out for testing, uncomment before real participants
    HideCursor;
    
    %----------------------------------------------------------------------------------------------------------
    %   Set up the display and timing
    %----------------------------------------------------------------------------------------------------------
    % select external screen
    screenid = max(Screen('Screens'));
    % create a window
    [win, winRect] = PsychImaging('OpenWindow', screenid, 0.5);
    %[win, winRect] = Screen(screenid, 'OpenWindow', 128, [0 0 800 800]) % for testing
    % define size of x and y based on screen size
    [screenXpixels, screenYpixels] = Screen('WindowSize', win);
    % define screen center based on screen size
    [xCenter, yCenter] = RectCenter(winRect);
    % set test font size
    Screen('TextSize', win, 12);
    % set text font
    Screen('TextFont', win, 'Helvetica');
    
    % get the flip interval, based on screen refresh rate
    ifi = Screen('GetFlipInterval', win);
    % Set based on work with oscilliscope
    waitframes = 1;
    % Set based on work with oscilliscope
    isiTimeSecs = 1;
    % the above converted into frames
    isiTimeFrames = round(isiTimeSecs / ifi);
    % set Matlab priority to maximum
    topPriorityLevel = MaxPriority(win);
    %----------------------------------------------------------------------------------------------------------
    %   Display and timing setup complete
    %----------------------------------------------------------------------------------------------------------
    
    %----------------------------------------------------------------------------------------------------------
    %   Keyboard information: Define the keyboard keys that are listened
    %   for. We will be using the QWERTY keys 1-5 as response keys and the
    %   escape key as an exit/reset key
    %----------------------------------------------------------------------------------------------------------
    escapeKey = KbName('ESCAPE');
    oneKey = KbName('1!');
    twoKey = KbName('2@');
    threeKey = KbName('3#');
    fourKey = KbName('4$');
    fiveKey = KbName('5%');
    
    rng('shuffle');
    %----------------------------------------------------------------------------------------------------------
    %   Begin the block loop, from 2-14 (since it reads from columns 2 through 8 on the BlockA...L files and
    %   TestA...L files, and the column 2 refers to the practice block
    %   THIS IS 1.0
    %----------------------------------------------------------------------------------------------------------
    for block = 2:14
        
        %----------------------------------------------------------------------------------------------------------
        %   1.1 ENCODING CONDITIONS
        %----------------------------------------------------------------------------------------------------------
        
        % BlockOrder contains the block order for each participant. Need to read BlockOrder's row based on the
        % participant number to get the Block Order for the participant
        row = participant_num-1000;
        % create a row containing the block order for the participant by grabbing the appropriate column from the
        % BlockOrder dataset
        ParticipantBlockOrder = BlockOrder(row, :);
        
        % get the block identifier (A-L, or P) associated with the current block (2-16) (which is put into a
        % dataset)
        n1 = dataset2cell(BlockOrder([row],[block]));
        % create a variable called "BlockX" with X being the block identifier so that we can evaluate and call the
        % dataset named "BlockX" (by grabbing (2,1) from the n1 dataset)
        name = cell2mat(['Block' n1(2,1)]);
        % get the number of trials in the BlockX dataset
        [numTrials] = size(eval(name),1);
        
        % create a randomly shuffled vector of the same length as the number of trials in a block
        shuffler = Shuffle(1:numTrials);
        % create a duplicate of the current block dataset
        trialMatrix = eval(name);
        % add the shuffler vector as a column to the duplicated dataset
        trialMatrix.ShuffleOrder = shuffler';
        % sort the duplicated dataset by the shuffled vector
        trialMatrixShuffled = sortrows(trialMatrix, 'ShuffleOrder');
        
        %----------------------------------------------------------------------------------------------------------
        %   1.1 Make a response matrix
        %----------------------------------------------------------------------------------------------------------
        
        % Define the response matrix for the rating trials.
        respMat = cell(numTrials, 18);
        
        %----------------------------------------------------------------------------------------------------------
        %   1.1 EXPERIMENTAL LOOP - ENCODING TRIALS
        %----------------------------------------------------------------------------------------------------------
        
        % Make MatLab/PsychToolBox top priority. Undo this later.
        Priority(topPriorityLevel);
        
        % Begin the trial loop for the Ratings task.
        for trial = 1:numTrials
            %------------------------------------------------------------------------------------------------------
            %   1.1 Read in and prepare video
            %------------------------------------------------------------------------------------------------------
            
            % duplicate the current block dataset as "moviefile"
            moviefile = trialMatrixShuffled;
            % column 9 contains the reference to the movie folder - change "moviefile" to a cell called
            % "moviefolder" that contains only that reference
            moviefolder = dataset2cell(moviefile([trial], [9]));
            % convert the cell to a matrix
            moviefolder = cell2mat(moviefolder(2,1));
            % create a full string reference to the appropriate folder for the sound file
            moviefolder = ['C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Movies\' moviefolder]; % PC
            % moviefolder = ['/Users/BigSwifty/Desktop/OK for Backup/Work/2014-Birmingham/Audio-Visual Flicker/Audio-Visual Synch - EEG/Program/Movies/' moviefolder]; % MAC
            % change directory to the appropriate folder
            cd(moviefolder);
            % column 10 contains the reference to the video file - change "moviefile" to a cell that contains only
            % that reference
            moviefile = dataset2cell(moviefile([trial], [10]));
            % convert the cell to a matrix
            moviefile = cell2mat(moviefile(2,1));
            % read video file, call it avi_object
            avi_object=VideoReader(moviefile);
            % read in all frames of avi_object
            avi_frames=read(avi_object);
            % get number of frames in avi_object
            num_frames=get(avi_object, 'NumberofFrames');
            % get framerate of avi_object
            framerate=get(avi_object, 'FrameRate');
            
            %------------------------------------------------------------------------------------------------------
            %   1.1 Read in and prepare audio
            %------------------------------------------------------------------------------------------------------
            % duplicate the trial matrix again
            soundfile = trialMatrixShuffled;
            % column 7 contains the reference to the audio folder - change "soundfile" to a cell called
            % "soundfolder" that contains only that reference
            soundfolder = dataset2cell(soundfile([trial], [7]));
            % convert the cell to a matrix
            soundfolder = cell2mat(soundfolder(2,1));
            % create a full string reference to the appropriate folder for the sound file
            soundfolder = ['C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Sounds\' soundfolder]; % PC
            % soundfolder = ['/Users/BigSwifty/Desktop/OK for Backup/Work/2014-Birmingham/Audio-Visual Flicker/Audio-Visual Synch - EEG/Program/Sounds/Theta/zero']; % MAC for testing
            % change directory to the appropriate folder
            cd(soundfolder);
            % column 8 contains the reference to the audio file - change "soundfile" to a cell that contains only
            % that reference
            soundfile = dataset2cell(soundfile([trial], [8]));
            % convert the cell to a matrix
            soundfile = cell2mat(soundfile(2,1));
            % read audio file, call it wav_orig, sample rate is Fs
            [wav_orig,Fs]=audioread(soundfile);
            % prepare to play the sound by adding it to the audio buffer in advance
            PsychPortAudio('FillBuffer', pahandle, wav_orig');
            
            %------------------------------------------------------------------------------------------------------
            %   1.1 BEGIN ENCODING TRIALS
            %------------------------------------------------------------------------------------------------------
            
            % If this is the first trial we present the instruction screen and wait for a key-press
            if trial == 1
               % for the practice 
               if block == 2 
                DrawFormattedText(win, 'You will be presented with a short video and a sound clip. \n\nYour task is to judge how well the sound suits the contents of the video. \n\nPress Any Key To Begin.',...
                    'center', 'center', 0);
                Screen('Flip', win);
                pause(1)
                KbStrokeWait;
               % for block starting after the practice
               elseif block >= 3
                    DrawFormattedText(win, ['Take a break now. Next block will be Block ',num2str(block-2)],...
                    'center', 'center', 0);
                    Screen('Flip', win);
                    pause(30)
                    DrawFormattedText(win, 'You will be presented with a short video and a sound clip. \n\nYour task is to judge how well the sound suits the contents of the video. \n\nPress Any Key To Begin.',...
                    'center', 'center', 0);
                    Screen('Flip', win);
                    pause(1)
                    KbStrokeWait;
               end    
            end
            
            % Now we present the isi interval with fixation point
            rframes = randi([0 150]);
            for frame = 1:isiTimeFrames+rframes
                % Draw the fixation point
                DrawFormattedText(win, '+', 'center', 'center', 0);
                Screen('Flip', win);
            end
            
            %------------------------------------------------------------------------------------------------------
            %   1.1 START STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK
            %------------------------------------------------------------------------------------------------------
            
            % Make the video by grabbing the frames
            for frame = 1:num_frames
                frameToShow{frame} = Screen('MakeTexture', win, avi_frames(:,:,:,frame));
            end
            
            % Use a screen with 75 hz refresh rate. The videos have a 25 framerate. So we need 3 displays of each
            % video frame for a 3-second video presentation. For 60 hz, 2.4
            % of each video frame
            flipsPerFrame = 3;
            
            % Visual processing time is 50ms, auditory is 10ms. Thus, need to play the visual stimuli 40ms before
            % the auditory stimuli. But account for approx 2ms sound onset
            % latency (11ms in fMRI), so play visual stimuli 38ms (29 in
            % fMRI) before auditory for the 40ms difference.
            
            PsychPortAudio('Start', pahandle, 1, inf, 0);
            WaitSecs(0.1);
            % flip, and get vertical refresh timestamp
            [refreshTimestamp] = Screen('Flip', win);
            
            % STIMULI STARTED TRIGGER
            lab_put_code(L,1);
            
            % Draw the movie
            ifrm = 0; % the current frame (starting at 0)
            for frame = 1:num_frames % for each frame in the movie
                ifrm = ifrm+1; % the current frame
                for iflip = 1:flipsPerFrame % to draw each frame in the movie "flipsPerFrame" times
                    Screen('DrawTexture', win, frameToShow{frame}, [], []);
                    % ('Flip', 'window', 'when'). When = 0.5 * ifi sec after last
                    % refresh timestamp. ie, flip at the first possible
                    % retrace after the last flip timestamp plus the
                    % duration in sec of half of an inter-frame interval
                    [refreshTimestamp] = Screen('Flip', win, refreshTimestamp + 0.5*ifi);
                    % Play the sound. When = 38ms after video onset
                    if frame == 2 && iflip == 1
                        PsychPortAudio('RescheduleStart', pahandle, refreshTimestamp);
                    end
                end
            end
            
            % Stop the sound
            PsychPortAudio('Stop', pahandle, 1);
            
            % Clear the textures created by reading the frames of the movie
            for frame = 1:num_frames
                Screen('Close', frameToShow{frame});
            end
            
            % Draw the rating screen
            DrawFormattedText(win, 'Using the numbers 1 through 5, rate how well the sound suited the movie.\n\n 1 means that the sound did not suit the movie at all. \n\n2 means that the sound did not suit the movie well. \n\n3 means that the sound somewhat suited the movie. \n\n4 means that the sound suited the movie. \n\n 5 means that the sound suited the movie very well.',...
                'center', 'center', 0);
            Screen('Flip', win);
            
            % Start the timer for calculating the response times
            tStart = GetSecs;
            
            % Check the keyboard for responses
            respToBeMade = true; % set it so that a response is required
            while respToBeMade==true
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey) % if ESC is pressed, terminate the experiment
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(oneKey)
                    response = 1;
                    respToBeMade = false;
                elseif keyCode(twoKey)
                    response = 2;
                    respToBeMade = false;
                elseif keyCode(threeKey)
                    response = 3;
                    respToBeMade = false;
                elseif keyCode(fourKey)
                    response = 4;
                    respToBeMade = false;
                elseif keyCode(fiveKey)
                    response = 5;
                    respToBeMade = false;
                end
            end
            
            % RATING MADE TRIGGER
            
            % Get the time when the response is made, and calculate the RT
            tEnd = GetSecs;
            responsert = tEnd - tStart;
            
            % Record trial data to the data matrix
            encoding = trialMatrixShuffled;
            
            t = dataset2cell(encoding([trial], [1]));
            Movie = cell2mat(t(2,1));
            t = dataset2cell(encoding([trial], [2]));
            List = cell2mat(t(2,1));
            t = dataset2cell(encoding([trial], [3]));
            Sound = cell2mat(t(2,1));
            t = dataset2cell(encoding([trial], [4]));
            SoundList = cell2mat(t(2,1));
            t = dataset2cell(encoding([trial], [5]));
            SoundAngle = cell2mat(t(2,1));
            t = dataset2cell(encoding([trial], [6]));
            Frequency = cell2mat(t(2,1));
            t = dataset2cell(encoding([trial], [7]));
            SoundFolder = cell2mat(t(2,1));
            t = dataset2cell(encoding([trial], [8]));
            SoundFile = cell2mat(t(2,1));
            t = dataset2cell(encoding([trial], [9]));
            MovieFolder = cell2mat(t(2,1));
            t = dataset2cell(encoding([trial], [10]));
            MovieFile = cell2mat(t(2,1));
            
            respMat{trial, 1} = participant_num;
            respMat{trial, 2} = num2str(block-1); % Block number for this participant
            respMat{trial, 3} = name; % Block name (A/B/C/D)
            respMat{trial, 4} = trial; % trial number
            respMat{trial, 5} = Movie; % Movie from csv
            respMat{trial, 6} = List; % List from csv
            respMat{trial, 7} = Sound; % Sound from csv
            respMat{trial, 8} = SoundList; % SoundList from csv
            respMat{trial, 9} = SoundAngle; % SoundAngle from csv
            respMat{trial, 10} = Frequency; % Frequency from csv
            respMat{trial, 11} = SoundFolder; % Sound Folder from csv
            respMat{trial, 12} = SoundFile; % Sound File from csv
            respMat{trial, 13} = MovieFolder; % Movie Folder from csv
            respMat{trial, 14} = MovieFile; % Movie File from csv
            respMat{trial, 15} = moviefile; % movie filename from current trial
            respMat{trial, 16} = soundfile; % sound filename from current trial
            respMat{trial, 17} = response; % the response key
            respMat{trial, 18} = responsert; % the RT
            
            
            % Save the Ratings data to a file
            RatingsData = dataset(respMat);
            savename=[num2str(participant_num) '-block-' num2str(block-1) '-Ratings-' datestr(date) '.csv'];
            cd 'C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Data\RatingsData'; % PC
            % cd '/Users/BigSwifty/Desktop/OK for Backup/Work/2014-Birmingham/Audio-Visual Flicker/Audio-Visual Synch - EEG/Program/Data/RatingsData'; % MAC
            export(RatingsData, 'file', savename, 'Delimiter', ',');
            
            %------------------------------------------------------------------------------------------------------
            %   1.1 END STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK.
            %   THIS ENDS 1.1
            %------------------------------------------------------------------------------------------------------
        end
        
        % Draw the distractor task screen - present a random number from 70-99 for 30 seconds
        r = randi([170 199]);
        DrawFormattedText(win, ['Starting with the number ' num2str(r) ', subtract 3 and say the resulting number out loud. \n\n Continue doing this until you are prompted.'],...
            'center', 'center', 0);
        Screen('Flip', win);
        pause(30)
        DrawFormattedText(win, 'Press any key to continue.',...
            'center', 'center', 0);
        Screen('Flip', win);
        KbStrokeWait;
        DrawFormattedText(win, 'You will now complete a memory test. \n\n You will hear one of the sounds that you heard earlier. \n\n You will have to choose the video that was shown while that \n\nsound was playing earlier from four videos that will be displayed. \n\n Press any key to continue.',...
            'center', 'center', 0);
        Screen('Flip', win);
        pause(1);
        KbStrokeWait;
        
        %----------------------------------------------------------------------------------------------------------
        %   1.2 MEMORY TEST CONDITIONS
        %----------------------------------------------------------------------------------------------------------
        
        % create a variable called "Test" plus the current block that we can call and evaluate
        testname = cell2mat(['Test' n1(2,1)]);
        % determine the number of trials in the current test block
        [numTrials] = size(eval(testname),1);
        
        % create a randomly shuffled vector of the same length as the number of trials in a block
        shuffler = Shuffle(1:numTrials);
        % create a duplicate of the current block dataset
        trialMatrix = eval(testname);
        % add the shuffler vector as a column to the duplicated dataset
        trialMatrix.ShuffleOrder = shuffler';
        % sort the duplicated dataset by the shuffled vector
        trialMatrixShuffled = sortrows(trialMatrix, 'ShuffleOrder');
        
        %----------------------------------------------------------------------------------------------------------
        %   1.2 Make a response matrix
        %----------------------------------------------------------------------------------------------------------
        
        % Define the response matrix for the test trials. Make it 6* the number of cells in a block, to gather data
        % for all 6 blocks
        testRespMat = cell(numTrials);
        
        %----------------------------------------------------------------------------------------------------------
        %   1.2 EXPERIMENTAL LOOP - MEMORY TEST TRIALS
        %----------------------------------------------------------------------------------------------------------
        
        % Make MatLab/PsychToolBox top priority. Undo this later.
        Priority(topPriorityLevel);
        
        % Begin trial loop for the memory test trials
        for testtrial = 1:numTrials
            %------------------------------------------------------------------------------------------------------
            %   1.2 Read in and prepare video - see comments in the encoding section
            %------------------------------------------------------------------------------------------------------
            moviefile = trialMatrixShuffled;
            moviefolder = dataset2cell(moviefile([trial], [9]));
            moviefolder = cell2mat(moviefolder(2,1));
            moviefolder = ['C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Movies\' moviefolder];
            % change directory to the appropriate folder
            cd(moviefolder);
            moviefile = trialMatrixShuffled;
            moviefile1 = dataset2cell(moviefile([testtrial], [11]));
            moviefile1 = cell2mat(moviefile1(2,1));
            avi_object1=VideoReader(moviefile1);
            avi_frames1=read(avi_object1);
            num_frames1=get(avi_object1, 'NumberofFrames');
            framerate1=get(avi_object1, 'FrameRate');
            
            moviefile2 = dataset2cell(moviefile([testtrial], [12]));
            moviefile2 = cell2mat(moviefile2(2,1));
            avi_object2=VideoReader(moviefile2);
            avi_frames2=read(avi_object2);
            num_frames2=get(avi_object2, 'NumberofFrames');
            framerate2=get(avi_object2, 'FrameRate');
            
            moviefile3 = dataset2cell(moviefile([testtrial], [13]));
            moviefile3 = cell2mat(moviefile3(2,1));
            avi_object3=VideoReader(moviefile3);
            avi_frames3=read(avi_object3);
            num_frames3=get(avi_object3, 'NumberofFrames');
            framerate3=get(avi_object3, 'FrameRate');
            
            moviefile4 = dataset2cell(moviefile([testtrial], [14]));
            moviefile4 = cell2mat(moviefile4(2,1));
            avi_object4=VideoReader(moviefile4);
            avi_frames4=read(avi_object4);
            num_frames4=get(avi_object4, 'NumberofFrames');
            framerate4=get(avi_object4, 'FrameRate');
            
            %------------------------------------------------------------------------------------------------------
            %   1.2 Read in and prepare audio - see comments in the encoding section
            %------------------------------------------------------------------------------------------------------
            soundfile = trialMatrixShuffled;
            soundfolder = dataset2cell(soundfile([testtrial], [7]));
            soundfolder = cell2mat(soundfolder(2,1));
            soundfolder = ['C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Sounds\' soundfolder];
            cd(soundfolder);
            soundfile = dataset2cell(soundfile([testtrial], [8]));
            soundfile = cell2mat(soundfile(2,1));
            [wav_orig,Fs]=audioread(soundfile);
            PsychPortAudio('FillBuffer', pahandle, wav_orig');
            
            %------------------------------------------------------------------------------------------------------
            %   1.2 BEGIN MEMORY TEST TRIALS
            %------------------------------------------------------------------------------------------------------
            
            % Now we present the isi interval with fixation point
            rframes = randi([0 150]);
            for frame = 1:isiTimeFrames+rframes
                % Draw the fixation point
                DrawFormattedText(win, '+', 'center', 'center', 0);
                Screen('Flip', win);
            end
            
            % TEST SCREEN ON TRIGGER
            lab_put_code(L,2);
            
            %------------------------------------------------------------------------------------------------------
            %   1.2 START STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK
            %------------------------------------------------------------------------------------------------------
            
            % Make the videos by grabbing the last frame from each
            frame1 = 15;
            frameToShow1 = Screen('MakeTexture', win, avi_frames1(:,:,:,frame1));
            frame2 = 15;
            frameToShow2 = Screen('MakeTexture', win, avi_frames2(:,:,:,frame2));
            frame3 = 15;
            frameToShow3 = Screen('MakeTexture', win, avi_frames3(:,:,:,frame3));
            frame4 = 15;
            frameToShow4 = Screen('MakeTexture', win, avi_frames4(:,:,:,frame4));
            
            % Begin timer for response time calculation
            testStart = GetSecs;
            
            % Play the sound
            PsychPortAudio('Start', pahandle, 1, 0, 1);
            
            % Check the keyboard for responses
            TestRespToBeMade = true;
            while TestRespToBeMade==true
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(oneKey)
                    TestResponse = 1;
                    TestRespToBeMade = false;
                elseif keyCode(twoKey)
                    TestResponse = 2;
                    TestRespToBeMade = false;
                elseif keyCode(threeKey)
                    TestResponse = 3;
                    TestRespToBeMade = false;
                elseif keyCode(fourKey)
                    TestResponse = 4;
                    TestRespToBeMade = false;
                end
                
                
                % Set the text size to 50. Draw the four movie frames and number them 1-4. Then set the text size back
                % to 12.
                Screen('TextSize', win, 50);
                Screen('DrawTexture', win, frameToShow1, [], [450 100 650 300]);
                DrawFormattedText(win, '1', 540, 40, [0 0 0]);
                Screen('DrawTexture', win, frameToShow2, [], [700 100 900 300]);
                DrawFormattedText(win, '2', 790, 40, [0 0 0]);
                Screen('DrawTexture', win, frameToShow3, [], [450 500 650 700]);
                DrawFormattedText(win, '3', 540, 440, [0 0 0]);
                Screen('DrawTexture', win, frameToShow4, [], [700 500 900 700]);
                DrawFormattedText(win, '4', 790, 440, [0 0 0]);
                Screen('TextSize', win, 12);
                DrawFormattedText(win, 'Using the number keys 1 through 4, choose the \n\nvideo that was shown while that sound was playing.', 'center', screenYpixels * 0.80, [256 256 256]);
                Screen('Flip', win);
                
                % Check the keyboard for responses - off
                
                
            end
            
            % TEST SCREEN OFF TRIGGER
            lab_put_code(L,3);
            
            PsychPortAudio('Stop', pahandle, 1);
            
            
            % Calculate the RT
            testEnd = GetSecs;
            testrt = testEnd - testStart; % or -3 secs to compensate for sound play time
            
            
            % Clear the textures created by reading the frames of the movie
            Screen('Close', frameToShow1);
            Screen('Close', frameToShow2);
            Screen('Close', frameToShow3);
            Screen('Close', frameToShow4);
            
            % Record trial data to the data matrix
            test = trialMatrixShuffled;
            
            t = dataset2cell(test([testtrial], [1]));
            Movie = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [2]));
            List = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [3]));
            Sound = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [4]));
            SoundList = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [5]));
            SoundAngle = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [6]));
            Frequency = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [7]));
            SoundFolder = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [8]));
            SoundFile = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [9]));
            MovieFolder = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [10]));
            MovieFile = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [11]));
            MovieFile1 = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [12]));
            MovieFile2 = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [13]));
            MovieFile3 = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [14]));
            MovieFile4 = cell2mat(t(2,1));
            t = dataset2cell(test([testtrial], [15]));
            CorrResp = cell2mat(t(2,1));
            
            testRespMat{testtrial, 1} = participant_num;
            testRespMat{testtrial, 2} = num2str(block-1);
            testRespMat{testtrial, 3} = testname;
            testRespMat{testtrial, 4} = testtrial;
            testRespMat{testtrial, 5} = Movie;
            testRespMat{testtrial, 6} = List;
            testRespMat{testtrial, 7} = Sound;
            testRespMat{testtrial, 8} = SoundList;
            testRespMat{testtrial, 9} = SoundAngle;
            testRespMat{testtrial, 10} = Frequency;
            testRespMat{testtrial, 11} = SoundFolder;
            testRespMat{testtrial, 12} = SoundFile;
            testRespMat{testtrial, 13} = MovieFolder;
            testRespMat{testtrial, 14} = MovieFile;
            testRespMat{testtrial, 15} = MovieFile1;
            testRespMat{testtrial, 16} = MovieFile2;
            testRespMat{testtrial, 17} = MovieFile3;
            testRespMat{testtrial, 18} = MovieFile4;
            testRespMat{testtrial, 19} = CorrResp;
            testRespMat{testtrial, 20} = TestResponse;
            testRespMat{testtrial, 21} = testrt;
        end
        % Save the Memory Test data to a file
        TestData = dataset(testRespMat);
        testsavename=[num2str(participant_num) '-block-' num2str(block-1) '-Test-' datestr(date) '.csv'];
        cd 'C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Data\TestData';
        %export(TestData, 'XLSfile', testsavename);
        export(TestData, 'file', testsavename, 'Delimiter', ',');
        
        
        %------------------------------------------------------------------------------------------------------
        %   1.2 END STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK
        %   THIS ENDS 1.2
        %------------------------------------------------------------------------------------------------------
    end
    %------------------------------------------------------------------------------------------------------
    %   THIS ENDS THE BLOCK LOOP
    %------------------------------------------------------------------------------------------------------
    
    
    %----------------------------------------------------------------------------------------------------------
    %   2.0 THETA SYNC TEST CONDITIONS
    %----------------------------------------------------------------------------------------------------------
    
    % Define the response matrix for the sync test trials.
    respMat = cell(numTrials, 20);
    
    name = 'SyncTestTheta';
    [numTrials] = size(eval(name),1);
    
    % Shuffle trial order
    shuffler = Shuffle(1:numTrials);
    trialMatrix = eval(name);
    trialMatrix.ShuffleOrder = shuffler';
    trialMatrixShuffled = sortrows(trialMatrix, 'ShuffleOrder');
    
    %----------------------------------------------------------------------------------------------------------
    %   2.0 EXPERIMENTAL LOOP - SYNC TEST TRIALS
    %-----------------------------------------------------------------------------------------------------------
    
    % Begin the trial loop for the SyncTest task.
    for trial = 1:numTrials
        %------------------------------------------------------------------------------------------------------
        %   2.0 Read in and prepare video - see comments in the encoding section
        %------------------------------------------------------------------------------------------------------
        moviefile = trialMatrixShuffled;
        moviefolder = dataset2cell(moviefile([trial], [9]));
        moviefolder = cell2mat(moviefolder(2,1));
        moviefolder = ['C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Movies\' moviefolder];
        % change directory to the appropriate folder
        cd(moviefolder);
        moviefile = trialMatrixShuffled;
        moviefile = dataset2cell(moviefile([trial], [10]));
        moviefile = cell2mat(moviefile(2,1));
        avi_object=VideoReader(moviefile);
        avi_frames=read(avi_object);
        num_frames=get(avi_object, 'NumberofFrames');
        framerate=get(avi_object, 'FrameRate');
        
        %------------------------------------------------------------------------------------------------------
        %   2.0 Read in and prepare audio - see comments in the encoding section
        %------------------------------------------------------------------------------------------------------
        soundfile = trialMatrixShuffled;
        soundfolder = dataset2cell(soundfile([trial], [7]));
        soundfolder = cell2mat(soundfolder(2,1));
        soundfolder = ['C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Sounds\' soundfolder];
        cd(soundfolder);
        soundfile = dataset2cell(soundfile([trial], [8]));
        soundfile = cell2mat(soundfile(2,1));
        [wav_orig,Fs]=audioread(soundfile); % read audio file, call it wav_orig, sample rate is Fs
        PsychPortAudio('FillBuffer', pahandle, wav_orig');
        
        %------------------------------------------------------------------------------------------------------
        %   2.0 BEGIN SYNC TEST TRIALS
        %------------------------------------------------------------------------------------------------------
        % If this is the first trial we present the instruction screen and wait for a key-press
        if trial == 1
            DrawFormattedText(win, 'Please alert the experimenter before you continue.',...
                'center', 'center', 0);
            Screen('Flip', win);
            pause(1)
            % key 'j' has to be pressed to continue
            respToBeMade = true;
            while respToBeMade==true
                 [keyIsDown,secs, keyCode] = KbCheck;
                 if keyCode(escapeKey) % if ESC is pressed, terminate the experiment
                     ShowCursor;
                     sca;
                     return
                 elseif keyCode(74)
                     respToBeMade = false;
                 else
                     respToBeMade = true;
                 end
            end
            DrawFormattedText(win, 'You will be presented with a short video and a sound clip. \n\nYour task is to judge whether the sound and video are presented in synchrony. Press Any Key To Begin.',...
                'center', 'center', 0);
            Screen('Flip', win);
            pause(1)
            KbStrokeWait;
        end
        
        % Now we present the isi interval with fixation point
        rframes = randi([0 150]);
        for frame = 1:isiTimeFrames+rframes
            % Draw the fixation point
            DrawFormattedText(win, '+', 'center', 'center', 0);
            Screen('Flip', win);
        end
        
        %------------------------------------------------------------------------------------------------------
        %   2.0 START STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK
        %------------------------------------------------------------------------------------------------------
        
        % Make the video by grabbing the frames
        for frame = 1:num_frames
            frameToShow{frame} = Screen('MakeTexture', win, avi_frames(:,:,:,frame));
        end
        
        % Use a screen with 75 hz refresh rate. The videos have a 25 framerate. So we need 3 displays of each
        % video frame for a 3-second video presentation. For 60 hz, 2.4
        % of each video frame
        flipsPerFrame = 3;
        
        % Visual processing time is 50ms, auditory is 10ms. Thus, need to play the visual stimuli 40ms before
        % the auditory stimuli. But account for approx 2ms sound onset
        % latency (11ms in fMRI), so play visual stimuli 38ms (29 in
        % fMRI) before auditory for the 40ms difference.
        
        PsychPortAudio('Start', pahandle, 1, inf, 0);
        WaitSecs(0.1);
        % flip, and get vertical refresh timestamp
        [refreshTimestamp] = Screen('Flip', win);
        
        % SYNC TEST STIMULI ON TRIGGER
        lab_put_code(L,4);
        

        
        % Draw the movie
        ifrm = 0; % the current frame (starting at 0)
        for frame = 1:num_frames % for each frame in the movie
            ifrm = ifrm+1; % the current frame
            for iflip = 1:flipsPerFrame % to draw each frame in the movie "flipsPerFrame" times
                Screen('DrawTexture', win, frameToShow{frame}, [], []);
                % ('Flip', 'window', 'when'). When = 0.5 * ifi sec after last
                % refresh timestamp. ie, flip at the first possible
                % retrace after the last flip timestamp plus the
                % duration in sec of half of an inter-frame interval
                [refreshTimestamp] = Screen('Flip', win, refreshTimestamp + 0.5*ifi);
                % Play the sound. When = 38ms after video onset
                if frame == 2 && iflip == 1
                    PsychPortAudio('RescheduleStart', pahandle, refreshTimestamp);
                end
            end
        end
        
        % SYNC TEST STIMULI OFF TRIGGER
        
        % Stop the sound
        PsychPortAudio('Stop', pahandle, 1);
        
        % Clear the textures created by reading the frames of the movie
        for frame = 1:num_frames
            Screen('Close', frameToShow{frame});
        end
        
        % Draw the rating screen
        DrawFormattedText(win, 'Using the numbers 1 and 2, state whether you think that the audio and video were in synchrony.\n\n 1 means that the sound and video were NOT in synchrony. \n\n2 means that the sound and video were in synchrony.',...
            'center', 'center', 0);
        Screen('Flip', win);
        
        
        % Start the timer for calculating the response times
        tStart = GetSecs;
        
        % Check the keyboard for responses
        respToBeMade = true; % set it so that a response is required
        while respToBeMade==true
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey) % if ESC is pressed, terminate the experiment
                ShowCursor;
                sca;
                return
            elseif keyCode(oneKey)
                response = 1;
                respToBeMade = false;
            elseif keyCode(twoKey)
                response = 2;
                respToBeMade = false;
            end
        end
        
        % Get the time when the response is made, and calculate the RT
        tEnd = GetSecs;
        responsert = tEnd - tStart;
        
        
        % Record trial data to the data matrix
        test = trialMatrixShuffled;
        
        t = dataset2cell(test([trial], [1]));
        Movie = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [2]));
        List = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [3]));
        Sound = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [4]));
        SoundList = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [5]));
        SoundAngle = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [6]));
        Frequency = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [7]));
        SoundFolder = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [8]));
        SoundFile = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [9]));
        MovieFolder = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [10]));
        MovieFile = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [11]));
        CorrResp = cell2mat(t(2,1));
        
        
        respMat{trial, 1} = participant_num;
        respMat{trial, 2} = num2str(block-1); % Block number for this participant
        respMat{trial, 3} = name; % Block name (A/B/C/D)
        respMat{trial, 4} = trial; % trial number
        respMat{trial, 5} = Movie;
        respMat{trial, 6} = List;
        respMat{trial, 7} = Sound;
        respMat{trial, 8} = SoundList;
        respMat{trial, 9} = SoundAngle;
        respMat{trial, 10} = Frequency;
        respMat{trial, 11} = SoundFolder;
        respMat{trial, 12} = SoundFile;
        respMat{trial, 13} = MovieFolder;
        respMat{trial, 14} = MovieFile;
        respMat{trial, 15} = CorrResp;
        respMat{trial, 16} = moviefile; % movie filename
        respMat{trial, 17} = soundfile; % sound filename
        respMat{trial, 18} = response; % the response key
        respMat{trial, 19} = responsert; % the RT
        respMat{trial, 20} = CorrResp; % the correct response
    end
    
    % Save the sync data to a file
    SyncData = dataset(respMat);
    savename=[num2str(participant_num) '-Sync-Theta-' datestr(date) '.csv'];
    cd 'C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Data\SyncDataTheta';
    %export(SyncData, 'XLSfile', savename);
    export(SyncData, 'file', savename, 'Delimiter', ',');
    
    %%
    
    %----------------------------------------------------------------------------------------------------------
    %   2.0 THETA SOUND ONLY
    %----------------------------------------------------------------------------------------------------------
    
    name = 'Sounds';
    [numTrials] = size(eval(name),1);
    
    % Define the response matrix for the sync test trials.
    respMat = cell(numTrials, 9);
    
    % Shuffle trial order
    shuffler = Shuffle(1:numTrials);
    trialMatrix = eval(name);
    trialMatrix.ShuffleOrder = shuffler';
    trialMatrixShuffled = sortrows(trialMatrix, 'ShuffleOrder');
    
    %----------------------------------------------------------------------------------------------------------
    %   2.0 EXPERIMENTAL LOOP - SOUND TEST TRIALS
    %-----------------------------------------------------------------------------------------------------------
    
    % Begin the trial loop for the Sound task.
    for trial = 1:numTrials
        
        %------------------------------------------------------------------------------------------------------
        %   2.0 Read in and prepare audio - see comments in the encoding section
        %------------------------------------------------------------------------------------------------------
        soundfile = trialMatrixShuffled;
        soundfolder = dataset2cell(soundfile([trial], [6]));
        soundfolder = cell2mat(soundfolder(2,1));
        soundfolder = ['C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Sounds\' soundfolder];
        cd(soundfolder);
        soundfile = dataset2cell(soundfile([trial], [7]));
        soundfile = cell2mat(soundfile(2,1));
        [wav_orig,Fs]=audioread(soundfile); % read audio file, call it wav_orig, sample rate is Fs
        PsychPortAudio('FillBuffer', pahandle, wav_orig');
        
        %------------------------------------------------------------------------------------------------------
        %   2.0 BEGIN SOUND TRIALS
        %------------------------------------------------------------------------------------------------------
        % If this is the first trial we present the instruction screen and wait for a key-press
        if trial == 1
            DrawFormattedText(win, 'Please alert the experimenter before you continue.',...
                'center', 'center', 0);
            Screen('Flip', win);
            pause(1)
            % key 'k' has to be pressed to continue
            respToBeMade = true;
            while respToBeMade==true
                 [keyIsDown,secs, keyCode] = KbCheck;
                 if keyCode(escapeKey) % if ESC is pressed, terminate the experiment
                     ShowCursor;
                     sca;
                     return
                 elseif keyCode(75)
                     respToBeMade = false;
                 else
                     respToBeMade = true;
                 end
            end
            DrawFormattedText(win, 'You will be presented with a short sound clip. \n\nYour task is to rate how pleasant you think the sound is. \n\nPress Any Key To Begin.',...
                'center', 'center', 0);
            Screen('Flip', win);
            pause(1)
            KbStrokeWait;
        end
        
        % Let's present a fixation cross all the time while presenting
        % sound
%         % Now we present the isi interval with fixation point
%         rframes = randi([0 150]);
%         for frame = 1:isiTimeFrames+rframes
%             % Draw the fixation point
%             DrawFormattedText(win, '+', 'center', 'center', 0);
%             Screen('Flip', win);
%         end
        
        %------------------------------------------------------------------------------------------------------
        %   2.0 START STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK
        %------------------------------------------------------------------------------------------------------
        
        PsychPortAudio('Start', pahandle, 1, inf, 0);
        WaitSecs(0.1);
        
        % SOUND TEST STIMULI ON TRIGGER
        lab_put_code(L,5);
        
        % flip, and get vertical refresh timestamp
        [refreshTimestamp] = Screen('Flip', win);
        
        % draw fixation cross screen while presenting sound
        DrawFormattedText(win, '+', 'center', 'center', 0);
        Screen('Flip', win);
        PsychPortAudio('RescheduleStart', pahandle, 0);
        
        % Stop the sound
        PsychPortAudio('Stop', pahandle, 1);
        
        % Draw the rating screen
        DrawFormattedText(win, 'Using the numbers 1 through 5, rate how pleasant you think the sound was.\n\n 1 means that the sound was NOT pleasant, \n\n and 5 means that the sound was very pleasant',...
            'center', 'center', 0);
        Screen('Flip', win);
        
        % Start the timer for calculating the response times
        tStart = GetSecs;
        
        % Check the keyboard for responses
        respToBeMade = true; % set it so that a response is required
        while respToBeMade==true
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey) % if ESC is pressed, terminate the experiment
                ShowCursor;
                sca;
                return
            elseif keyCode(oneKey)
                response = 1;
                respToBeMade = false;
            elseif keyCode(twoKey)
                response = 2;
                respToBeMade = false;
            elseif keyCode(threeKey)
                response = 3;
                respToBeMade = false;
            elseif keyCode(fourKey)
                response = 4;
                respToBeMade = false;
            elseif keyCode(fiveKey)
                response = 5;
                respToBeMade = false;
            end
        end
        
        % Get the time when the response is made, and calculate the RT
        tEnd = GetSecs;
        responsert = tEnd - tStart;
        
        % Record trial data to the data matrix
        test = trialMatrixShuffled;
        
        t = dataset2cell(test([trial], [1]));
        List = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [2]));
        Sound = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [3]));
        SoundList = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [4]));
        SoundAngle = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [5]));
        Frequency = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [6]));
        SoundFolder = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [7]));
        SoundFile = cell2mat(t(2,1));
        
        respMat{trial, 1} = List;
        respMat{trial, 2} = Sound;
        respMat{trial, 3} = SoundList;
        respMat{trial, 4} = SoundAngle;
        respMat{trial, 5} = Frequency;
        respMat{trial, 6} = SoundFolder;
        respMat{trial, 7} = SoundFile;
        respMat{trial, 8} = response; % the response key
        respMat{trial, 9} = responsert; % the RT
    end
    
    % Save the sound data to a file
    SoundData = dataset(respMat);
    savename=[num2str(participant_num) '-Sound-' datestr(date) '.csv'];
    cd 'C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Data\SoundData';
    export(SoundData, 'file', savename, 'Delimiter', ',');
    
    
    %%
    
    
    %----------------------------------------------------------------------------------------------------------
    %   2.0 THETA MOVIE TEST CONDITIONS
    %----------------------------------------------------------------------------------------------------------
    
    name = 'Movies';
    [numTrials] = size(eval(name),1);
    
    % Define the response matrix for the sync test trials.
    respMat = cell(numTrials, 5);
    
    % Shuffle trial order
    shuffler = Shuffle(1:numTrials);
    trialMatrix = eval(name);
    trialMatrix.ShuffleOrder = shuffler';
    trialMatrixShuffled = sortrows(trialMatrix, 'ShuffleOrder');
    
    %----------------------------------------------------------------------------------------------------------
    %   2.0 EXPERIMENTAL LOOP - SYNC TEST TRIALS
    %-----------------------------------------------------------------------------------------------------------
    
    % Begin the trial loop for the SyncTest task.
    for trial = 1:numTrials
        %------------------------------------------------------------------------------------------------------
        %   2.0 Read in and prepare video - see comments in the encoding section
        %------------------------------------------------------------------------------------------------------
        moviefile = trialMatrixShuffled;
        moviefolder = dataset2cell(moviefile([trial], [2]));
        moviefolder = cell2mat(moviefolder(2,1));
        moviefolder = ['C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Movies\' moviefolder];
        % change directory to the appropriate folder
        cd(moviefolder);
        moviefile = trialMatrixShuffled;
        moviefile = dataset2cell(moviefile([trial], [3]));
        moviefile = cell2mat(moviefile(2,1));
        avi_object=VideoReader(moviefile);
        avi_frames=read(avi_object);
        num_frames=get(avi_object, 'NumberofFrames');
        framerate=get(avi_object, 'FrameRate');
        
        %------------------------------------------------------------------------------------------------------
        %   2.0 BEGIN MOVIE TRIALS
        %------------------------------------------------------------------------------------------------------
        % If this is the first trial we present the instruction screen and wait for a key-press
        if trial == 1
            DrawFormattedText(win, 'Please alert the experimenter before you continue.',...
                'center', 'center', 0);
            Screen('Flip', win);
            pause(1)
            % key 'r' has to be pressed to continue
            respToBeMade = true;
            while respToBeMade==true
                 [keyIsDown,secs, keyCode] = KbCheck;
                 if keyCode(escapeKey) % if ESC is pressed, terminate the experiment
                     ShowCursor;
                     sca;
                     return
                 elseif keyCode(82)
                     respToBeMade = false;
                 else
                     respToBeMade = true;
                 end
            end
            DrawFormattedText(win, 'You will be presented with a short video clip. \n\nYour task is to rate how pleasant you think the video is. \n\nPress Any Key To Begin.',...
                'center', 'center', 0);
            Screen('Flip', win);
            pause(1)
            KbStrokeWait;
        end
        
        % Now we present the isi interval with fixation point
        rframes = randi([0 150]);
        for frame = 1:isiTimeFrames+rframes
            % Draw the fixation point
            DrawFormattedText(win, '+', 'center', 'center', 0);
            Screen('Flip', win);
        end
        %------------------------------------------------------------------------------------------------------
        %   2.0 START STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK
        %------------------------------------------------------------------------------------------------------
        
        
        
        % Make the video by grabbing the frames
        for frame = 1:num_frames
            frameToShow{frame} = Screen('MakeTexture', win, avi_frames(:,:,:,frame));
        end
        
        % Use a screen with 75 hz refresh rate. The videos have a 25 framerate. So we need 3 displays of each
        % video frame for a 3-second video presentation. For 60 hz, 2.4
        % of each video frame
        flipsPerFrame = 3;
        
        % VIDEO TEST STIMULI ON TRIGGER
        lab_put_code(L,6);
        
        % flip, and get vertical refresh timestamp
        [refreshTimestamp] = Screen('Flip', win);
        
        % Draw the movie
        ifrm = 0; % the current frame (starting at 0)
        for frame = 1:num_frames % for each frame in the movie
            ifrm = ifrm+1; % the current frame
            for iflip = 1:flipsPerFrame % to draw each frame in the movie "flipsPerFrame" times
                Screen('DrawTexture', win, frameToShow{frame}, [], []);
                [refreshTimestamp] = Screen('Flip', win, refreshTimestamp + 0.5*ifi);
            end
        end
        
        % Clear the textures created by reading the frames of the movie
        for frame = 1:num_frames
            Screen('Close', frameToShow{frame});
        end
        
        % Draw the rating screen
        DrawFormattedText(win, 'Using the numbers 1 through 5, rate how pleasant you think the video was.\n\n 1 means that the video was NOT pleasant, \n\n and 5 means that the video was very pleasant',...
            'center', 'center', 0);
        Screen('Flip', win);
        
        % Start the timer for calculating the response times
        tStart = GetSecs;
        
        % Check the keyboard for responses
        respToBeMade = true; % set it so that a response is required
        while respToBeMade==true
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey) % if ESC is pressed, terminate the experiment
                ShowCursor;
                sca;
                return
            elseif keyCode(oneKey)
                response = 1;
                respToBeMade = false;
            elseif keyCode(twoKey)
                response = 2;
                respToBeMade = false;
            elseif keyCode(threeKey)
                response = 3;
                respToBeMade = false;
            elseif keyCode(fourKey)
                response = 4;
                respToBeMade = false;
            elseif keyCode(fiveKey)
                response = 5;
                respToBeMade = false;
            end
        end
        
        % Get the time when the response is made, and calculate the RT
        tEnd = GetSecs;
        responsert = tEnd - tStart;
        
        % Record trial data to the data matrix
        test = trialMatrixShuffled;
        
        t = dataset2cell(test([trial], [1]));
        Movie = cell2mat(t(2,1));
        t = dataset2cell(test([trial], [3]));
        MovieFile = cell2mat(t(2,1));
        
        respMat{trial, 1} = Movie;
        respMat{trial, 2} = MovieFile;
        respMat{trial, 3} = response; % the response key
        respMat{trial, 4} = responsert; % the RT
    end
    
    % Save the sound data to a file
    MovieData = dataset(respMat);
    savename=[num2str(participant_num) '-Movie-' datestr(date) '.csv'];
    cd 'C:\Users\AJC458\Desktop\Audio-Visual Synch - EEG\Program\Data\MovieData';
    export(MovieData, 'file', savename, 'Delimiter', ',');
    
    %------------------------------------------------------------------------------------------------------
    %   2.0 END STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK
    %   THIS ENDS 2.0
    %------------------------------------------------------------------------------------------------------
    
    
    DrawFormattedText(win, 'You are now finished! \n\nThank you for your participation. \n\nPress any key to end the experiment.',...
        'center', 'center', 0);
    Screen('Flip', win);
    KbStrokeWait;
    
    sca
    ShowCursor;
    Priority(0);
    %Close sequence
catch
    %Same close sequence and psychlasterror
    sca
    ShowCursor;
    Priority(0);
    psychrethrow(psychlasterror);
    % Close the audio device
    if (exist('pahandle'))
        PsychPortAudio('Close', pahandle);
    end
    
    % Close LabJack
    lab_close;
    
end
sca


