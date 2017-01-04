function k=kernel(x,y,i,var)
if i==1 k=exp((-norm(x-y)^2)/(2*var^2)); 
end
if i==2 k=(sum(x.*y)+1)^var;
end