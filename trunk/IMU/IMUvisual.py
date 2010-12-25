#!/usr/bin/python

from __future__ import division
import sys, time
import visual
import IMUinterface

class IMUvisual(object):
  def __init__(self):
    self.imu=IMUinterface.IMU()
    self.init()
    self.init_3d()
    self.start_3d()
  
  def init(self):
    self.imu.start()
    time.sleep(2)
    self.imu.dev.write('4')
    
  def init_3d(self):
    self.pointer = visual.arrow(pos=(-0.5,0,0), axis=(1,0,0), shaftwidth=0.5,fixedwidth=1)
    self.axis = [(0,0,1),(0,1,0),(1,0,0)]

  def parse(self,pos):
    pos=pos.strip('\r$,')
    pos=pos.strip(',#\r\n')
    pos=pos.split(',',4)
    pos=[int(pos[0]),int(pos[1]),int(pos[2])]
    return pos
          
  def rot(self,past,pres):
    v=[0,0,0]
    d=visual.pi*50
    v[0]=(pres[0]-past[0])/d
    v[1]=(pres[1]-past[1])/d
    v[2]=(pres[2]-past[2])/d
    #v[0]=(pres[0])/d
    #v[1]=(pres[1])/d
    #v[2]=(pres[2])/d
    return v
    
  def start_3d(self):
    val=[0,0,0]
    prespos=[0,0,0]
    pastpos=[0,0,0]
      
    time.sleep(1)
      
    while True:
      visual.rate(100)
      prespos=self.parse(self.imu.current_reading)
      print prespos
      val=self.rot(prespos,pastpos)
      pastpos=prespos
      #print val
        
      #for i in range(3):
      self.pointer.rotate(angle=val[1],axis=self.axis[1],origin=(0,0,0))
       
if __name__ == '__main__':
  vis = IMUvisual()
