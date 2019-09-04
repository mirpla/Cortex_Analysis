%% read in audio file
triggers = audioread('Blues Channelenge.mp3');

%% calculate difference in trigger vs sound
Fs = 44100;

[trigpeaks, trigloc] = findpeaks(triggers(:,1), 'MinPeakHeight',0.02, 'MinPeakDistance', 100000);
[soundpeaks, soundloc] = findpeaks(triggers(:,2), 'MinPeakHeight',0.005);

%look for sound peak that is closest to the trigger
for x = 1:length(trigloc)
    [d,ix] = min(abs(soundloc-trigloc(x)));
    diff(x) = soundloc(ix) - trigloc(x);
    Onset(x) = soundloc(ix); 
end

% translate time difference into seconds
diffseconds = diff / Fs;

%% plotting 

hold on
plot(triggers)
legend('trigger','Sound')
plot(soundloc==Onset)
axis('tight')
xlim([0,1.8*1000000])
xticks([0, 450000, 900000, 1350000, 1800000])
xticklabels([0/Fs 450000/Fs 900000/Fs 1350000/Fs 1800000/Fs])