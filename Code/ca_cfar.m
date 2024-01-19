function [RDM_mask, cfar_ranges, cfar_dopps] = ca_cfar(RDM, numGuard, numTrain, P_fa, SNR_OFFSET)
        % e.g. numGuard =2, numTrain =2*numGuard, P_fa =1e-5, SNR_OFFSET = -15
numTrain2D = (2*numTrain+2*numGuard+1)^2 - (2*numGuard+1)^2; %train cell數量
RDM_mask = zeros(size(RDM));

for r = numTrain + numGuard + 1 : size(RDM_mask,1) - (numTrain + numGuard)
    for d = numTrain + numGuard + 1 : size(RDM_mask,2) - (numTrain + numGuard)
        Pn = (sum(sum(RDM(r-(numTrain+numGuard):r+(numTrain+numGuard),d-(numTrain+numGuard):d+(numTrain+numGuard)))) - ...
            sum(sum(RDM(r-numGuard:r+numGuard,d-numGuard:d+numGuard))) ) / numTrain2D; % noise level
        a = numTrain2D*(P_fa^(-1/numTrain2D)-1); % scaling factor of T = α*Pn
        Pn_db = db2pow(Pn);
        threshold_power = a*Pn_db;
        threshold = pow2db(threshold_power);
        if (RDM(r,d) > threshold) && (RDM(r,d) > SNR_OFFSET)
            RDM_mask(r,d) = 1;
        end
    end
end
[cfar_ranges, cfar_dopps]= find(RDM_mask); % cfar detected range bins

% range_boundry = sample/2 - 2*(numTrain+numGuard);
% doppler_boundry = numchirps - 2*(numTrain+numGuard);
% 
% for r = 1:range_boundry
%     for d = 1:doppler_boundry
%         total_power = db2pow(RDM(r:r+2*(numTrain+numGuard),d:d+2*(numTrain+numGuard)));
%         guard_power = db2pow(RDM(r+numTrain:r+numTrain+numGuard*2,d+numTrain:d+numTrain+numGuard*2));
%         Pn = sum(sum(total_power))-sum(sum(guard_power));
%         Pn_db = pow2db(Pn/numTrain2D);
%         a = numTrain2D*(P_fa^(-1/numTrain2D)-1); % scaling factor of T = α*Pn
%         threshold = a*Pn_db;
%         if (RDM(r+numTrain+numGuard,d+numTrain+numGuard) > threshold) && (RDM(r+numTrain+numGuard,d+numTrain+numGuard) > SNR_OFFSET)
%             RDM_mask(r+numTrain+numGuard,d+numTrain+numGuard) = 1;
%         end
%     end
% end