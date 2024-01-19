%% 調整步長
function alpha = alpha_new(alpha,MaxGeneration)
% alpha_n=alpha_0(1-delta)^NGen=10^(-4);
% alpha_0=0.9
delta = 1-(10^(-4)/0.9)^(1/MaxGeneration);
alpha = (1-delta)*alpha;
end