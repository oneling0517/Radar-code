function [SLL] = sidelobe_peak(amp)
if size(amp,1)==360
   tmp = -ones(length(amp),1)*100; %儲存峰值
   
   for i = 2:length(amp)-1 %col
       if (amp(i,1) > amp(i-1,1)) && (amp(i,1) > amp(i+1,1))
          tmp(i,1) = amp(i,1);
       end
   end
   tmp(1,1) = amp(1,1); %避免初值消失
   value = max(max(tmp));
   [row, col] = find(value==tmp);
   tmp(row) = [];
   SLL = max(max(tmp(tmp<0)));
end

if size(amp,1)==1
   tmp = -ones(1,length(amp))*100; %儲存峰值
   for i = 2:length(amp)-1 %row
       if (amp(1,i) >= amp(1,i-1)) && (amp(1,i) >= amp(1,i+1))
          tmp(1,i) = amp(1,i);
       end
   end
   tmp(1,1) = amp(1,1); %避免初值消失
   value = max(max(tmp));
   [row, col] = find(value==tmp);
   tmp(col) = [];
   SLL = max(max(tmp(tmp<0)));
end
end