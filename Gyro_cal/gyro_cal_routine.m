clc;
clear all;
%Scale
kx=0.90;      %roll
ky=0.903;      %pitch
kz=0.895;      %yaw
%Bias
global bx;
global by;
global bz;
bx=380;
by=362;
bz=378;
global dat;
dat= csvread('IMUoutput.txt');
dat(:,2)= dat(:,2)+15.0;  %Acc bias correction
dat(:,3)= dat(:,3)+48.0;
dat(:,1)= dat(:,1)*(100.0/26.7); %Acc scale correction  100*g
dat(:,2)= dat(:,2)*(100.0/26.9);
dat(:,3)= dat(:,3)*(100.0/25.65);
dat(:,7)= dat(:,7)/8000.0;  %Time in ms
dat= [dat zeros(5004,3)]; %Stationary, pitch and roll
s=0;
global stat;
global roll;
global pitch;
roll= zeros(5004,1);
pitch= zeros(5004,1);
stat=[0];
for i= 1 : 5004
    mag(i,1)= (dat(i,1)^2) + (dat(i,2)^2) + (dat(i,3)^2);
    mag(i,1)= sqrt(mag(i,1));
    % Check for stationarity, and choose one point admist consequitive
    % stationary positions
    if ((mag(i,1)>976.0) && (mag(i,1)<984.0) && (dat(i,4)<500) && (dat(i,5)<500) &&(dat(i,6)<500)&& (dat(i,4)>200) && (dat(i,5)>200) &&(dat(i,6)>200)&&(dat(i-1,1)==0) && (dat (i-1,3)==0) && (dat (i-2,2)==0))
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

thet=[kx; ky; kz];
thet_0 = thet;
lbthet=[0.75; 0.75; 0.75];
ubthet=[0.95; 0.95; 0.95];
options= optimset('TolFun',1e-8,'TolX',1e-8, 'MaxFunEvals', 2500, 'MaxIter', 2000);
%options= optimset('MaxFunEvals', 1200);
thet= lsqnonlin(@func1, thet_0, lbthet, ubthet, options);
