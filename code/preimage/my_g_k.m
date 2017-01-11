function [simil] = my_g_k(x,y,n,sigma)
%
n=1;
const = -1/(n*2*sigma^2);
simil = exp((norm(x-y)^2)*const);
end

% function k=kernel(x,y,i,var)
% if i==1 k=exp((-norm(x-y)^2)/(2*var^2)); 
% end
% if i==2 k=(sum(x.*y)+1)^var;
% end