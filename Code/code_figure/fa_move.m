%% Move all fireflies toward brighter ones
function [ns] = fa_move(n,ns,Lightn,ns0,Light0,alpha,betamin,gamma)
% Scaling of the system
% scale = 0.5;
% Updating fireflies
d = size(ns,2);
for i = 1:n % The attractiveness parameter beta=exp(-gamma*r)
    for j = 1:n
        r = sqrt(sum((ns(i,:)-ns(j,:)).^2));
        if Lightn(i) > Light0(j) % Brighter and more attractive
            beta0 = 1; 
            beta = (beta0-betamin)*exp(-gamma*r.^2)+betamin;
            tmpf = alpha.*(rand(1,d)-0.5);
            ns(i,:) = ns(i,:).*(1-beta)+ns0(j,:).*beta+tmpf;
        end
    end 
end 
% Check if the updated solutions/locations are within limits

end