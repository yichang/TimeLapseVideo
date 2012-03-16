close all;
clc;
clear; 

source_name = 'Time_Lapse_Sunset_Over_the_Lake';
target_folder = 'Olympic_Mountains_Time_Lapse_refined';

load(['../../segment/output/' target_folder '.mat']);
mask = labelFile.labels('water');

% retacngle approximate
% out put define
%im_width = 1920;
im_width = 100;
im_height = 100;
im_time = 50;

% model define
model_time_limit = 40; 
model_size_limit = 40;
load(['detail/' source_name '.mat']);
model = motion_detail(1:model_size_limit,1:model_size_limit,:,1:model_time_limit) ; 

correlation_time = 15;
correlation_pxs = 15;
guard = 18 ; % must greater than min(correlation_time, correlation_pxs)


syn_detail = zeros( im_height + guard , im_width + guard , 3 ,im_time + guard );
done_table = zeros( im_height + guard , im_width + guard  , 3 , im_time + guard );

DONE = reshape( [1 1 1] , 1 , 1 ,3 , 1); 

for i =  1 : im_height
    i
    for j = 1 : im_width 
        for t = 1 : im_time
            target_coor = [i+(correlation_pxs-1)/2 j+(correlation_pxs-1)/2 t+(correlation_time-1)/2];
            valid = done_table( i : i + correlation_pxs - 1 , j : j + correlation_pxs - 1  , :  ,  t : t + correlation_time - 1);
            querry = syn_detail( i : i + correlation_pxs - 1 , j : j + correlation_pxs - 1  , : , t : t + correlation_time - 1);
            
            if( done_table(  target_coor(1) , target_coor(2) ,  : , target_coor(3)) == DONE)
                fprintf('Error: the target has been determined\n');
            end
            
            if (sum(valid(:))==0)
                syn_detail( target_coor(1) , target_coor(2) , :  , target_coor(3)) = model( randi(size(model,1)), randi(size(model,2)) , : , randi(size(model,4)));
                done_table(  target_coor(1) , target_coor(2) ,  : , target_coor(3)) = DONE ;
            else
                
                [mi mj mt] = bestMatch( valid , querry , model ) ; 
                syn_detail( target_coor(1) , target_coor(2) , :  , target_coor(3)) = model( mi , mj , : , mt);
                done_table(  target_coor(1) , target_coor(2) , :, target_coor(3)) = DONE ;
            end
            
        end
    end
end

save( [source_name '_synthesized_motion_detail.mat'] , 'syn_detail');

syn_detail(syn_detail<0) = 0 ;  
for t = 1 : size(syn_detail,4)
    M(t) = im2frame( syn_detail(:,:,:,t));
end
movie(M,10);
