function [x,fval] = simplexcon( f,A,b,Aeq,beq,UB,LB )
%SIMPLEXCON Summary of this function goes here
%   Converts the given Simplex problem to Std. Simplex Problem by
%   introducing slack variables and converting inequality constraints to
%   equality constraints.
%   The problem is of the form:
%           minimize c'*x
%           subject to. A*x = b,
%                       Aeq*x <= beq,
%                       LB <= x
%                       x >= UB
%
%   Program submitted by:
%           V Priyan        1100136
%           Aravind Sagar   1100104

%Cheking for the no. of input arguments.
if(nargin < 7)
    LB = [];
    if(nargin < 6)
        UB = [];
        if(nargin < 5)
            beq=[];
            if(nargin < 4)
                Aeq=[];
                if(nargin < 3)
                    error('Not enough arguments');
                end
            end
        end
    end
end

%Saving the old values
fold = f;
Aold = A;
bold = b;
Aeqold = Aeq;
beqold = beq;
UBold = UB;
LBold = LB;


c = size(A,1);      %c is the no. of inequality constraints
a = size(Aeq,1);    %a is the no. of equality constraints
n = size(f,1);     %n is the no. of variables

%combining lower bound and inequality constraints
if(~isempty(LB))
    for i = 1:n
        if(LB(i) ~= 0)
            temp = zeros(1,n);
            temp(i) = -1;
            A = [A;temp];
            b = [b;-LB(i)];
        end
    end
end
%combining upper bound and inequality constraints
if(~isempty(UB))
    for i = 1:n
        if(UB(i) ~= 0)
            temp = zeros(1,n);
            temp(i) = 1;
            A = [A;temp];
            b = [b;UB(i)];
        end
    end
end
%Sizes of different matrices
c = size(A,1);      %c is the no. of inequality constraints
a = size(Aeq,1);    %a is the no. of equality constraints
n = size(f,1);     %n is the no. of variables

%Adding extra variables, rows and columns as required
f = [f;zeros(c,1)];
aug = [];
for i=1:c
    temp = zeros(1,c);
    temp(i) = 1;
    aug = [aug;temp];
end
A = [A aug];
Aeq = [Aeq zeros(a,c)];

Aeq = [Aeq;A];
beq = [beq;b];

[x,fval] = simplexcode(f,Aeq,beq);


end