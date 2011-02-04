function F1=func1(thet1)
global th2;
global y;
F1=y(:,1)-Htheta(thet1)*[sin(th2(1,1))*10; cos(th2(1,1))* sin(th2(2,1))* (-10); cos(th2(1,1))*cos(th2(2,1))* (-10); 1]
for k= 2:16
    F1=[F1; y(:,k)-Htheta(thet1)*[sin(th2(1,k))*10; cos(th2(1,k))* sin(th2(2,k))* (-10); cos(th2(1,k))*cos(th2(2,k))* (-10); 1]]
end
