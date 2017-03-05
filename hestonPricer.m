function C=hestonPricer(s0,v0,vbar,a,vvol,rho,r,T,K)

    %this function takes in vector of strike, maturities and other model
    %parameters and outputs a matrix of option price corresponding to each of
    %the possibilities. The first dimension of the output matrix is strike and
    %second dimension is time to maturity 


    dw=0.01;
    w=0.01:dw:50;
    w=w';
    zw=length(w);

    %T=1;
    zT=length(T);

    w=repmat(w,1,zT);
    T=repmat(T',zw,1);


    %this is a 2d martix -> dimension 1 is increasing in w, dimension 2 is
    %increasing in T 

    chfn1=chrFn(s0,v0,vbar,a,vvol,rho,r,w-1i,T);
    chfn2=chrFn(s0,v0,vbar,a,vvol,rho,r,w,T);

    %K=0.7;
    zK=length(K);

    K1(1,1,:) = K;
    K1 = repmat(K1, [zw zT 1]);

    w1=repmat(w,1,1,zK);
    T1=repmat(T,1,1,zK);


    chfn1=repmat(chfn1,1,1,zK);
    chfn2=repmat(chfn2,1,1,zK);


    F=s0*exp(r.*T1);

    int1_1=real(exp(-1i*w1.*log(K1)).*(chfn1./(1i.*w1.*F)));
    pi1=sum(permute(int1_1,[3 2 1]),3)*dw/pi +0.5;

    int2_1=real(exp(-1i*w1.*log(K1)).*(chfn2./(1i.*w1)));
    pi2=sum(permute(int2_1,[3 2 1]),3)*dw/pi +0.5;

    K2=repmat(K,1,zT);
    T2=T(1:zK,:);

    C=max(s0*pi1-(pi2.*K2.*exp(-r.*T2)),0);


end