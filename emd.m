function [x, fval] = emd(F1, F2, W1, W2, Func)
%
% EMD   Earth Mover's Distance between two signatures
%    [X, FVAL] = EMD(F1, F2, W1, W2, FUNC) is the Earth Mover's Distance
%    between two signatures S1 = {F1, W1} and S2 = {F2, W2}. F1 and F2
%    consists of feature vectors which describe S1 and S2, respectively.
%    Weights of these features are stored in W1 and W2. FUNC is a function
%    which computes the ground distance between two feature vectors.
%
%    Example:
%    -------
%        f1 = [22 ; 20 ; 150 ; 100];
%        f2 = [0 ; 80 ; 255 ];
%        w1 = [0.4; 0.3; 0.2; 0.1];
%        w2 = [0.5; 0.3; 0.2];
%        ...
%        [x fval] = emd(f1, f2, w1, w2, @gdf);
%        ...
%    The outcome of EMD is the fval (X) which minimizes the cost function.
%
%   Program submitted by:
%           V Priyan        1100136
%           Aravind Sagar   1100104

f = gdm(F1, F2, Func);

% number of feature vectors
[m a] = size(F1);
[n a] = size(F2);

% inequality constraints
A1 = zeros(m, m * n);
A2 = zeros(n, m * n);
for i = 1:m
    for j = 1:n
        k = j + (i - 1) * n;
        A1(i, k) = 1;
        A2(j, k) = 1;
    end
end
A = [A1; A2];
b = [W1; W2];

% equality constraints
Aeq = ones(1, m * n);
beq = ones(1, 1) * min(sum(W1), sum(W2));

% lower bound
lb = zeros(1, m * n);

%Printing
if(0)
    A
    b
    Aeq
    beq
    f
    pause
end


% linear programming
opts.Simplex = 'on';
opts.LargeScale = 'off';
%[x, fval] = linprog(f, A, b, Aeq, beq, lb,[],[],opts);
[x, fval] = simplexcon(f, A, b, Aeq, beq,[], lb);
fval = fval / sum(x);

end