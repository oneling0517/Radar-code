%% Make sure the fireflies are within the bounds/limits 避免超出網格
function [ns]=findlimits(n,ns,numTX,numRX)  
for i=1:n
    ns_tmp = ns(i,:);
    for j = 1:2*numTX + 2*numRX
        if j>=1 && j<=numTX % array TX x-axis
            if ns_tmp(j) > 0.5 % lower bound
                ns_tmp(j) = 0.5;
            elseif ns_tmp(j) < 0 % upper bound
                ns_tmp(j) = 0;
            end
        elseif j>=numTX + 1 && j<=2*numTX % array TX y-axis
            if ns_tmp(j) < (j-numTX-1)*0.5
                ns_tmp(j) = (j-numTX-1)*0.5;
            elseif ns_tmp(j) > (j-numTX)*0.5
                ns_tmp(j) = (j-numTX)*0.5;
            end
        elseif j>=2*numTX + 1 && j<=2*numTX + 1 + numRX % array RX x-axis
            if ns_tmp(j) < (j-2*numTX-1)*0.5
                ns_tmp(j) = (j-2*numTX-1)*0.5;
            elseif ns_tmp(j) > (j-2*numTX)*0.5
                ns_tmp(j) = (j-2*numTX)*0.5;
            end
        else
            if ns_tmp(j) < 0
                ns_tmp(j) = 0;
            elseif ns_tmp(j) > 0.5
                ns_tmp(j) = 0.5;
            end
        end
    end
    % Update this new move
    ns(i,:)=ns_tmp;
end
end