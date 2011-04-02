function F1= func_quat(thet)
global dat;
global stat;

f=0;
global bx;
global by;
global bz;
global roll;
global pitch;
global quat;
wtx= (1/(thet(2)*thet(3)))*(dat(:,4)-bx)*pi/180;
wty=(1/(thet(1)*thet(3)))*(dat(:,5)-by)*pi/180;
wtz=(1/(thet(1)*thet(2)))*(dat(:,6)-bz)*pi/180;
%delB_mod
dat(:,8)=sqrt((((wtx(:) .*dat(:,7))).^2)+(((wty(:) .*dat(:,7))).^2)+(((wtz(:) .*dat(:,7))).^2))/1000;
for m= 2: length(stat)-1
  
  for k=stat(m)+1 : stat(m+1)-1
      sin_var=sin(0.5*dat(k,8))/dat(k,8);
      samp_time=dat(k,7);  %ms
      temp= (0.5*dat(k,8))* eye(4) +(sin_var)*(samp_time)* ((1/1000)*[0 dat(k,4) dat(k,5) dat(k,6); -dat(k,4) 0 dat(k,6) -dat(k,5); -dat(k,5) -dat(k,6) 0 dat(k,4); -dat(k,6) dat(k,5) -dat(k,4) 0]);
      temp= cos(temp);
      quat(:,k)=(temp * quat(:,k-1));
      quat(:,k)=quat(:,k)/ (sum(quat(:,k).^2));
      roll(k)= (atan2(2*(quat(1,k)*quat(2,k)+quat(3,k)*quat(4,k)),((quat(1,k)^2) - (quat(2,k)^2) - (quat(3,k)^2) + (quat(4,k)^2))));
      pitch(k)=asin(-2*(quat(2,k)*quat(4,k)-quat(1,k)*quat(3,k)));
  end
         
  f=[f; 100*(dat(stat(m+1),9)-pitch(stat(m+1)-1)); 100*(dat(stat(m+1),10)-roll(stat(m+1)-1))];
  
end
F1=f;