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
magnitude_spectra = zeros(frameSize, numFrames);

% FFT-based pitch estimation
for i = 1:numFrames
    startIdx = (i - 1) * (frameSize - overlap) + 1;
    endIdx = startIdx + frameSize - 1;

    % Extract frame
    frame = audio_sliced(startIdx:endIdx);

    % Compute FFT
    fft_result = fft(frame);

    % Calculate magnitude spectrum
    magnitude_spectrum = abs(fft_result);

    % Store the magnitude spectrum for later plotting
    magnitude_spectra(:, i) = magnitude_spectrum;

    % Find peaks in the magnitude spectrum
    [peaks, locs] = findpeaks(magnitude_spectrum);

    % Extract pitch (fundamental frequency) from the first peak
    if ~isempty(peaks)
        pitch(i) = sampleRate / locs(1);
    else
        pitch(i) = 0; % If no peak is found
    end
end

% Create time and frequency vectors for plotting
time = (0:numFrames - 1) * (frameSize - overlap) / sampleRate;
frequency = (0:frameSize-1) * sampleRate / frameSize;

% Plot the magnitude spectrum in 3D
figure(6);
surf(time, frequency, magnitude_spectra, 'EdgeColor', 'none');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
zlabel('Magnitude');
title('3D Magnitude Spectrum over Time');

% Plot pitch over time
figure(2);
plot(time, pitch, 'LineWidth', 1);
xlabel('Time (s)');
ylabel('Pitch (Hz)');
title('Pitch Estimation using FFT');
grid on;
