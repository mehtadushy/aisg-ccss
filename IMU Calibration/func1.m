function F1=func1(thet1)
global th2;
global y;
g=9.8;
F1=y(:,1)-Htheta(thet1)*[sin(th2(1,1))*g; cos(th2(1,1))* sin(th2(2,1))* (-g); cos(th2(1,1))*cos(th2(2,1))* (-g); 1];
for k= 2:16
    F1=[F1; y(:,k)-Htheta(thet1)*[sin(th2(1,k))*g; cos(th2(1,k))* sin(th2(2,k))* (-g); cos(th2(1,k))*cos(th2(2,k))* (-g); 1]];
end
