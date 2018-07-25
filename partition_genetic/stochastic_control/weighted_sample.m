function [ rand_int ] = weighted_sample( numbers, weights)
% choose a random numbe based on weights

    r = rand;
    total = 0;
    for i=1:length(numbers)
        total = total + weights(i);
        if r < total
            rand_int = numbers(i);
            break;
        end
    end
end

