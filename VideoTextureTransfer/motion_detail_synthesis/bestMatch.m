function [mi mj mt] = bestMatch( valid , querry , model  ) 
%BESTMATCH Summary of this function goes here
%   Detailed explanation goes here

%min_score = Inf;
%best_ijt = [1 1 1]; 


i_width =  size(querry,1) ; 
j_width =  size(querry,2) ; 
t_width =  size(querry,4) ; 

score = zeros(size(model,1) - i_width + 1, size(model,2) - j_width + 1 , size(model,4) - t_width + 1) + Inf;

[js is ts] = meshgrid(1 : size(model,1) - i_width + 1,1 : size(model,2) - j_width + 1 ,1 : size(model,4) - t_width + 1); %XYZ

parfor n = 1 : length(is(:)) 

    i = is(n);
    j = js(n);
    t = ts(n);
	candidate = model( i : i + i_width - 1  , j: j + j_width - 1  , : , t : t + t_width - 1 ) ;
            
   	%candidate_ijt = [i+(i_width-1)/2 j+(j_width-1)/2 t+(t_width-1)/2 ];
	
 	score(n) = norm (  valid(:).*( querry(:) - candidate(:)) );
    
    %if (score(n) ~= score(i,j,t))
    %    fprintf('Error: alignement error\n');
    %end
  	
    %if score < min_score 
  	%    min_score = score;
 	%    best_ijt = candidate_ijt;
	%end

end

nMin = find(score == min(score(:)));
mi = is(nMin) +(i_width-1)/2;
mj = js(nMin) +(j_width-1)/2;
mt = ts(nMin) +(t_width-1)/2;

%mi = best_ijt(1);
%mj = best_ijt(2);
%mt = best_ijt(3);

           

end

