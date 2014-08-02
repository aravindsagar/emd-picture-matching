function [E] = gdf(V1, V2)
%
% GDF   Ground distance between two vectors
%    [E] = GDF(F1, F2) is the ground distance between two feature vectors.
%
%    Example:
%    -------
%        v1 = [100, 40, 22];
%        v2 = [50, 100, 80];
%        ...
%        [e] = gdf(v1, v2);
%        ...
%
%   Program submitted by:
%           V Priyan        1100136
%           Aravind Sagar   1100104

E = norm(V1 - V2, 2);

end