function MFCCfigure(c,y,p,id)
%plot the result of MFCC
%   Detailed explanation goes here
figure
surf(y,1:p,c); view(0, 90); colorbar;
xlim([min(y), max(y)]); ylim([1 p]);
xlabel('Time'); ylabel('mfcc');
title(strcat('Speaker ID ', int2str(id)) );
end

