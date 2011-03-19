function F1= func1(thet)
global dat;
global stat;

f=0;
for i= 2: length(stat)-20
  pitch=dat(stat(i),9);
  roll=dat(stat(i),10);
  for j=stat(i)+1 : stat(i+1)
      roll= roll + dat(j,7)*(1/1000.0)* sec(pitch*pi/180) * (1/(thet(2)*thet(3)))*(dat(j,4)-thet(4));
      pitch= pitch + dat(j,7)*(1/1000.0)* sec(pitch*pi/180) *(( (1/(thet(1)*thet(3)))*(dat(j,5)-thet(5))* cos(roll*pi/180)) -((1/(thet(1)*thet(2)))*(dat(j,6)-thet(6))* sin(roll*pi/180)));
  end
  f=[f; (dat(stat(i+1),9)-pitch); (dat(stat(i+1),10)-roll)];
end
F1=f;