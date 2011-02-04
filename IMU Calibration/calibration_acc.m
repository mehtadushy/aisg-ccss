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
bx = 4;
by = 4;
bz = -5;
b = [bx; by; bz]

%Scale factors
kx = 25;
ky = 25;
kz = 25;
K = [kx 0 0;0 ky 0;0 0 kz];

%Thetas
global th2;
th2 = zeros(2,17);
th2_0=zeros(2, 17);
global th1;
th1 = [kx;ky;kz;alpha_yz;alpha_zy;alpha_zx;bx;by;bz];
global y;
y=[[-1; -15; 203] [19; -32; 296] [-263; -12; -67] [263; -7; -37] [263; -8; -38] [-1; -276; -40] [236; 76; 26] [-2; 237; 17] [-30; 113; 172] [-212; -17; 99] [-13; -34; 201] [36; -16; -298] [264; -13; -42] [-259; -18; -8] [-4; -251; 61] [264; -14; -25]];
global i,j;
for j=1:200
  for i= 1:16
    th2_0(:,i) = th2(:,i);
    th2(:,i)= lsqnonlin(@func2, th2_0(:,i));
   end
th1_0= th1;
th1= lsqnonlin(@func1, th1_0);
end
