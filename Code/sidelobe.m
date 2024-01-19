function [SLL, side_peak] = sidelobe(amp)
tmp = -ones(length(amp),length(amp))*100; %儲存峰值
for i = 2:length(amp)-1 %row
    for j = 2:length(amp)-1 %column
        if (amp(i,j) > amp(i,j-1)) && (amp(i,j) > amp(i,j+1))
            tmp(i,j) = amp(i,j);
        end
    end
end
tmp(:,all(tmp==-100,1)) = [];
tmp(all(tmp==-100,2),:) = [];
value = max(max(tmp));
[row, col] = find(value==tmp);
tmp(:,col) = [];
side_peak = max(max(tmp(tmp<0)));
SLL = side_peak;
end