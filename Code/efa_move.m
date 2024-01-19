%% Move all fireflies toward brighter ones
function [ns_new] = efa_move(n,ns,Lightn,ns0,Light0,alpha,betamin,gamma, group_best_pos_tmp, group_best_light_tmp, all_best_pos, all_best_light)
% Scaling of the system
% scale = 0.5;
% Updating fireflies
d = size(ns,2);
ns_tmp = ns; %要保留原值
ns_all = zeros(n,length(ns));
ns_group = zeros(n,length(ns));
%% all 
for i = 1:n 
        r_all = sqrt(sum((ns_tmp(i,:)-all_best_pos(1,:)).^2));
        if all_best_light > Light0(i) % Brighter and more attractive
            beta0 = 1; 
            beta = beta0*exp(-gamma*r_all.^2);
            ns_all(i,:) = (ns_tmp(i,:)-all_best_pos(1,:)).*beta ;
        end
end 

%% group
for i = 1:n % The attractiveness parameter beta=exp(-gamma*r)
        r_group = sqrt(sum((ns_tmp(i,:)-group_best_pos_tmp(1,:)).^2));
        if group_best_light_tmp > Light0(i) % Brighter and more attractive
            beta0 = 1; 
            beta = beta0*exp(-gamma*r_group.^2);
            ns_group(i,:) = (ns_tmp(i,:)-group_best_pos_tmp(1,:)).*beta ;
        end
end 
for i = 1:n % The attractiveness parameter beta=exp(-gamma*r)
    for j = 1:n
        r = sqrt(sum((ns_tmp(i,:)-ns_tmp(j,:)).^2));
        if Lightn(i) > Light0(j) % Brighter and more attractive
            beta0 = 1; 
            beta = (beta0-betamin)*exp(-gamma*r.^2)+betamin;
            tmpf = alpha.*(rand(1,d)-0.5);
            ns(i,:) = ns_tmp(i,:).*(1-beta)+ns0(j,:).*beta+tmpf;
        end
    end 
end 
for m = 1:n
    ns_new(m,:) = ns(m,:) + ns_all(m,:) + ns_group(m,:);
end
% Check if the updated solutions/locations are within limits

end