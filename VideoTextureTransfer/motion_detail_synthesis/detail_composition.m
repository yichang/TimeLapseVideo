close all;
clc; 
clear; 


%target_folder = 'Clear_Lake_Time_Lapse';
%fList = dir(['../../matlab_code/timeLapseData/' target_folder '/*.png']);
target_img = 'lake_01' ; 
file_name = ls(['static_imgs/' target_img '.*']);
img = double(imread(['static_imgs\' file_name]))/255;

load('detail\Time_Lapse_Sunset_Over_the_Lake.mat');


if~exist( target_img)
    mkdir (target_img);
end
    

ini_frame = 500;
x_min = 580;
y_min = 600;

motion_height = size(motion_detail,1);
motion_width = size(motion_detail,2);

for t = 1 : size(motion_detail,4)
    %img = double(imread( ['../../matlab_code/timeLapseData/'  target_folder '/' fList(ini_frame + t ).name]))/255;
    %figure ; imshow(img);
    img( y_min : y_min + motion_height - 1 , x_min : x_min + motion_width  - 1 , : ) =  img( y_min : y_min + motion_height - 1 , x_min : x_min + motion_width  - 1 , : ) + motion_detail(:,:,:,t);
    %imwrite( img ,  [target_folder '/' fList(ini_frame + t ).name], 'png'); 
    imwrite( img ,  [target_img '/' target_img '_' num2str(t , '%06d') '.png'], 'png');
    
end
    