clc;
clear all;
%Scale
kx=-80.0;      %roll
ky=80.0;      %pitch
kz=80.0;      %yaw
%Bias
bx=340.0;
by=340.0;
bz=340.0;
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
    if ((mag(i,1)>978.0) && (mag(i,1)<982.0) && (dat(i-1,1)==0) && (dat (i-1,3)==0) && (dat (i-2,2)==0))
        s=s+1;
        dat(i,8)= s;  % mark as stationary
        stat= [stat i]; % Log instances of stationarity 
        %Compute orientation
        dat(i,9)= asin(dat(i,1)/980.0)*(180/pi); % Find pitch
        dat(i,10)=atan(dat(i,2)/dat(i,3))*(180/pi); % Find roll
    else
        dat(i,1:3)=[0 0 0];
    end
    
end

thet=[kx; ky; kz; bx; by; bz ];
thet_0 = thet;
lbthet=[];
ubthet=[];
options= optimset('TolFun',1e-8,'TolX',1e-8);
thet= lsqnonlin(@func1, thet_0, lbthet, ubthet, options);
