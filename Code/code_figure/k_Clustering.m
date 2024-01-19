function team = k_Clustering(x, y, kx, ky)
% This is for K-Clustering
% (x,y) are dataset and (kx, ky) are Cluster-center

mid_dis = 9999999999; %距離的暫存器
for i = 1 : size(x,1) %總共要判斷 length(x) 個資料
    for j = 1 : size(kx,1) %總共有 length(kx) 個群集中心
        distance = k_distFunc( [x(i,:) y(i,:)], [kx(j,:) ky(j,:)]); %計算第i個資料和第j個群集中心的距離
        if distance < mid_dis %判斷距離哪個群集中心較近
            mid_dis = distance; %更新距離的暫存器
            FLAG = j; %紀錄現在距離哪個群集中心最近
        end
    end
    mid_dis = 9999999999; %距離的暫存器變回初始值
    team(i,1) = FLAG; %第 i 個資料屬於第 FLAG 個群集
end
end