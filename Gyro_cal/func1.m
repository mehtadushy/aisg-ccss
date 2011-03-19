function F1= func1(thet)
global dat;
global stat;
s=1;
f=0;
for i= 2: length(stat)
  p=dat(stat(i),9);
  r=dat(stat(i),10);
  for j=stat(i)+1 : stat(i+1)
      p= p + dat(j,7)* sec(p) * (1/(thet(2)*thet(3)))*(dat(j,4)-thet(4));
      r=r + dat(j,7)* sec(p) * (1/(thet(2)*thet(3)))*(dat(j,4)-thet(4));
  f=f+((dat(stat(i+1),9)-p)^2)