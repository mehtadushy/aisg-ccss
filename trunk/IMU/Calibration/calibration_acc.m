%IMU Calibration routine
%04-02-2011
clc;
clear all;
%Angle transformation matrix
alpha_yz = 0;
alpha_zy = 0;
alpha_zx = 0;
T = [1 -alpha_yz alpha_zy; 0 1 -alpha_zx; 0 0 1];

%Offsets
bx = 0;
by = 0;
bz = 0;
b = [bx; by; bz]

%Scale factors
kx = 25;
ky = 25;
kz = 25;
K = [kx 0 0;0 ky 0;0 0 kz];

%Thetas
global th2;
th2 = zeros(2,16);
th2_0=zeros(2,16);
global th1;
th1 = [kx;ky;kz;alpha_yz;alpha_zy;alpha_zx;bx;by;bz];
global y;
y=[[-1; -15; 203] [19; -32; -297] [-263; -12; -67] [263; -7; -37] [263; -8; -38] [-1; -276; -40] [236; 76; 26] [-2; 237; 17] [-30; 113; 172] [-212; -17; 99] [-13; -34; 201] [36; -16; -298] [264; -13; -42] [-259; -18; -8] [-4; -251; 63] [264; -14; -25]];
global i,j;
lbth2=[-pi; -pi];
ubth2=[pi; pi];
lbth1=[22;22;22;-pi/8;-pi/8;-pi/8;-60;-60;-60];
ubth1=[30;30;30;pi/8;pi/8;pi/8;60;60;60];
options= optimset('TolFun',1e-8,'TolX',1e-8);
for j=1:200
  for i= 1:16
    th2_0(:,i) = th2(:,i);
    th2(:,i)= lsqnonlin(@func2, th2_0(:,i),lbth2,ubth2,options);
   end
th1_0= th1;
th1= lsqnonlin(@func1, th1_0,lbth1,ubth1,options);
end
