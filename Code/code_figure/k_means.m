function [team kx ky]= k_means(x, y, kx, ky, seed_num)
while 1
    team = k_Clustering( x, y, kx, ky);% 分群
    [newkx, newky] = k_re_center(x, y, team, seed_num); %更新新的群心
    if ( sum(sum(kx == newkx)) == seed_num*size(kx,2) ) && ( sum(sum(ky == newky)) == seed_num*size(kx,2)) %新的群心是否跟舊的一樣
        kx = newkx;
        ky = newky;
        break; %一樣的話就跳出
    else %不一樣就繼續
        kx = newkx;
        ky = newky;
    end
end
end