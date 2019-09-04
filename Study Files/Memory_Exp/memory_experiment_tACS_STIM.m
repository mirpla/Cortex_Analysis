% Clear the workspace
close all;
clear all;
%% Set-up Stimulator

ndc = nDCS.BaseClient()         % create ndc handler used for stim

hostPC ='DCMCPC1027'            % Stimulator PC name
status = ndc.connect(hostPC);   % connects to stimulator
status = ndc.init_stim();       % sets start of stimulator

%%
% ------- Triggering BrainVision through Labjack

% add path to LabJack sample files (probably unnecessary)
addpath('C:\Users\colles-a-l-hanslmas\Desktop\michotte\toolbox\MATLAB_LJUDDotNET\Examples')
addpath('C:\Users\colles-a-l-hanslmas\Desktop\michotte\toolbox\MATLAB_LJUDDotNET\Examples\U3')

% Make the UD .NET assembly visible in MATLAB.
ljasm = NET.addAssembly('LJUDDotNet');
ljudObj = LabJack.LabJackUD.LJUD;

% Open the first found LabJack U3.
[ljerror, ljhandle] = ljudObj.OpenLabJackS('LJ_dtU3', 'LJ_ctUSB', '0', true, 0);

% Start by using the pin_configuration_reset IOType so that all pin
% assignments are in the factory default condition.
ljudObj.ePutS(ljhandle, 'LJ_ioPIN_CONFIGURATION_RESET', 0, 0, 0);

% Start Experiment

