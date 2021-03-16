clear; clc; close all hidden;
N = 200;
M = round(N*2/3);
p = 20;

% Step 0: Get file
[s1, fs1] = loadWAV(1);
[s2, fs2] = loadWAV(2);
[s3, fs3] = loadWAV(3);
[s4, fs4] = loadWAV(4);
[s5, fs5] = loadWAV(5);
[s6, fs6] = loadWAV(6);
[s7, fs7] = loadWAV(7);
[s8, fs8] = loadWAV(8);
[s9, fs9] = loadWAV(9);
[s10, fs10] = loadWAV(10);
[s11, fs11] = loadWAV(11);

timedomain(deleteZero(s1), fs1, 1)
timedomain(deleteZero(s2), fs2, 2)
timedomain(deleteZero(s3), fs3, 3)
timedomain(deleteZero(s4), fs4, 4)
timedomain(deleteZero(s5), fs5, 5)
timedomain(deleteZero(s6), fs6, 6)
timedomain(deleteZero(s7), fs7, 7)
timedomain(deleteZero(s8), fs8, 8)
timedomain(deleteZero(s9), fs9, 9)
timedomain(deleteZero(s10), fs10, 10)
timedomain(deleteZero(s11), fs11, 11)

%% Start MFCC
[c1, t1] = mfcc(deleteZero(s1), fs1, M, N, p);  MFCCfigure(c1, t1, p, 1)
[c2, t2] = mfcc(deleteZero(s2), fs2, M, N, p);  MFCCfigure(c2, t2, p, 2)
[c3, t3] = mfcc(deleteZero(s3), fs3, M, N, p);  MFCCfigure(c3, t3, p, 3)
[c4, t4] = mfcc(deleteZero(s4), fs4, M, N, p);  MFCCfigure(c4, t4, p, 4)
[c5, t5] = mfcc(deleteZero(s5), fs5, M, N, p);  MFCCfigure(c5, t5, p, 5)
[c6, t6] = mfcc(deleteZero(s6), fs6, M, N, p);  MFCCfigure(c6, t6, p, 6)
[c7, t7] = mfcc(deleteZero(s7), fs7, M, N, p);  MFCCfigure(c7, t7, p, 7)
[c8, t8] = mfcc(deleteZero(s8), fs8, M, N, p);  MFCCfigure(c8, t8, p, 8)
[c9, t9] = mfcc(deleteZero(s9), fs9, M, N, p);  MFCCfigure(c9, t9, p, 9)
[c10, t10] = mfcc(deleteZero(s10), fs10, M, N, p); MFCCfigure(c10, t10, p, 10)
[c11, t11] = mfcc(deleteZero(s11), fs11, M, N, p); MFCCfigure(c11, t11, p, 11)

% Plots
figure
plot(c1(5,:)', c1(9,:)', '*')
hold on
plot(c7(5,:)', c7(9,:)', 'x')
xlabel('mfcc-5'); ylabel('mfcc-9')
legend("Speaker 1", "Speaker 7")
grid on
title("compare 2 speakers")
