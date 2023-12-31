clear all; close all; clc;

[input_audio, Fs] = audioread('Laa Sanda Aaye.mp3'); 

% Choose the desired preset
selectedPreset = 'Rock'; % Change this to the desired preset

% Presets
switch selectedPreset
    case 'Jazz'
        presets = {[200, 1, 3], [3000, 1, -2], [6000, 1, 4]};
    case 'Pop'
        presets = {[100, 1, 4], [2000, 1, 5], [5000, 1, 3]};
    case 'Rock'
        presets = {[60, 1, 5], [900, 1, -3], [4000, 1, 5]};
    % Add more cases for other genres if needed
    otherwise
        error('Invalid preset name.');
end

output_audio = input_audio;
numChannels = size(input_audio, 2);

for i = 1:length(presets)
    % Design the filter
    [b, a] = designParametricEQ(presets{i}(1), presets{i}(2), presets{i}(3), Fs);
    for ch = 1:numChannels
        output_audio(:, ch) = filter(b, a, output_audio(:, ch));
    end
end

% Normalize the output
output_audio = output_audio / max(max(abs(output_audio)));

audiowrite('equalized_audio_rock.wav', output_audio, Fs);

sound(output_audio, Fs);


[H_orig, freq] = freqz(input_audio(:,1), 1, 4096, Fs);
H_before = 20 * log10(abs(H_orig));


[H_eq, ~] = freqz(output_audio(:,1), 1, 4096, Fs);
H_after = 20 * log10(abs(H_eq));

figure;
subplot(1, 2, 1);
plot(freq, H_before);
title('Frequency Response Before Equalization');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');

subplot(1, 2, 2);
plot(freq, H_after);
title('Frequency Response After Equalization');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');

% Save the figure as a PNG file
saveas(gcf, 'equalizer_response_rock.png');

% Function to design a parametric EQ filter
function [b, a] = designParametricEQ(f0, bw, G, Fs)
    % Design a second-order peaking filter (Parametric EQ)
    A = 10^(G/40);
    w0 = 2*pi*f0/Fs;
    alpha = sin(w0)*sinh(log(2)/2*bw*w0/sin(w0));
    
    b0 = 1 + alpha*A;
    b1 = -2*cos(w0);
    b2 = 1 - alpha*A;
    a0 = 1 + alpha/A;
    a1 = -2*cos(w0);
    a2 = 1 - alpha/A;
    
    b = [b0, b1, b2];
    a = [a0, a1, a2];
    
    % Normalize filter coefficients
    b = b / a0;
    a = a / a0;
end
