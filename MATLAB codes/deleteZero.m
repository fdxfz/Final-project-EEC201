function y = deletrZero(x)
%Delete zeros at the start & end of the signal
%x-inout signal
%y=output signal

x1 = round(x, 3); % sensitivity 
cri = abs(x1) > db2mag(-30);
y = x(find(cri, 1, 'first'):find(cri, 1, 'last')); 
end

