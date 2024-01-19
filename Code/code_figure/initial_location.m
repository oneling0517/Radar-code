%% The initial locations of n fireflies
function [ns, array_design] = initial_location(n, numTX, numRX)
array_design = cell(1,n); %有n組solution
    for k=1:n
%         array_TX_x = 0.5*rand(1,numTX); %location
%         array_TX_y = [0:0.5:numTX/2-0.5] + 0.5*rand(1,numTX);
%         array_RX_x = [0:0.5:numRX/2-0.5] + 0.5*rand(1,numRX);
%         array_RX_y = 0.5*rand(1,numRX); %location
        array_TX_x = numRX/2*rand(1,numTX); %location
        array_TX_y = numTX/2*rand(1,numTX);
        array_RX_x = numRX/2*rand(1,numRX);
        array_RX_y = numTX/2*rand(1,numRX);
        ns(k,:) = [array_TX_x, array_TX_y,array_RX_x, array_RX_y];
        virtual_x = zeros(1,numTX*numRX);
        count = 0;
        for i = 1:numTX
            for j = 1:numRX
                count = count+1;
                virtual_x(1,count) = array_TX_x(i)+array_RX_x(j);
                virtual_y(1,count) = array_TX_y(i)+array_RX_y(j);
            end
        end
        virtual_array = [virtual_x;virtual_y];
        array_design{1,k} = virtual_array;
    end
end