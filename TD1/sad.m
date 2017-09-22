function [ res ] = sad( P1, P2 )
    res = sum(sum(sum(abs(P1 - P2))));
end

