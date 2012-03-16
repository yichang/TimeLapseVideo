function detail_extraction( source_name )


load(['source/' source_name '.mat']);
source = double(clip)/255 ; 

film_length = size(source,4);

% histogram matching 
for i = 1 : size(source,1);
    for j = 1 : size(source,2);
       for k = 1 : 3             
            f0 = source(i,j,k,1:film_length); 
            
            %TODO: bilateral filter
            %TODO: detail model in 3D space ( ie. grad phi or phi - conv3(phi)
            n = 5 ; 
            f0_detail = f0(:) - conv( f0(:) , ones(1,n)/n , 'same');                        
            
            motion_detail(i,j,k,:) = reshape(f0_detail,1,1,1,film_length) ; 
            
       end
    end
end

save( ['detail\' source_name '.mat'] , 'motion_detail' );

display = 0;
if display 

    motion_detail(motion_detail>1) = 1 ; 
    motion_detail(motion_detail<0) = 0 ; 
 
    for i = 1 : film_length
        f = im2frame( [source(:,:,:,i)  motion_detail(:,:,:,i)] );
        M(i) = f;
    end

    movie(M);

end
