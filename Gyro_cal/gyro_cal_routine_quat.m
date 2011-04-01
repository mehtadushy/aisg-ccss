clc;
clear all;
%warning off all;
%Scale
kx=0.89;      %roll
ky=0.8973;      %pitch
kz=0.90;      %yaw
%Bias
global bx;
global by;
global bz;
bx=380;
by=372;
bz=379;
global dat;
dat= csvread('IMUoutput.txt');
dat(:,2)= dat(:,2)+15.0;  %Acc bias correction
dat(:,3)= dat(:,3)+48.0;
dat(:,1)= dat(:,1)*(100.0/26.7); %Acc scale correction  100*g
dat(:,2)= dat(:,2)*(100.0/26.9);
dat(:,3)= dat(:,3)*(100.0/25.65);
dat(:,7)= dat(:,7)/8000.0;  %Time in ms
dat= [dat zeros(5004,3)]; %delB_mod, pitch and roll

s=0;
global stat;
global roll;
global pitch;
global quat;
quat= zeros(4,5004);
roll= zeros(5004,1);
pitch= zeros(5004,1);
stat=[0];
m=1;
while m<5004
    mag(m,1)= (dat(m,1)^2) + (dat(m,2)^2) + (dat(m,3)^2);
    mag(m,1)= sqrt(mag(m,1));
    % Check for stationarity, and choose one point admist consequitive
    % stationary positions
    if ((mag(m,1)>976.0) && (mag(m,1)<984.0) && (dat(m,4)<450) && (dat(m,5)<450) &&(dat(m,6)<450)&& (dat(m,4)>300) && (dat(m,5)>300) &&(dat(m,6)>300)&&(dat(m-1,1)==0) && (dat (m-1,3)==0) && (dat (m-2,2)==0))
        s=s+1;
        
        stat= [stat m]; % Log instances of stationarity 
        %Compute orientation
        dat(m,9)= real(asin(dat(m,1)/980.0)); % Compute pitch
        dat(m,10)=real(atan2(dat(m,2),dat(m,3))); % Compute roll
        quat(:,m)= [real(cos(dat(m,10)/2)* cos(dat(m,9)/2)); real(sin(dat(m,10)/2)*cos(dat(m,9)/2)); real(cos(dat(m,10)/2)*sin(dat(m,9)/2)); 0.0];
        
        m=m+25;
    else
        dat(m,1:3)=[0 0 0];
        m=m+1;
    end
    
end

roll=dat(:,10);
pitch=dat(:,9);

thet=[kx; ky; kz];
thet_0 = thet;
lbthet=[0.75; 0.75; 0.75];
ubthet=[0.95; 0.95; 0.95];
options= optimset('TolFun',1e-8,'TolX',1e-8, 'MaxFunEvals', 600, 'MaxIter', 2000);
%options= optimset('MaxFunEvals', 1200);
thet= lsqnonlin(@func_quat, thet_0, lbthet, ubthet, options);
