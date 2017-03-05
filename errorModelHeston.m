function y=errorModelHeston(data,x)

    s0=data(1,1);
    r=data(1,4);
    T=unique(data(:,2));
    K=unique(data(:,3));
    C=hestonPricer(s0,x(1),x(2),x(5),x(3),x(4),r,T,K);

    for i=1:length(data)
       
        t1=find(T==data(i,2));
        k1=find(K==data(i,3));
        data(i,8)=C(k1,t1);
        
    end
    mid=data(:,5);
    strike=data(:,3);
    timeToMaturity=data(:,2);

    modelPrice=data(:,8);
    
    RMSE=sqrt(mean((modelPrice-mid).^2));
    MAE=mean(abs(modelPrice-mid));
    APE=MAE/mean(mid);
    y=[RMSE MAE APE length(modelPrice)];
end