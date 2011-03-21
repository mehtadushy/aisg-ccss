clc;
clear all;
%Scale
kx=0.81;      %roll
ky=0.81;      %pitch
kz=0.81;      %yaw
%Bias
bx=370;
by=370;
bz=370;
thet=[kx; ky; kz; bx; by; bz];
global dat;
dat= csvread('IMUoutput.txt');
dat(:,2)= dat(:,2)+15.0;  %Acc bias correction
dat(:,3)= dat(:,3)+48.0;
dat(:,1)= dat(:,1)*(100.0/26.7); %Acc scale correction  100*g
dat(:,2)= dat(:,2)*(100.0/26.9);
dat(:,3)= dat(:,3)*(100.0/25.65);
dat(:,7)= dat(:,7)/8000.0;  %Time in ms
dat= [dat zeros(5004,3)]; %Stationary, pitch and roll
roll= zeros(5004,1);
pitch= zeros(5004,1);
s=0;
global stat;
stat=[0];
for i= 1 : 5004
    mag(i,1)= (dat(i,1)^2) + (dat(i,2)^2) + (dat(i,3)^2);
    mag(i,1)= sqrt(mag(i,1));
    % Check for stationarity, and choose one point admist consequitive
    % stationary positions
    if ((mag(i,1)>978.0) && (mag(i,1)<982.0) && (dat(i-1,1)==0) && (dat (i-1,3)==0) && (dat (i-2,2)==0))
        s=s+1;
        dat(i,8)= s;  % mark as stationary
        stat= [stat i]; % Log instances of stationarity 
        %Compute orientation
        dat(i,9)= asin(dat(i,1)/980.0)*(180/pi); % Compute pitch
        if (dat(i,2)<0)
            if (dat(i,3)<0)
              dat(i,10)=atan(abs(dat(i,2)/dat(i,3)))*(180/pi); % Compute roll
            else
              dat(i,10)=(180) - atan(abs(dat(i,2)/dat(i,3)))*(180/pi);
            end
        else
            if (dat(i,3)<0)
              dat(i,10)=-atan(abs(dat(i,2)/dat(i,3)))*(180/pi); % Compute roll
            else
              dat(i,10)=(-180) + atan(abs(dat(i,2)/dat(i,3)))*(180/pi);
            end 
        end
    else
        dat(i,1:3)=[0 0 0];
    end
    
end
roll=dat(:,10);
pitch=dat(:,9);
hold on;
plot(1:5004,roll,'r');

for i= 2: length(stat)-1
 %if (stat(i+1)-stat(i))<400  
  
  for j=stat(i)+1 : stat(i+1)-1
      roll(j)= roll(j-1) + dat(j,7)*(1/1000.0)* sec(pitch(j-1)*pi/180) * (1/(thet(2)*thet(3)))*(dat(j,4)-thet(4));
      pitch(j)= pitch(j-1) + dat(j,7)*(1/1000.0)* sec(pitch(j-1)*pi/180) *(( (1/(thet(1)*thet(3)))*(dat(j,5)-thet(5))* cos(roll(j-1)*pi/180)) -((1/(thet(1)*thet(2)))*(dat(j,6)-thet(6))* sin(roll(j-1)*pi/180)));
       if roll(j)> 180
           roll(j)= roll(j) -360;
       end
       if roll(j)<-180
           roll(j)=roll(j)+360;
       end
       pitch(j)=sin(pitch(j)*pi/180);
       pitch(j)= asin(pitch(j))*180/pi;
  
  end
end
plot(1:5004,roll,'g');
hold off;
  dat(:,10)=roll;
  dat(:,9)=pitch;
