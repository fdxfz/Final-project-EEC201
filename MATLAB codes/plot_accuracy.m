clear; clc;
n = 10; %number of iteration
SNRmin = 15;
SNRmax = 30;

% Variables
x = SNRmin:SNRmax;
failedCases = zeros(5, SNRmax-SNRmin+1);
type = [ "pink", "white", "brown", "blue", "purple"];

% Per trial, loop through speakers and add noise with certain SNRminr
for j = 1:n
    codebook = getCodebook(); % Train model for each new trial
    
    for k = 1:5
        for nl = SNRmin:SNRmax
            fc = 0;
            for i = 1:11
                [s, fs] = loadWAV(i); % get file
                sn = addNoise(s, type(k), nl); % Add noise
                [outSpkr, isValid] = test(sn, fs, codebook); % Get test output
                spkrRef = string(strcat('s', num2str(i))); % Get Reference Output
                if outSpkr ~= spkrRef
                    fc = fc + 1; % Calculate failed cases per SNRminr
                end
            end
            failedCases(k, nl-SNRmin+1) = failedCases(k, nl-SNRmin+1) + fc; % Add failed cases
        end
    end
end

% Get Accuracy
acc = (11 *n - failedCases) .* 100 ./ (11 * n);

% Plot
figure; plot(x, acc);
xlabel('Signal-to-Noise Ratio (dB)'); ylabel('Accuracy (%)');
title('Accuracy vs SNRminR'); grid on;
legend(type(1), type(2), type(3),type(4),type(5));