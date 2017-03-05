clc;
clear;


clear; clc
format compact, format shortg
load AnupData2005
    %DATA FORMAT: [Put(-1) Call (1); Strike Price; Calendar Days to Maturity; Bid Price; Ask Price; Business Days to Maturity]
    
load RiskFree

count=1;
%x1 = [0.04922,0.044918,0.30125,-0.999,0.141];
%x1=[0.0131231682712947,0.0249542502822444,0.0596809685772420,-0.999999999916172,0.0222972736612278];
%x1=[0.5 0.5 0.1 -0.5 5];
x1=[0.0131067664562588,0.769860642042993,0.0552491312205277,-0.999999997972321,0.00748119653211469];

tic
for num=1%:5:length(SPX)
%for num=980:981
    
    riskFreeRate=RF(num);
    tempData=Data(:,:,num);

    PositiveMaturity=find(all(tempData(:,3)>0,2)); %finds all row numbers with maturity dates >0
    tempData=tempData(PositiveMaturity,:);
    
    spot=SPX(num);
    
    tempData=tempData(tempData(:,2)>0.8*spot & tempData(:,2)<1.2*spot,:);
    tempData=tempData(tempData(:,3)>20,:);
    tempData=tempData(tempData(:,3)<400,:);
    callData=tempData(tempData(:,1)==1,:);
    
    
    
    %create data into following form
    %[spot maturity strike interestRate mid bid ask]
    [z z1]=size(callData);
    callData=[repmat(spot,z,1) callData(:,3)./365 callData(:,2) repmat(riskFreeRate,z,1) (callData(:,4)+callData(:,5))/2 callData(:,4) callData(:,5)];
    
%     %convert put options to corresponding call using PutCall Parity
%     PutData=tempData(tempData(:,1)==-1,:);    
%     [z z1]=size(PutData);
%     PutData=[repmat(spot,z,1) PutData(:,3)./365 PutData(:,2) repmat(riskFreeRate,z,1) (PutData(:,4)+PutData(:,5))/2 PutData(:,4) PutData(:,5)];
%     S=repmat(spot,z,1);
%     callPriceForPut=PutData(:,5)+S-PutData(:,3).*exp(-riskFreeRate*PutData(:,2));
%     PutDataUpdated=PutData;
%     PutDataUpdated(:,5:7)=[callPriceForPut callPriceForPut callPriceForPut];
%     
%    optionData=[callData;PutDataUpdated]; 
     optionData=callData; 
     
     
     T=unique(optionData(:,2));
     K=unique(optionData(:,3));
     zT=length(T);
     zK=length(K);
     mktPrice=zeros(zK,zT);
    
     for p=1:length(T)
         [I I1]=find(optionData(:,2)==T(p));
         temp=optionData(I,:);
         [i1 i2]=ismember(temp(:,3),K);
         mktPrice(i2,p)=temp(:,5);
     end
     x0=x1;
     lb = [0, 0, 0, -1, 0];
     ub = [1, 1, 5, 1, 20];
     zeroIndex=find(~mktPrice);
     options=optimset('TolFun', 1e-12);
     %'Display','iter',
     x1 = lsqnonlin(@(x)costfn(x,spot,riskFreeRate,mktPrice,zeroIndex,T,K,zT,zK),x0,lb,ub,options);
     
     Heston_sol(count,:) = [x1(1), x1(2), x1(3), x1(4), (x1(5)+x1(3)^2)/(2*x1(2))];
     errorEst(count,:)=errorModelHeston(optionData,Heston_sol(count,:));
     
%      modelPrices=compare(optionData,Heston_sol);
     count=count+1;

end    


     toc
