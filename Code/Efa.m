clc;close all;clear all;
% parameters [n N_iteration alpha betamin gamma]
n = 25; 
MaxGeneration = 6; %跑一次20秒
alpha = 0.5; 
betamin = 0.2; 
gamma = 1;
para = [n MaxGeneration alpha betamin gamma];
numTX = 16; %6
numRX = 16; %12
%% Create a set of random solutions to the problem
[ns, array_design] = initial_location(n, numTX, numRX);
%% 設定群心
seed_num = 3;
kx = zeros(seed_num,numTX+numRX);
ky = zeros(seed_num,numTX+numRX);
x = zeros(n,numTX+numRX);
y = zeros(n,numTX+numRX);
for p = 1:seed_num
    kx(p,:) = numRX/2*rand(1,numTX+numRX); %location
    ky(p,:) = numTX/2*rand(1,numTX+numRX); %location
end
for m = 1:n
    x(m,:) = [ns(m,1:numTX), ns(m,2*numTX+1:2*numTX+numRX)];
    y(m,:) = [ns(m,numTX+1:2*numTX), ns(m,2*numTX+numRX+1:end)];
end
%% K-means clustering
[team newkx newky]= k_means(x, y, kx, ky, seed_num);

%% Calculate the fitness function
F = cost(n, array_design);

%% Group
team_index = cell(1,seed_num);
for i = 1:seed_num
    [t_index,v] = find(team==i);
    team_index{1,i} = t_index;
end
team_F = cell(1,seed_num);
team_ns = cell(1,seed_num);
for i = 1:seed_num
    tmp_idx = team_index{1,i};
    tmp_matrix = zeros(1,length(tmp_idx));
    tmp_ns = zeros(length(tmp_idx),length(ns));
    for k = 1:length(tmp_idx)
        tmp_matrix(1,k) = F(tmp_idx(k));
        team_F{1,i} = tmp_matrix;
        tmp_ns(k,:) = ns(tmp_idx(k),:);
        team_ns{1,i}  = tmp_ns;
    end
end

%% Ranking fireflies by their light intensity/objectives
team_Light = cell(1,seed_num);
Index = cell(1,seed_num);
for i = 1:seed_num
    [L,I] = sort(team_F{1,i}); % 越小越亮
    team_Light{1,i} = L;
    Index{1,i} = I;
end

for i = 1:seed_num
    nn = zeros(length(Index{1,i}),length(ns));
    for j = 1:length(Index{1,i})
        ns_tmp = team_ns{1,i};
        ind = Index{1,i};
        nn(j,:) = ns_tmp(ind(j),:);
    end
    team_ns{1,i} = nn;
end

%% Start iteration
nbest_pos = zeros(seed_num,length(ns));
nLightbest = zeros(seed_num,1);
nlight_record = zeros(seed_num,301);

group_best_pos = zeros(seed_num,length(ns)); %群內最佳位置
all_best_pos = zeros(1,length(ns)); %全體最佳位置
group_best_light = zeros(seed_num,1); %群內最佳亮度
all_best_light = zeros(1,1); %全體最佳亮度
%% 存每次迭代值
ns_iter = cell(1,seed_num);
Lightn_iter = cell(1,seed_num); %排序亮度
F_self_iter = cell(1,seed_num); %未排序亮度
num = cell(1,seed_num); %各群螢火蟲數量
light_record = zeros(1,301); %紀錄每次迭代亮度，看分幾組
for m = 1:seed_num
    num{1,m} = length(Index{1,m}); %一組裡有多少個螢火蟲
end
    %% 找出群內與全體最佳解
    for m = 1:seed_num
        pos_iter_tmp = team_ns{1,m,1};
        group_best_pos(m,:) = pos_iter_tmp(1,:);
        light_iter_tmp = team_Light{1,m};
        group_best_light(m,1) = light_iter_tmp(1,1);
    end
    [All_light, All_index] = min(group_best_light);
    all_best_pos = group_best_pos(All_index,:);
    all_best_light = All_light;
    %---------------------------------------------------------------------%
for k=1:MaxGeneration % 迭代500次
    alpha = alpha_new(alpha,MaxGeneration); % 根據迭代改變alpha值
    
    for t = 1:seed_num
        if k==1
             ns = team_ns{1,t};
             Lightn = team_Light{1,t}; %排序
             F_self = team_F{1,t};
        else
            ns = ns_iter{1,t};
            Lightn = Lightn_iter{1,t}; %排序
            F_self = F_self_iter{1,t};
        end
        light_record(1,1) = Lightn(1); %紀錄第一次亮度
        %% Find the current best
        ns0 = ns; %已排序位置
        Light0 = Lightn;
        nbest = ns(1,:); % 最好的位置
        Lightbest = Lightn(1);
        % For output only
        fbest=Lightbest;
        group_best_pos_tmp = group_best_pos(t,:);
        group_best_light_tmp = group_best_light(t,1);
        n = num{1,t};
        [ns_new] = efa_move(n,ns,Lightn,ns0,Light0,alpha,betamin,gamma, group_best_pos_tmp, group_best_light_tmp, all_best_pos, all_best_light);
        %% Calculate virtual array to calculate the fitness function
        [ns_new, virtual_array_iter] = cal_location(n, ns_new, numTX, numRX);
        %% Calculate the fitness function
        [F_self] = cost(n, virtual_array_iter);

        %% Ranking fireflies by their light intensity/objectives
        [Lightn2,Index2] = sort(F_self); % 越小越亮
        ns_tmp = ns_new;
        for i = 1:n
            ns_new(i,:) = ns_tmp(Index2(i),:);
        end
        light_record(1,k+1) = Lightn2(1);
        ns_iter{1,t} = ns_new; %排序後位置
        Lightn_iter{1,t} = Lightn2; %排序亮度
        F_self_iter{1,t} = F_self; %未排序亮度
        nlight_record(t,:) = light_record;
    end
     %% Renew best solution
    for m = 1:seed_num
        pos_iter_tmp = ns_iter{1,m,1};
        group_best_pos(m,:) = pos_iter_tmp(1,:);
        light_iter_tmp =  Lightn_iter{1,m};
        group_best_light(m,1) = light_iter_tmp(1,1);
    end
    [All_light, All_index] = min(group_best_light);
    all_best_pos = group_best_pos(All_index,:);
    all_best_light = All_light;
end
%% Best solution
for m =1:seed_num
    nbest_pos_tmp = ns_iter{1,m};
    nbest_pos(m,:) = nbest_pos_tmp(1,:);
    nLightbest_tmp = Lightn_iter{1,m};
    nLightbest(m) = nLightbest_tmp(1);
end
save('nbest_pos.mat','nbest_pos'); %去beam pattern計算跟畫圖
save('nlight_record.mat','nlight_record'); %sidelobe level的值
save('nLightbest.mat','nLightbest'); %最佳的sidelobe level值