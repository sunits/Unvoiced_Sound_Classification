
function [gmmObj] =build_gmm_from_htk_model(htk_model_path)

[P,M,V]=leeHMM(htk_model_path);
gmmObj= createDistribution(P,M,V);
