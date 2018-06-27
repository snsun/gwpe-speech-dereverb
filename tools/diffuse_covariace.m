function [ Gamma ] = diffuse_covariace(config )
%SUPERDIRECTIVE 
%   K: number of freq bins
%   M: number of channels
%   d: sensor spaces refer to the first mic. 
%      d should be a 1*M vector, e.g. [0, 0.04, 0.08, 0.12]
%   fs: sample rate

%define the diffusion noise covariance matrix
M = config.sensor_number;
K = config.fft_len/2+1;
fs = config.fs;
c = config.c;
d = config.sensor_spacing;

Gamma = ones([M, M, K]);
omega = ([0:K-1]/K)*(fs/2)*2*pi;


for k = 1:K
    for i=1:M
        for j=1:M
            if j ~= i
                tau = (d(i) - d(j))/c;
                Gamma(i, j, k) = sinc(omega(k)*tau);
            end
        end
    end
end

end

