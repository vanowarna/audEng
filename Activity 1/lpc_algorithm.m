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
pitch_lpc = zeros(numFrames, 1);

% LPC-based pitch estimation
for i = 1:numFrames
    startIdx = (i - 1) * (frameSize - overlap) + 1;
    endIdx = startIdx + frameSize - 1;

    % Extract frame
    frame = audio_sliced(startIdx:endIdx);

    % Apply LPC analysis to obtain coefficients
    lpc_order = 12; % LPC order, adjust as needed
    lpc_coefficients = lpc(frame, lpc_order);

    % Filter the input signal with LPC coefficients to obtain residual signal
    residual_signal = filter(lpc_coefficients, 1, frame);

    % Find peaks in the autocorrelation of the residual signal
    [peaks, locs] = findpeaks(xcorr(residual_signal));

    % Extract pitch (fundamental frequency) from the first peak
    if ~isempty(peaks)
        pitch_lpc(i) = sampleRate / locs(1);
    else
        pitch_lpc(i) = 0; % If no peak is found
    end
end

% Create time vector for plotting
time = (0:numFrames - 1) * (frameSize - overlap) / sampleRate;

% Plot pitch over time for LPC
figure(3);
plot(time, pitch_lpc, 'LineWidth', 1);
xlabel('Time (s)');
ylabel('Pitch (Hz)');
title('Pitch Estimation using LPC');
grid on;
