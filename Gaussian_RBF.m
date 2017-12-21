function [ k ] = Gaussian_RBF( v, x )
% v is a center of cluster
% x is a data point

squared_dist = (double(v) - double(x))^2;
k = exp(-squared_dist/200^2);

end

