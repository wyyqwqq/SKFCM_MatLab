function [ mask_img ] = skfcm( x, cluster_number, filename )
%novel kernelized fuzzy c-means algorithm
% x is data points

%% --initialization--
cluster_num = cluster_number;
m = 2; %weighting exponent
e = 10^(-14); %looping threshold
iterationTime = 30;

[row, col] = size(x);
%init center matrix v
v = zeros(cluster_num, 1);
for loop_v = 1:cluster_num
    rand_v = rand(1)*255;
    v(loop_v,:) = rand_v; %center of cluster
end

%init membership
u = zeros(row, col, cluster_num); %U_ik, i cluster, k data points
for loop_row = 1:row
    for loop_col = 1:col
        idx_rand = randi(cluster_num,1,1);
        for loop_cluster = 1:cluster_num
            if idx_rand == loop_cluster
                u(loop_row, loop_col, loop_cluster) = 1;
            else
                u(loop_row, loop_col, loop_cluster) = 0;
            end
        end
    end
end

tmp_u = zeros(row, col, cluster_num); % to store previous loop result of u
iter_time = 0;

%% --looping--
while iter_time < iterationTime
    fprintf('loop No.%d...', iter_time);
    iter_time = iter_time+1;
    for loop_row = 2:row-1
        for loop_col = 2:col-1

            for cluster = 1:cluster_num
                %update centers
                v(cluster,:) = update_v(u(:, :,cluster), x, v(cluster,:),m);

                %update memberships 
                neighbor = u(loop_row-1:loop_row+1, loop_col-1:loop_col+1, :); %neighborhood of 3x3 window
                u(loop_row, loop_col, cluster) = update_m(x(loop_row, loop_col),neighbor, v, m, cluster, cluster_num);

            end
        end

    end
    
    %compute E
    tmp_dist_u = abs(u - tmp_u);
    tmp_u = u;
    tmp_dist_u = tmp_dist_u(:);
    max_u = max(tmp_dist_u);
    fprintf('max_u = %.15f\n', max_u(1,1));
    if max_u <= e
        break;
    end
end
% disp(u);

%% --re-construct image--
mask_img = zeros(row, col);

%exclusive re-construct method
for loop_row = 2:row-1
    for loop_col = 2:col-1
        class = 0;
        classValue = 0;
        for cluster = 1:cluster_num
           if u(loop_row, loop_col, cluster) > classValue
               classValue = u(loop_row, loop_col, cluster); %largest membership
               class = cluster; % # of cluster
           end
        end
        mask_img(loop_row, loop_col) = v(class,:);
    end
end


figure
mask_img = uint8(mask_img);
filePath = strcat('./output/', filename);
imwrite(mask_img, filePath);

end

