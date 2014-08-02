function [ x, fval ] = simplexcode( c,A,b )
%SIMPLEX The function finds the Optimal solution of Std. Simplex Problem.
%   This function finds the optimal solution of Std. Simplex problem. To
%   find optimal solution for Non-Std. Simplex problem please refer to
%   simplexcon function for more details.
%   The problem is of the form:
%           minimize c'*x
%           subject to. A*x = b,
%                       x >= 0
%
%   Program submitted by:
%           V Priyan        1100136
%           Aravind Sagar   1100104

r = size(A,1);
n = size(A,2);
if(n ~= size(c,1))
    error('Matrix sizes mismatch');
end

%Bi=[];
%for i=1:size(Bii,2)
%    Bi=union(Bi,[Bii(i)]);
%end
Bi = simplexstart(A,b);

for i=1:r
    if Bi(i)>n
        error('Contains Temp Variable');
        pause
    end
end

Ni=[];
for i=1:n
    if(isempty(intersect(Bi,i)))
        Ni=union(Ni,i);
    end
end
%pause
%for i=1:r
%    Bi=union(Bi,[i]);
%end

iter=1;
while(1)
    
    B=[];
    N=[];
    cn=[];
    cb=[];
    for i=1:n
        if(isempty(intersect(Bi,i)))
            N = [N,A(:,i)];
            cn = [cn;c(i)];
        else
            B = [B,A(:,i)];
            cb = [cb;c(i)];
        end
    end
    if(rcond(B)<0.00000000000001)
        A
        B
        Bi
        pause
    end
    lambda = (B')\ cb;
    myun = cn - N' * lambda;
    iter=0;
    for i=1:size(myun)
        if(myun(i)<0)
            iter=1;
            q=Ni(i);
            break;
        end
    end
    xb = B\ b;
    
    x = zeros(n,1);
    for i=1:size(xb)
        x(Bi(i))=xb(i);
    end
    fval = c'*x;
    if(iter==0)
        break;
    end
    Aq = A(:,q);
    d = B\ Aq;
    flag = 1;
    for i=1:size(d)
        if(d(i)>0)
            flag=0;
        end
    end
    if(flag)
        error('Unbounded');
    end
    for i=1:size(d)
        if(d(i)>0)
            xqp = xb(i)/d(i);
            mini = i;
            break;
        end
    end
    for i=1:size(d)
        if(d(i)>0 && xqp>xb(i)/d(i))
            xqp = xb(i)/d(i);
            mini=i;
        end
    end
    p = Bi(mini);
    Ni = setdiff(Ni,[q]);
    Bi = setdiff(Bi,[p]);
    Ni = union(Ni,[p]);
    Bi = union(Bi,[q]);
end
end

