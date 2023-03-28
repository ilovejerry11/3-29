clear;

[y, Fs] = audioread('WolframTones1.wav', [1, 44100*2]);
% [y, Fs] = audioread('Tones2.wav'); % five second ver.
% sound(y, Fs); % D E D C D

fmin = 27.5;
fmax = 4186;
Fpass = [fmin fmax];
% filt = designfilt(y, Fpass, Fs);
% y_filt = filter(filt, y);

y_filt = bandpass(y(:,1), Fpass, Fs);

% Define the parameters for the spectrogram
window = hamming(round(0.05*Fs), 'periodic'); % window function
noverlap = round(0.025*Fs); % number of samples to overlap between segments
nfft = 4096; % number of FFT points

[S, F, T] = spectrogram(y_filt, window, noverlap, nfft, Fs);
Mag = abs(S);

imagesc(T, F, Mag);
axis xy; colormap(jet); colorbar;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylim([fmin fmax]);

% Identify the dominant frequency in each time segment of the spectrogram
[MaxMag, Idx] = max(Mag);

% Set a threshold for the minimum magnitude of a frequency peak to be considered a note
for i = 1:length(Idx)
    if MaxMag(i) < 80
        Idx(i) = -1;
    end
end

% Print the frist note played in the music
for i = 1:length(Idx)
    if (Idx(i) ~= -1)
        disp(Idx(i));
        st = i + 1;
        break;
    end
end

% Print the notes played in the music
for i = st:length(Idx)
    if (Idx(i) ~= -1) && (Idx(i) ~= Idx(i-1))
        disp(Idx(i));
    end
end

% [pks, locs] = findpeaks(Mag(15,:), 'MinPeakHeight', 10); 

% [pks, locs] = findpeaks(y_filt, 'MinPeakDistance', round(Fs/27.5));

% freqs = locs / length(y_filt) * Fs;
% 
% notes = hertz2note(freqs);