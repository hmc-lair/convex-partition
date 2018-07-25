function plot_tour(solution,points, title_text)
%PLOT_TOUR 

fig = figure; 
hold on;
for i=2:size(solution,2)
    plot([points(solution(i),1), points(solution(i-1),1)], ...
         [points(solution(i),2), points(solution(i-1),2)],'bo-');
    hold on;
end
plot([points(solution(1),1), points(solution(end),1)], ...
         [points(solution(1),2), points(solution(end),2)],'bo-');
title(title_text);
hold off;

end

