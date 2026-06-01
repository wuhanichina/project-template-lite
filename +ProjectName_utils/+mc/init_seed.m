function rngState = init_seed(seed)
%INIT_SEED Initialize the random seed for reproducible MC-style experiments.

if nargin < 1 || isempty(seed)
    seed = 1;
end

rng(seed, "twister");
rngState = rng;
end
