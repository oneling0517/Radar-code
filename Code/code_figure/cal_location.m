function [ns, virtual_array_iter] = cal_location(n, ns, numTX, numRX)
virtual_array_iter = cell(1,n); %有n組solution
    for k = 1:n
        array_TX_x = ns(k,1:numTX);
        array_TX_y = ns(k,numTX+1:numTX*2);
        array_RX_x = ns(k,numTX*2+1:numTX*2+numRX);
        array_RX_y = ns(k,numTX*2+1+numRX:end);
        count = 0;
        for i = 1:numTX
            for j = 1:numRX
                count = count+1;
                virtual_x(1,count) = array_TX_x(i)+array_RX_x(j);
                virtual_y(1,count) = array_TX_y(i)+array_RX_y(j);
            end
        end
        virtual_array = [virtual_x;virtual_y];
        virtual_array_iter{1,k} = virtual_array;
    end
end