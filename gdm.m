function [f] = gdm(F1, F2, Func)
%
% GDM   Ground distance matrix between two signatures
%    [F] = GDM(F1, F2, FUNC) is the ground distance matrix between
%    two signatures whose feature vectors are given in F1 and F2.
%    FUNC is a function which computes the ground distance between
%    two feature vectors.
%
%    Example:
%    -------
%        f1 = [22; 2; 190; 100];
%        f2 = [0; 80; 255];
%        ...
%        [f] = gdm(f1, f2, @gmf);
%        ...
%
%   Program submitted by:
%           V Priyan        1100136
%           Aravind Sagar   1100104

% number and length of feature vectors
[m a] = size(F1);
[n a] = size(F2);

% ground distance matrix
for i = 1:m
    for j = 1:n
        f(i, j) = Func(F1(i, 1:a), F2(j, 1:a));
    end
end

% gdm in column-vector form
f = f';
f = f(:);

end