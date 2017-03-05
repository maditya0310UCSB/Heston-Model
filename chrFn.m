function chFn=chrFn(s0,v0,vbar,a,vvol,rho,r,w,T)


beta=a-rho*vvol*1i*w;
alpha=-(w.^2+1i*w)/2;
gamma=vvol^2/2;
h=sqrt(beta.^2-4.*alpha.*gamma);

r1=(beta+h)/vvol^2;
r0=(beta-h)/vvol^2;

g=r0./r1;
m=exp(-h.*T);
D=r0.*(1-m)./(1-g.*m);
C=a*(r0.*T - 2*log((1-g.*m)./(1-g))/vvol^2);
Q=w.*log(s0*exp(r.*T));
chFn=exp(C*vbar + D*v0 + 1i*Q);

