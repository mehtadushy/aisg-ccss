function F2= func2(thet2)
global th1;
global y;
global i;
ba= [sin(thet2(1))*10; cos(thet2(1))* sin(thet2(2))* (-10); cos(thet2(1))*cos(thet2(2))* (-10); 1]
F2=y(:,i)-Htheta(th1)*ba;