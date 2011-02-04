function H= Htheta(thet1)
H=[([thet1(1) 0 0;0 thet1(2) 0; 0 0 thet1(3)]*([1 -thet1(4) thet1(5); 0 1 -thet1(6); 0 0 1]^(-1))) [thet1(7); thet1(8); thet1(9)] ];