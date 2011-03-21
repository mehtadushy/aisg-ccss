clc;
clear all;
%Scale
kx=1.7;      %roll
ky=4.78;      %pitch
kz=7.78;      %yaw
%Bias
bx=368;
by=348;
bz=350;
cd ('F:\Gyro_cal');
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
stat=[0];
for i= 1 : 5004
    mag(i,1)= (dat(i,1)^2) + (dat(i,2)^2) + (dat(i,3)^2);
    mag(i,1)= sqrt(mag(i,1));
    % Check for stationarity, and choose one point admist consequitive
    % stationary positions
    if ((mag(i,1)>978.0) && (mag(i,1)<982.0) && (dat(i,4)<450) && (dat(i,5)<450) &&(dat(i,6)<450)&& (dat(i,4)>290) && (dat(i,5)>290) &&(dat(i,6)>290)&&(dat(i-1,1)==0) && (dat (i-1,3)==0) && (dat (i-2,2)==0))
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

thet=[kx; ky; kz; bx; by; bz ];
thet_0 = thet;
lbthet=[0; 0; 0; 330; 330; 330];
ubthet=[1.5; 1.5; 1.5; 390; 390; 390];
options= optimset('TolFun',1e-8,'TolX',1e-8, 'MaxFunEvals', 600);
thet= lsqnonlin(@func1, thet_0, lbthet, ubthet, options);
