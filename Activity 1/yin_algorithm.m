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
pitch_yin = zeros(numFrames, 1);

% YIN-based pitch estimation
for i = 1:numFrames
    startIdx = (i - 1) * (frameSize - overlap) + 1;
    endIdx = startIdx + frameSize - 1;

    % Extract frame
    frame = audio_sliced(startIdx:endIdx);

    % Calculate the YIN difference function
    yin_diff = yinDifferenceFunction(frame);

    % Calculate the cumulative mean normalized difference function (CMND)
    yin_cmnd = yinCumulativeMeanNormalizedDifference(yin_diff);

    % Find the first reliable minimum in the CMND curve
    [minValue, minIndex] = yinAbsoluteThreshold(yin_cmnd);

    % Extract pitch (fundamental frequency) from the YIN result
    pitch_yin(i) = sampleRate / minIndex;
end

% Create time vector for plotting
time = (0:numFrames - 1) * (frameSize - overlap) / sampleRate;

% Plot pitch over time for YIN
figure(4);
plot(time, pitch_yin, 'LineWidth', 1);
xlabel('Time (s)');
ylabel('Pitch (Hz)');
title('Pitch Estimation using YIN Algorithm');
grid on;

% YIN difference function calculation
function diff = yinDifferenceFunction(signal)
    frameSize = length(signal);
    diff = zeros(frameSize, 1);

    for tau = 1:frameSize
        diff(tau) = sum((signal(1:frameSize - tau) - signal(tau + 1:frameSize)).^2);
    end
end

% YIN cumulative mean normalized difference function calculation
function cmnd = yinCumulativeMeanNormalizedDifference(diff)
    frameSize = length(diff);
    cmnd = zeros(frameSize, 1);

    cmnd(1) = 1; % Avoid division by zero
    for tau = 2:frameSize
        cmnd(tau) = diff(tau) / ((1/frameSize) * sum(diff(1:frameSize - tau + 1)));
    end
end

% YIN absolute threshold calculation
function [minValue, minIndex] = yinAbsoluteThreshold(cmnd)
    frameSize = length(cmnd);
    threshold = 0.1; % Adjust threshold as needed

    % Find the first reliable minimum below the threshold
    [~, minIndex] = findpeaks(-cmnd, 'MinPeakHeight', -threshold);
    if isempty(minIndex)
        % If no reliable minimum is found, use the global minimum
        [~, minIndex] = min(cmnd);
    end
    
    minIndex = minIndex(1); % Take the first minimum if there are multiple
    minValue = cmnd(minIndex);
end
