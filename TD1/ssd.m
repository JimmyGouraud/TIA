function [ res ] = ssd( P1, P2 )
   res = sum(sum(sum((P1 - P2).^2)));
end

