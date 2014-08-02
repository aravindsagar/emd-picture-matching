function [ Bi ] = simplexstart( A,b )
%SIMPLEXSTART This function uses the two phase simplex method to provide
%the starting indices for the given simplex problem.
%   This function uses the two phase simplex method to provide the starting
%   indices for the given simplex problem.
%
%   Program submitted by:
%           V Priyan        1100136
%           Aravind Sagar   1100104

r = size(A,1);
n = size(A,2);

%Modifying the obj. function for including the temporary variables.
c=zeros(n,1);
for i=1:r
    c=[c;1];
end

%Modifying the constraints.
E=zeros(r,r);
for i=1:r
    E(i,i) = abs(b(i))/b(i);
end
A = [A E];
Bi = n+1:n+r;
Ni = 1:n;
nold=n;
n=n+r;

%Iterating over the simplex problem to find the optimal solution.
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
    lambda = (B')\ cb;
    myun = cn - N' * lambda;
    
    %Checking for the KKT condition
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
    iter1=true;
    if(iter==0)
        %If iter equals zero we have reached the solution but index set Bi
        %might have temporary variables. Checking for temp variables in Bi.
        for i=nold+1:n
            if(~isempty(intersect(Bi,i)))
                p=i;
                iter1=false;
                break;
            end
        end
        %If iter1 is false , then there are temp variables in Bi.
        if(iter1)
            break;
        end
    end
    if(iter~=0)
        %Optimal solution is not reached. We continue the iteration.
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
    else
        %Reached the optimal solution but with temp variables in Bi.
        %Swapping those temp variables with the original variables and
        %checking for the non-singularity of B.
        tried = zeros(nold,1);
        for i=1:nold
            if(tried(i)==0 && ~isempty(intersect(Ni,i)))
                q=i;
                tried(i)=1;
                Nit = setdiff(Ni,[q]);
                Bit = setdiff(Bi,[p]);
                Nit = union(Nit,[p]);
                Bit = union(Bit,[q]);
                B=[];
                N=[];
                cn=[];
                cb=[];
                for i=1:n
                    if(isempty(intersect(Bit,i)))
                        N = [N,A(:,i)];
                        cn = [cn;c(i)];
                    else
                        B = [B,A(:,i)];
                        cb = [cb;c(i)];
                    end
                end
                if(rcond(B)> 0.0000000000001)
                    %Checking for non-singularity of B.
                    break;
                end
            end
        end
        if(rcond(B)<0.00000000001)
            %If B is singular, then the given problem violates the basic
            %property of Simplex method and can't be continued
            error('Violates the property f Simplex. A is Linearly Dependent.');
        end
        Ni=Nit;
        Bi=Bit;
    end
    
end
end

