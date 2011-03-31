function F1= func1(thet)
global dat;
global stat;

f=0;
global bx;
global by;
global bz;
global roll;
global pitch;
for i= 2: length(stat)-1
 %if (stat(i+1)-stat(i))<400  
  
  for j=stat(i)+1 : stat(i+1)-1
      roll(j)= roll(j-1) + dat(j,7)*(1/1000.0)* sec(pitch(j-1)*pi/180) * (1/(thet(2)*thet(3)))*(dat(j,4)-bx);
      pitch(j)= pitch(j-1) + dat(j,7)*(1/1000.0)* sec(pitch(j-1)*pi/180) *(( (1/(thet(1)*thet(3)))*(dat(j,5)-by)* cos(roll(j-1)*pi/180)) -((1/(thet(1)*thet(2)))*(dat(j,6)-bz)* sin(roll(j-1)*pi/180)));
      
      %A way of rejecting data with divisions by zero
      if roll(j)> 360
           roll(j)= roll(j-1);
       end
       if roll(j)<-360
           roll(j)=roll(j-1);
       end
      
      %roll(j)= rem(roll(j),360);
      %pitch(j)=rem(pitch(j),360);
      if roll(j)> 180
           roll(j)= roll(j) -360;
       end
       if roll(j)<-180
           roll(j)=roll(j)+360;
       end
       pitch(j)=sin(pitch(j)*pi/180);
       pitch(j)= asin(pitch(j))*180/pi;
  end

        
  %roll= asin(roll)*180/pi;
  %pitch=sin(pitch*pi/180);
  %pitch= asin(pitch)*180/pi;
 
  f=[f; (dat(stat(i+1),9)-pitch(stat(i+1)-1)); 100*(dat(stat(i+1),10)-roll(stat(i+1)-1))];
  %f=[f; (dat(stat(i+1),9)-pitch)];
 %end
end
F1=f;