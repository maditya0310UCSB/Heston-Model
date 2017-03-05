function cost=costfn(x,s0,r,mktPrice,zeroIndex,T,K,zT,zK)
    
    C=hestonPricer(s0,x(1),x(2),(x(5)+x(3)^2)/(2*x(2)),x(3),x(4),r,T,K);
    C(zeroIndex)=0;
    cost=reshape(mktPrice-C,zT*zK,1);
    
end