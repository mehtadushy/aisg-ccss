#!/usr/bin/python

import threading, sys, os
import struct
import serial
import time

class IMUConnectError(Exception):
  def __init__(self):
    sys.stderr.write('Could not find the IMU on the serial port... \nCheck the device or provide the absolute path to the device as an argument...\n')
  
class IMUDataIOError(IOError):
  def __init__(self):
    sys.stderr.write('Could not read/write data to IMU...\nCheck connections or restart the IMU')

class IMU(object):
  def __init__(self,device = '',log_file = 'IMUoutput.txt'):
    #NULL = open('/dev/null','w+')
    self.input = sys.stdin
    self.output = sys.stdout
    #comment below to see the output on stdout
    #self.output = NULL
    self.current_reading = ''
    
    if device == '': device = self.scan_device()
    
    self.log = open(log_file,'w')
    self.dev = serial.Serial(device, 57600, timeout=1)
    self.alive = False
    self.dev.flushOutput()
    self.dev.flushInput()
    self.sync_flag = False
    self.time = 0
    self.log_flag= False
    
  def scan_device(self):
    sys.stderr.write('No Arguments provided...\nScanning for device...\n')
    for i in range(11):
      dev = '/dev/ttyUSB'+str(i)
      if os.path.exists(dev):
        sys.stderr.write('Found IMU: '+ dev+ '\n')
        break
    if i == 10: raise IMUConnectError
    return dev

  def start(self):
    self.alive = True
    #Rx thread
    self.rx_thread = threading.Thread(target=self.read)
    self.rx_thread.start()
    #Tx thread
    self.tx_thread = threading.Thread(target=self.write)
    self.tx_thread.start()
    
  def stop(self):
    self.dev.write('\n')
    self.alive = False
    self.dev.flushOutput()
    self.dev.flushInput()
    self.dev.close()
    
  def read(self):
    try:
      while self.alive:
        #_time = time.time()
        #_freq = 1/(_time-self.time)
        #print _freq
        #self.time = _time
        if self.sync_flag:
          data = self.dev.read(size=14)
          try:
            udata = struct.unpack('>hhhhhhh',data)
            #self.output.write(str(udata)+'\n')
            self.process(udata)
            if self.log_flag:
              self.log.write(str(udata)[1:-1]+'\n')
          except Exception,e:
            print e
          continue
        data = self.dev.readline()
        if data == '': continue
        if data.rfind('SYNC')!= -1:
          self.sync_flag = True

        #self.output.write(data)
        self.current_reading = data
        
    except serial.SerialException:
      self.alive = False
      raise IMUDataIOError
    except serial.SerialTimeoutException:
      self.alive = False
      raise IMUDataIOError
     
  def write(self):
    try:
      while self.alive:
        data = self.input.read(1)
        try:
          if data == 'c': 
            self.sync_flag = False
            self.stop()
          if data == 'r': 
            self.sync_flag = False
            self.dev.write('\n')
          if data == 'l':
             if self.log_flag == True:
               self.log_flag = False
             else:
               self.log_flag = True
          data=int(data)
        except: continue
        self.dev.write(str(data))
    except serial.SerialException:
      self.alive = False
      raise IMUDataIOError
    
  def process(self,data):
      self.data = list(data)

if __name__ == '__main__':
  try:
    if sys.argv[1]:
      imu=IMU(device=sys.argv[1])
      imu.start()
  except Exception,e:
      print 'Port error: ' + str(e)
