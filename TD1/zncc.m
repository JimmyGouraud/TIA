function [ res ] = zncc( P1, P2 )
   meanP1 = mean(mean(mean(P1)));
   meanP2 = mean(mean(mean(P2)));
   
   zcc = sum(sum(sum((P1 - meanP1) .* (P2 - meanP2))));
        
   res = zcc / (sqrt(sum(sum(sum((P1 - meanP1).^2)))) * sqrt(sum(sum(sum((P2 - meanP2).^2)))));
end

