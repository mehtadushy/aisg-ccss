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
wtx= (1/(thet(2)*thet(3)))*(dat(:,4)-bx);
wty=(1/(thet(1)*thet(3)))*(dat(:,5)-by);
wtz=(1/(thet(1)*thet(2)))*(dat(:,6)-bz);
%delB_mod
dat(:,8)=sqrt((((wtx(:) .*dat(:,7))./1000).^2)+(((wty(:) .*dat(:,7))./1000).^2)+(((wtz(:) .*dat(:,7))./1000).^2));
for m= 2: length(stat)-1
  
  for k=stat(m)+1 : stat(m+1)-1
      
      temp= (cos(0.5*dat(k,8))*eye(4))+(sin(0.5*dat(k,8))/dat(k,8))*dat(k,7)*[0 dat(k,4) dat(k,5) dat(k,6); -dat(k,4) 0 dat(k,6) -dat(k,5); -dat(k,5) -dat(k,6) 0 dat(k,4); -dat(k,6) dat(k,5) -dat(k,4) 0];
      quat(:,k)=(temp * quat(:,k-1));
      roll(k)= (atan2(2*(quat(1,k)*quat(2,k)),((quat(1,k)^2) - (quat(2,k)^2) - (quat(3,k)^2))));
      pitch(k)=asin(2*(quat(1,k)*quat(3,k)));
  end
         
  f=[f; 100*(dat(stat(m+1),9)-pitch(stat(m+1)-1)); 100*(dat(stat(m+1),10)-roll(stat(m+1)-1))];
  
end
F1=f;