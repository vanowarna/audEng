% WARNASOORIYA W.A.V.G. | E/17/372 | EE599 AUDIO ENGINEERING AND ACOUSTICS

% Specify the path to your audio file
filename = "D:\ACADEMIC E17 DEEE UOP\Sem_8_UOP\EE599 AUDIO ENGINEERING AND ACOUSTICS (TE)(3)\ACTIVITIES\ACTIVITY 1\Dataset\sarigamapa.wav";

% Read the audio file
[audio, sampleRate] = audioread(filename);

% Slice the audio
audio_sliced = audio(sampleRate * 0.4 : sampleRate * 1.5);

% Define parameters
frameSize = 1024;
overlap = 512;   

% Initialize variables
numFrames = floor((length(audio_sliced) - overlap) / (frameSize - overlap));
pitch = zeros(numFrames, 1);

% Autocorrelation-based pitch estimation
for i = 1:numFrames
    startIdx = (i - 1) * (frameSize - overlap) + 1;
    endIdx = startIdx + frameSize - 1;

    % Extract frame
    frame = audio_sliced(startIdx:endIdx);

    % Calculate autocorrelation
    autocorr_result = xcorr(frame);

    % Find the first peak (excluding the trivial peak at lag 0)
    [peaks, locs] = findpeaks(autocorr_result(frameSize:end));
    
    % Extract pitch (fundamental frequency) from the first peak
    if ~isempty(peaks)
        pitch(i) = sampleRate / locs(1);
    else
        pitch(i) = 0; % If no peak is found
    end
end

% Create time vector for plotting
time = (0:numFrames - 1) * (frameSize - overlap) / sampleRate;

% Plot pitch over time
figure(1);
plot(time, pitch, 'LineWidth', 1);
xlabel('Time (s)');
ylabel('Pitch (Hz)');
title('Pitch Estimation using Autocorrelation');
grid on;

