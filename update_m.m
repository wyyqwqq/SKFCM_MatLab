function [ U_ik ] = update_m( x_k, neighbor, v, m, i, cluster_number )
% x_k is the center point of 3*3 window
% neighbor is data points membership in dataset in 3*3 window, row*col*cluster matrix
% v is center of No.i cluster
% m is weighting exponent = 2
% i is index of cluster
% U_ik is probability of each data point assigned to each cluster

alfa = 0.7;
sum_tmp = 0;
N_r = 8;

for loop=1:1
    k_tmp = Gaussian_RBF(v(i,:), x_k);
    neighbor_sum = 0;
    for row_neighbor = 1:3
        for col_neighbor = 1:3
            if row_neighbor == 2 && col_neighbor == 2
                continue;
            end
            neighbor_sum = neighbor_sum + (1-neighbor(row_neighbor,col_neighbor,i))^m/N_r;
        end
    end
    numerator = (1-k_tmp + alfa*neighbor_sum)^(-1/(m-1));
    cluster_sum = 0;
    neighbor_sum2 = 0;
    for idx_cluster = 1:cluster_number
        for row_neighbor = 1:3
            for col_neighbor = 1:3
                if row_neighbor == 2 && col_neighbor == 2
                    continue;
                end
                neighbor_sum2 = neighbor_sum2 + ((1-neighbor(row_neighbor, col_neighbor,idx_cluster))^m)/N_r;
            end
        end
        k_tmp = Gaussian_RBF(v(idx_cluster,:), x_k);
        cluster_sum = cluster_sum + (1-k_tmp + alfa*neighbor_sum2)^(-1/(m-1));
    end
    denominator = cluster_sum;
    sum_tmp = numerator/denominator;

end

% U_ik = tmp/sum_tmp;
U_ik = sum_tmp;

end