sca;
addpath(['C:\Users\colles-a-l-hanslmas\Documents\Project\Memory_Exp'])
Basepath = ['C:\Users\colles-a-l-hanslmas\Documents\Project\'];
AssertOpenGL;
% Force GetSecs and WaitSecs into memory to avoid latency later on
GetSecs;

WaitSecs(0.1);

% Setup PTB with some default values
PsychDefaultSetup(2);
InitializePsychSound(1);

%----------------------------------------------------------------------------------------------------------
%   Set up the audio
%----------------------------------------------------------------------------------------------------------
% Request latency mode 2
reqlatencyclass = 4;
% Requested output frequency. Must set this. 96000, 48000, or 44100. Ours are 44100
freq = 44100;
% Pointless to set this. Use the default to auto-selected to be optimal. 
buffersize = 32; %this is not used later?

% % Set based on work with oscilliscope 
%suggestedLatencySecs = 0.002; % not sure about this value
% % Set based on work with oscilliscope
latbias = []; %not sure about this value
% ASIO4ALL v2. May need to change if new hardware is installed
deviceid = 13; % PC % not sure about the deviceid so far 29/11/2017
% deviceid = -1; % Mac

% Open audio device for low-latency output
pahandle = PsychPortAudio('Open', deviceid, [], reqlatencyclass, freq, 2,buffersize);
%pahandle = PsychPortAudio('Open', deviceid, [], reqlatencyclass, freq, 2, buffersize, suggestedLatencySecs);
%pahandle = PsychPortAudio('Open', [], [], reqlatencyclass, freq, 2); % not sure should a new device id be added 29/11/2017

% Tell driver about hardware's inherent latency, determined via calibration once
prelat = PsychPortAudio('LatencyBias', pahandle, latbias);
postlat = PsychPortAudio('LatencyBias', pahandle); %not sure if a latbias should be added 29/11/2017

% Generate a beep at 1000Hz, 0.1 sec, 50% amplitude, to avoid latency later on
mynoise(1,:) = 0.5*MakeBeep(1000, 0.1, freq);
mynoise(2,:) = mynoise(1,:);
% Fill buffer with audio data
PsychPortAudio('FillBuffer', pahandle, mynoise);
% Perform one audio warmup trial, to get the sound hardware fully up and running, performing whatever lazy
% initialization only happens at real first use. This useless warmup will allow for lower latency for start
% of playback during actual use of the audio driver in the real trials

channel = 1;    % channel choice
state = 1; 
ljudObj.eDO(ljhandle, channel, state);  % sends triggeer
PsychPortAudio('Start', pahandle, 1, 0, 1);
state = 0;
ljudObj.eDO(ljhandle, channel, state);  % does not send trigger
PsychPortAudio('Stop', pahandle, 1);

% Use a screen with 75 hz refresh rate. The videos have a 25 framerate. So we need 3 displays of each
% video frame for a 3-second video presentation. For 60 hz, 2.4
% of each video frame
flipsPerFrame = 3;
% 
% ----------------------------------------------------------------------------------------------------------
%% Ok so now the audio hardware is fully initialised and our driver is on hot-standby, ready to start playback
%  of any sound with minimal latency
% ----------------------------------------------------------------------------------------------------------
% Create dialog box to gather participant number: input participant number
% without any zero e.g. 1,2,...10,11,...
participant_num = inputdlg('Participant Number', 'Participant Number');
participant_num = str2double(participant_num); 

session_num = inputdlg('Session Number', 'Session Number');
session_num = str2double(session_num); 

try
    
   % Comment this out for testing, uncomment before real participants
    HideCursor;
    
%     ----------------------------------------------------------------------------------------------------------
%       Set up the display and timing
%     ----------------------------------------------------------------------------------------------------------
%     select external screen
    screenid = max(Screen('Screens'));
%    create a window
    [win, winRect] = PsychImaging('OpenWindow', screenid, 0.5);
%     [win, winRect] = Screen(screenid, 'OpenWindow', 128, [0 0 800 800]); % for testing
%     define size of x and y based on screen size
    [screenXpixels, screenYpixels] = Screen('WindowSize', win);
%    define screen center based on screen size
    [xCenter, yCenter] = RectCenter(winRect);
%    set test font size
    Screen('TextSize', win, 12);
%    set text font
    Screen('TextFont', win, 'Helvetica');
    
 %   get the flip interval, based on screen refresh rate
    ifi = Screen('GetFlipInterval', win);
%    Set based on work with oscilliscope
    waitframes = 1;
%    Set based on work with oscilliscope
    isiTimeSecs = 1;
%    the above converted into frames
    isiTimeFrames = round(isiTimeSecs / ifi);
%    set Matlab priority to maximum
    topPriorityLevel = MaxPriority(win);
    
%     ----------------------------------------------------------------------------------------------------------
%       Display and timing setup complete
%     ----------------------------------------------------------------------------------------------------------
%     
%     ----------------------------------------------------------------------------------------------------------
%       Keyboard information: Define the keyboard keys that are listened
%       for. We will be using the QWERTY keys 1-5 as response keys and the
%       escape key as an exit/reset key
%     ----------------------------------------------------------------------------------------------------------
    escapeKey = KbName('ESCAPE');
    oneKey = KbName('1!');
    twoKey = KbName('2@');
    threeKey = KbName('3#');
    fourKey = KbName('4$');
    fiveKey = KbName('5%');
    
    rng('shuffle');
    %
    if session_num == 1
    %----------------------------------------------------------------------------------------------------------
    %   Practice block - using the practice to familiarise the task and
    %   check triggers
    %----------------------------------------------------------------------------------------------------------
    
    %load practice file
    cd([Basepath 'Memory_Exp/csv']);
    practices = dataset('File', 'gtb_practice_sblock.csv', 'Delimiter' ,',');

    numTrials = length(practices.trialnumber);

    %----------------------------------------------------------------------------------------------------------
    %   1.1 Make a response matrix
    %----------------------------------------------------------------------------------------------------------

    % Define the response matrix for the rating trials.
    respMat = cell(numTrials, 11);

    %----------------------------------------------------------------------------------------------------------
    %   1.1 EXPERIMENTAL LOOP - ENCODING TRIALS
    %----------------------------------------------------------------------------------------------------------
    % Make MatLab/PsychToolBox top priority. Undo this later.
    Priority(topPriorityLevel);
    
    % Begin the trial loop 
    for trial = 1:numTrials
        %------------------------------------------------------------------------------------------------------
        %   1.1 Read in and prepare video
        %------------------------------------------------------------------------------------------------------
        
        cd([Basepath, 'Materials/movies/']); 

        avi_object=VideoReader(practices.moviename{trial,1});
        % read in all frames of avi_object
        avi_frames=read(avi_object);
        % get number of frames in avi_object
        num_frames=get(avi_object, 'NumberofFrames');
        % get framerate of avi_object
        framerate=get(avi_object, 'FrameRate');

        %------------------------------------------------------------------------------------------------------
        %   1.1 Read in and prepare audio zero offset
        %------------------------------------------------------------------------------------------------------
        % read audio file, call it wav_orig, sample rate is Fs
        [wav_orig,Fs]=audioread([Basepath 'Materials/sounds/Gamma/' practices.soundfolder{trial,1} '/' practices.soundname{trial,1}]); 
        % prepare to play the sound by adding it to the audio buffer in advance
        
        PsychPortAudio('FillBuffer', pahandle, wav_orig');

        %------------------------------------------------------------------------------------------------------
        %   1.1 BEGIN TRIALS 0
        %------------------------------------------------------------------------------------------------------

        if trial == 1   
           DrawFormattedText(win, 'Practice: You will be presented with a short video and a sound clip. \n\nYour task is to judge how well the sound suits the contents of the video. \n\nPress Any Key To Begin.',...
                    'center', 'center', 0);
            Screen('Flip', win);
            pause(1)
            KbStrokeWait;
        end
        channel = 3;    % channel choice
        state = 1;
        ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      
        % Now we present the isi interval with fixation point
        [rframes] = ISIcross(isiTimeFrames, ifi);
        
        for frame = 1:isiTimeFrames+rframes
            % Draw the fixation point
            DrawFormattedText(win, '+', 'center', 'center', 0);
            Screen('Flip', win);
        end
        channel = 3;    % channel choice
        state = 0;
        ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      
        %------------------------------------------------------------------------------------------------------
        %   1.1 START STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK
        %------------------------------------------------------------------------------------------------------

        % Make the video by grabbing the frames
        for frame = 1:num_frames
            frameToShow{frame} = Screen('MakeTexture', win, avi_frames(:,:,:,frame));
        end

        % Visual processing time is 50ms, auditory is 10ms. Thus, need to play the visual stimuli 40ms before
        % the auditory stimuli. But account for approx 2ms sound onset
        % latency (11ms in fMRI), so play visual stimuli 38ms (29 in
        % fMRI) before auditory for the 40ms difference.
        PsychPortAudio('Start', pahandle, 1, inf, 0);
        WaitSecs(0.1);
        % flip, and get vertical refresh timestamp and stimulus onset time
        [refreshTimestamp StimulusOnsetTime] = Screen('Flip', win);
        
        %play the sound at 2 ifi after stimulus onset
        PsychPortAudio('RescheduleStart', pahandle, StimulusOnsetTime+ifi*2);
        channel = 1;    % channel choice
        state = 1;
        ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      
        
        % To ensure PTB has enough time to schedule the start of the sound we flip the sceen another time
        [refreshTimestamp] = Screen('Flip', win);
        
        % Draw the movie
        ifrm = 0; % the current frame (starting at 0)
        for frame = 1:num_frames % for each frame in the movie
            ifrm = ifrm+1; % the current frame
            for iflip = 1 % to draw each frame in the movie "flipsPerFrame" times
                Screen('DrawTexture', win, frameToShow{frame}, [], []);
                [refreshTimestamp] = Screen('Flip', win, refreshTimestamp + 0.5*ifi);
            end
        end

        % Stop the sound
        channel = 1;    % channel choice
        state = 0;
        ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      
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
        respMat{trial, 1} = participant_num;
        respMat{trial, 2} = 'practice'; %block number
        respMat{trial, 3} = trial; % trial number
        respMat{trial, 4} = practices.moviename{trial,1}; % Movie from csv
        respMat{trial, 5} = practices.soundfolder{trial,1}; % Sound folder from csv
        respMat{trial, 6} = practices.soundname{trial,1}; % Sound from csv
        respMat{trial, 7} = practices.soundphase(trial,1); % Sound phase from csv
        respMat{trial, 8} = practices.soundcat{trial,1}; % Sound category from csv 
        respMat{trial, 9} = response; % the response key
        respMat{trial, 10} = responsert; % the RT


        % Save the Ratings data to a file
        RatingsData = dataset(respMat);
        savename=['subj' num2str(participant_num) '-practice-Ratings.csv'];
        cd([Basepath '/Behav_Data/RatingsData']); 
        mkdir(['subj' num2str(participant_num)]);
        cd([Basepath '/Behav_Data/RatingsData/subj' num2str(participant_num)]);
        export(RatingsData, 'file', savename, 'Delimiter', ',');

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
    
    %load practice file
    cd([Basepath '/Memory_Exp/csv']);
    practicet = dataset('File', 'gtb_practice_tblock.csv', 'Delimiter' ,',');

    numTrials = length(practicet.trialnumber);

    %----------------------------------------------------------------------------------------------------------
    %   1.1 Make a response matrix
    %----------------------------------------------------------------------------------------------------------

    % Define the response matrix for the rating trials.
    testrespMat = cell(numTrials, 15);
    
    % Make MatLab/PsychToolBox top priority. Undo this later.
    Priority(topPriorityLevel);

    % Begin trial loop for the memory test trials
    for testtrial = 1:numTrials
        
        %------------------------------------------------------------------------------------------------------
        %   1.2 Read in and prepare video - see comments in the encoding section
        %------------------------------------------------------------------------------------------------------
        
        cd([Basepath 'Materials/movies']);
        
        avi_object1=VideoReader(practicet.movie1{testtrial,1});
        avi_frames1=read(avi_object1);
        num_frames1=get(avi_object1, 'NumberofFrames');
        framerate1=get(avi_object1, 'FrameRate');
        
        avi_object2=VideoReader(practicet.movie2{testtrial,1});
        avi_frames2=read(avi_object2);
        num_frames2=get(avi_object2, 'NumberofFrames');
        framerate2=get(avi_object2, 'FrameRate');
        
        avi_object3=VideoReader(practicet.movie3{testtrial,1});
        avi_frames3=read(avi_object3);
        num_frames3=get(avi_object3, 'NumberofFrames');
        framerate3=get(avi_object3, 'FrameRate');
        
        avi_object4=VideoReader(practicet.movie4{testtrial,1});
        avi_frames4=read(avi_object4);
        num_frames4=get(avi_object4, 'NumberofFrames');
        framerate4=get(avi_object4, 'FrameRate');
        
        %------------------------------------------------------------------------------------------------------
        %   1.2 Read in and prepare audio - see comments in the encoding section
        %------------------------------------------------------------------------------------------------------
        [wav_orig,Fs]=audioread([Basepath 'Materials/sounds\Gamma/' practicet.soundfolder{testtrial,1} '/' practicet.soundname{testtrial,1}]); 
        % prepare to play the sound by adding it to the audio buffer in advance
        PsychPortAudio('FillBuffer', pahandle, wav_orig');
        
        %------------------------------------------------------------------------------------------------------
        %   1.2 BEGIN MEMORY TEST TRIALS
        %------------------------------------------------------------------------------------------------------
        
        channel = 3;    % channel choice
        state = 1;
        ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      
        [rframes] = ISIcross(isiTimeFrames, ifi);
        for frame = 1:isiTimeFrames+rframes
            % Draw the fixation point
            DrawFormattedText(win, '+', 'center', 'center', 0);
            Screen('Flip', win);
        end
        channel = 3;    % channel choice
        state = 0;
        ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      
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
   
        channel = 1;    % channel choice
        state = 1;
        ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      
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


        PsychPortAudio('Stop', pahandle, 1);
        channel = 1;    % channel choice
        state = 0;
        ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      

        % Calculate the RT
        testEnd = GetSecs;
        testrt = testEnd - testStart; % or -3 secs to compensate for sound play time


        % Clear the textures created by reading the frames of the movie
        Screen('Close', frameToShow1);
        Screen('Close', frameToShow2);
        Screen('Close', frameToShow3);
        Screen('Close', frameToShow4);

        % Record trial data to the data matrix
        testrespMat{trial, 1} = participant_num;
        testrespMat{trial, 2} = 'practice'; %block number
        testrespMat{trial, 3} = testtrial; % trial number
        testrespMat{trial, 4} = practicet.moviename{testtrial,1}; % Movie from csv
        testrespMat{trial, 5} = practicet.soundfolder{testtrial,1}; % Sound folder from csv
        testrespMat{trial, 6} = practicet.soundname{testtrial,1}; % Sound from csv
        testrespMat{trial, 7} = practicet.soundphase(testtrial,1); % Sound phase from csv
        testrespMat{trial, 8} = practicet.soundcat{testtrial,1}; % Sound category from csv 
        testrespMat{trial, 9} = practicet.movie1{testtrial,1}; % Movie1 from csv
        testrespMat{trial, 10} = practicet.movie2{testtrial,1}; % Movie2 from csv
        testrespMat{trial, 11} = practicet.movie3{testtrial,1}; % Movie3 from csv
        testrespMat{trial, 12} = practicet.movie4(testtrial,1); % Movie4 from csv
        testrespMat{trial, 13} = practicet.correctresponse(testtrial,1); % Correct Response from csv
        testrespMat{trial, 14} = TestResponse; % the response key
        testrespMat{trial, 15} = testrt; % the RT
        
    end
    
    % Save the Memory Test data to a file
    TestData = dataset(testrespMat);
    testsavename=['subj' num2str(participant_num) '-practice-Test.csv'];
    cd([Basepath '/Behav_Data/TestData']); 
    mkdir(['subj' num2str(participant_num)]);
    cd([Basepath '/Behav_Data/TestData/subj' num2str(participant_num)]);
    export(TestData, 'file', testsavename, 'Delimiter', ',');
    
    %------------------------------------------------------------------------------------------------------
    %   1.2 END STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK
    %   THIS ENDS 1.2
    %------------------------------------------------------------------------------------------------------
     end 

    %----------------------------------------------------------------------------------------------------------
    %   Begin the real experiment block loop, from 1-16
    %   THIS IS 1.0
    %----------------------------------------------------------------------------------------------------------
    cd([Basepath 'Memory_Exp\csv/subj',num2str(participant_num)])
    
    for block = 1+((length(dir(['gtb_s', num2str(participant_num),'_block*']))/2)*(session_num-1)):6+(length(dir(['gtb_s', num2str(participant_num),'_block*']))/2)*(session_num-1)
        %load file
        cd([Basepath 'Memory_Exp\csv/subj',num2str(participant_num)]);
        blocks = dataset('File', ['gtb_s',num2str(participant_num),'_block',num2str(block),'.csv'], 'Delimiter' ,',');

        numTrials = length(blocks.trialnumber);

        %----------------------------------------------------------------------------------------------------------
        %   1.1 Make a response matrix
        %----------------------------------------------------------------------------------------------------------

        % Define the response matrix for the rating trials.
        respMat = cell(numTrials, 11);

        %----------------------------------------------------------------------------------------------------------
        %   1.1 EXPERIMENTAL LOOP - ENCODING TRIALS
        %----------------------------------------------------------------------------------------------------------
        % Make MatLab/PsychToolBox top priority. Undo this later.
        Priority(topPriorityLevel);

        % Begin the trial loop 
        for trial = 1:numTrials
            %------------------------------------------------------------------------------------------------------
            %   1.1 Read in and prepare video
            %------------------------------------------------------------------------------------------------------

            cd([Basepath 'Materials/movies']); 

            avi_object=VideoReader(blocks.moviename{trial,1});
            % read in all frames of avi_object
            avi_frames=read(avi_object);
            % get number of frames in avi_object
            num_frames=get(avi_object, 'NumberofFrames');
            % get framerate of avi_object
            framerate=get(avi_object, 'FrameRate');

            %------------------------------------------------------------------------------------------------------
            %   1.1 Read in and prepare audio zero offset
            %------------------------------------------------------------------------------------------------------
            % read audio file, call it wav_orig, sample rate is Fs
            [wav_orig,Fs]=audioread([Basepath 'Materials/sounds/Theta/' blocks.soundfolder{trial,1} '/' blocks.soundname{trial,1}]); 
            % prepare to play the sound by adding it to the audio buffer in advance
            PsychPortAudio('FillBuffer', pahandle, wav_orig');

            %------------------------------------------------------------------------------------------------------
            %   1.1 BEGIN TRIALS 0
            %------------------------------------------------------------------------------------------------------
            % If this is the first trial we present the instruction screen and wait for a key-press
            if trial == 1
                % after the practice 
                if block == 1 
                   DrawFormattedText(win, 'Block 1: You will be presented with a short video and a sound clip. \n\nYour task is to judge how well the sound suits the contents of the video. \n\nPress Any Key To Begin.',...
                        'center', 'center', 0);
                   Screen('Flip', win);
                   pause(1)
                   KbStrokeWait;
                   % for block starting after the practice
                elseif block >= 2
                    DrawFormattedText(win, ['Take a break now. Next block will be Block ',num2str(block),'\n\nYou will be presented with a short video and a sound clip. \n\nYour task is to judge how well the sound suits the contents of the video. \n\nPress Any Key To Begin.'],...
                    'center', 'center', 0);
                    Screen('Flip', win);
                    pause(1)
                    KbStrokeWait;
                end
            end

            % Now we present the isi interval with fixation point
            channel = 3;    % channel choice
            state = 1;
            ljudObj.eDO(ljhandle, channel, state);  % sends trigger
        
            [rframes] = ISIcross(isiTimeFrames, ifi);
            for frame = 1:isiTimeFrames+rframes
                % Draw the fixation point
                DrawFormattedText(win, '+', 'center', 'center', 0);
                Screen('Flip', win);
            end
            channel = 3;    % channel choice
            state = 0;
            ljudObj.eDO(ljhandle, channel, state);  % sends trigger
            
            %------------------------------------------------------------------------------------------------------
            %   1.1 START STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK
            %------------------------------------------------------------------------------------------------------

            % Make the video by grabbing the frames
            for frame = 1:num_frames
                frameToShow{frame} = Screen('MakeTexture', win, avi_frames(:,:,:,frame));
            end

            % Visual processing time is 50ms, auditory is 10ms. Thus, need to play the visual stimuli 40ms before
            % the auditory stimuli. But account for approx 2ms sound onset
            % latency (11ms in fMRI), so play visual stimuli 38ms (29 in
            % fMRI) before auditory for the 40ms difference.

            PsychPortAudio('Start', pahandle, 1, inf, 0);
            WaitSecs(0.1);
            % flip, and get vertical refresh timestamp and stimulus onset time
            [refreshTimestamp StimulusOnsetTime] = Screen('Flip', win);

            %play the sound at 2 ifi after stimulus onset
            PsychPortAudio('RescheduleStart', pahandle, StimulusOnsetTime+ifi*2);
            channel = 1;    % channel choice
            state = 1;
            ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      
            % To ensure PTB has enough time to schedule the start of the sound we flip the sceen another time
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

            % Stop the sound
            PsychPortAudio('Stop', pahandle, 1);
            channel = 1;    % channel choice
            state = 0;
            ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      
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
            respMat{trial, 1} = participant_num;
            respMat{trial, 2} = block; %block number
            respMat{trial, 3} = trial; % trial number
            respMat{trial, 4} = blocks.moviename{trial,1}; % Movie from csv
            respMat{trial, 5} = blocks.soundfolder{trial,1}; % Sound folder from csv
            respMat{trial, 6} = blocks.soundname{trial,1}; % Sound from csv
            respMat{trial, 7} = blocks.soundphase(trial,1); % Sound phase from csv
            respMat{trial, 8} = blocks.soundcat{trial,1}; % Sound category from csv 
            respMat{trial, 9} = response; % the response key
            respMat{trial, 10} = responsert; % the RT
            respMat{trial, 11} = tStart; % the time of the presentation of the rating screen 


            % Save the Ratings data to a file
            % Save the Ratings data to a file
            RatingsData = dataset(respMat);
            savename=['subj' num2str(participant_num) '-block-' num2str(block) '-Ratings.csv'];
            cd([Basepath 'Behav_Data/RatingsData\subj' num2str(participant_num)]);
            export(RatingsData, 'file', savename, 'Delimiter', ',');
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

        %load test file
        cd([Basepath '\Memory_Exp\csv\subj',num2str(participant_num)]);
        blockt = dataset('File', ['gtb_t',num2str(participant_num),'_block',num2str(block),'.csv'], 'Delimiter' ,',');

        numTrials = length(blockt.trialnumber);

        %----------------------------------------------------------------------------------------------------------
        %   1.1 Make a response matrix
        %----------------------------------------------------------------------------------------------------------

        % Define the response matrix for the rating trials.
        testrespMat = cell(numTrials, 15);

        % Make MatLab/PsychToolBox top priority. Undo this later.
        Priority(topPriorityLevel);

        % Begin trial loop for the memory test trials
        for testtrial = 1:numTrials

            %------------------------------------------------------------------------------------------------------
            %   1.2 Read in and prepare video - see comments in the encoding section
            %------------------------------------------------------------------------------------------------------

            cd([Basepath 'Materials/movies']);

            avi_object1=VideoReader(blockt.movie1{testtrial,1});
            avi_frames1=read(avi_object1);
            num_frames1=get(avi_object1, 'NumberofFrames');
            framerate1=get(avi_object1, 'FrameRate');

            avi_object2=VideoReader(blockt.movie2{testtrial,1});
            avi_frames2=read(avi_object2);
            num_frames2=get(avi_object2, 'NumberofFrames');
            framerate2=get(avi_object2, 'FrameRate');

            avi_object3=VideoReader(blockt.movie3{testtrial,1});
            avi_frames3=read(avi_object3);
            num_frames3=get(avi_object3, 'NumberofFrames');
            framerate3=get(avi_object3, 'FrameRate');

            avi_object4=VideoReader(blockt.movie4{testtrial,1});
            avi_frames4=read(avi_object4);
            num_frames4=get(avi_object4, 'NumberofFrames');
            framerate4=get(avi_object4, 'FrameRate');

            %------------------------------------------------------------------------------------------------------
            %   1.2 Read in and prepare audio - see comments in the encoding section
            %------------------------------------------------------------------------------------------------------
            [wav_orig,Fs]=audioread([Basepath 'Materials/sounds/Theta/' blockt.soundfolder{testtrial,1} '/' blockt.soundname{testtrial,1}]); 
            % prepare to play the sound by adding it to the audio buffer in advance
            PsychPortAudio('FillBuffer', pahandle, wav_orig');

            %------------------------------------------------------------------------------------------------------
            %   1.2 BEGIN MEMORY TEST TRIALS
            %------------------------------------------------------------------------------------------------------
        
            % Now we present the isi interval with fixation point
            channel = 3;    % channel choice
            state = 1;
            ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      
            [rframes] = ISIcross(isiTimeFrames, ifi);
            for frame = 1:isiTimeFrames+rframes
                % Draw the fixation point
                DrawFormattedText(win, '+', 'center', 'center', 0);
                Screen('Flip', win);
            end
            channel = 3;    % channel choice
            state = 0;
            ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      
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
            channel = 1;    % channel choice
            state = 1;
            ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      
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


            PsychPortAudio('Stop', pahandle, 1);
            channel = 1;    % channel choice
            state = 0;
            ljudObj.eDO(ljhandle, channel, state);  % sends trigger
      

            % Calculate the RT
            testEnd = GetSecs;
            testrt = testEnd - testStart; % or -3 secs to compensate for sound play time


            % Clear the textures created by reading the frames of the movie
            Screen('Close', frameToShow1);
            Screen('Close', frameToShow2);
            Screen('Close', frameToShow3);
            Screen('Close', frameToShow4);

            % Record trial data to the data matrix
            testrespMat{trial, 1} = participant_num;
            testrespMat{trial, 2} = block; %block number
            testrespMat{trial, 3} = testtrial; % trial number
            testrespMat{trial, 4} = blockt.moviename{testtrial,1}; % Movie from csv
            testrespMat{trial, 5} = blockt.soundfolder{testtrial,1}; % Sound folder from csv
            testrespMat{trial, 6} = blockt.soundname{testtrial,1}; % Sound from csv
            testrespMat{trial, 7} = blockt.soundphase(testtrial,1); % Sound phase from csv
            testrespMat{trial, 8} = blockt.soundcat{testtrial,1}; % Sound category from csv 
            testrespMat{trial, 9} = blockt.movie1{testtrial,1}; % Movie1 from csv
            testrespMat{trial, 10} = blockt.movie2{testtrial,1}; % Movie2 from csv
            testrespMat{trial, 11} = blockt.movie3{testtrial,1}; % Movie3 from csv
            testrespMat{trial, 12} = blockt.movie4(testtrial,1); % Movie4 from csv
            testrespMat{trial, 13} = blockt.correctresponse(testtrial,1); % Correct Response from csv
            testrespMat{trial, 14} = TestResponse; % the response key
            testrespMat{trial, 15} = testrt; % the RT

        end

        % Save the Memory Test data to a file
        TestData = dataset(testrespMat);
        testsavename=['subj' num2str(participant_num) '-block-' num2str(block) '-Test.csv'];
        cd([Basepath 'Behav_Data/TestData/subj' num2str(participant_num)]);
        export(TestData, 'file', testsavename, 'Delimiter', ',');

        %------------------------------------------------------------------------------------------------------
        %   1.2 END STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK
        %   THIS ENDS 1.2
        %------------------------------------------------------------------------------------------------------
    end


%     %------------------------------------------------------------------------------------------------------
%     %   2.0 END STIMULUS DISPLAY LOOP FOR THE CURRENT BLOCK
%     %   THIS ENDS 2.0
%     %------------------------------------------------------------------------------------------------------
%     
%     
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
    %lab_close;
    
end
sca

