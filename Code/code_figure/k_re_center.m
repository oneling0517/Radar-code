function [kx, ky] = k_re_center( x, y, team, seed_num)
% re-find clustered data for new cluster center
for i = 1 : seed_num
    kx(i,:) = sum(x(team == i,:)) / sum(team == i);
    ky(i,:) = sum(y(team == i,:)) / sum(team == i);
end
end