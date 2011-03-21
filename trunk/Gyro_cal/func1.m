function F1= func1(thet)
global dat;
global stat;
rollcoll=0;
pitchcoll=0;
f=0;
for i= 2: length(stat)-1
 %if (stat(i+1)-stat(i))<400  
  roll=dat(stat(i),10);
  pitch=dat(stat(i),9);
  for j=stat(i)+1 : stat(i+1)
      rolli=roll;
      pitchi=pitch;
      roll= roll + dat(j,7)*(1/1000.0)* sec(pitchi*pi/180) * (1/(thet(2)*thet(3)))*(dat(j,4)-thet(4));
      pitch= pitch + dat(j,7)*(1/1000.0)* sec(pitchi*pi/180) *(( (1/(thet(1)*thet(3)))*(dat(j,5)-thet(5))* cos(rolli*pi/180)) -((1/(thet(1)*thet(2)))*(dat(j,6)-thet(6))* sin(rolli*pi/180)));
      if roll> 180
          roll= roll -360;
      end
      if roll<-180
          roll=roll+360;
      end
      pitch=sin(pitch*pi/180);
      pitch= asin(pitch)*180/pi;
  
  end
  
      
  %roll= asin(roll)*180/pi;
  %pitch=sin(pitch*pi/180);
  %pitch= asin(pitch)*180/pi;
  rollcoll=[rollcoll; roll]
  pitchcoll=[pitchcoll; pitch]
  f=[f; 100*(dat(stat(i+1),9)-pitch); 100*(dat(stat(i+1),10)-roll)];
  %f=[f; (dat(stat(i+1),9)-pitch)];
 %end
end
F1=f;