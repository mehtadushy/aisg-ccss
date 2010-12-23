#!/usr/bin/python

import threading, sys, os
import serial

class IMUConnectError(Exception):
  def __init__(self):
    print 'Could not find the IMU on the serial port... \nCheck the device or provide the absolute path to the device as an argument...\n'
  
class IMUDataIOError(IOError):
  def __init__(self):
    print 'Could not read/write data to IMU...'

class IMU(object):
  def __init__(self,device = '/dev/ttyUSB0',log_file = 'IMUoutput.txt'):
    log = open('log_file','w');
    self.dev = serial.Serial(device, 38400, timeout=1)
    self.alive = False
    self.dev.flushOutput()
    self.dev.flushInput()
    
  def start(self):
    self.alive = True
    #Rx thread
    self.rx_thread = threading.Thread(target=self.read)
    self.rx_thread.start()
    #Tx thread
    self.tx_thread = threading.Thread(target=self.write)
    self.tx_thread.start()
    
  def stop(self):
    self.alive = False
    self.dev.flushOutput()
    self.dev.flushInput()
    self.dev.close()
    
  def read(self):
    try:
      while self.alive:
        data = self.dev.readline()
        sys.stdout.write(data)
        pass
    except serial.SerialException:
      self.alive = False
      raise IMUDataIOError
    except serial.SerialTimeoutException:
      self.alive = False
      raise IMUDataIOError
     
  def write(self):
    try:
      while self.alive:
        data = sys.stdin.read(1)
        try:
          if data == 'c':
            self.stop()
          data=int(data)
        except:
          continue
        self.dev.write(str(data))
    except serial.SerialException:
      self.alive = False
      raise IMUDataIOError
    
if __name__ == '__main__':
  dev = '/dev/ttyUSB0'
  try:
    for i in range(11):
      dev = '/dev/ttyUSB'+str(i)
      if os.path.exists(dev):
        break
    if i == 10:
      raise Exception
  except Exception:
    raise IMUConnectError
    exit()
    
  imu=IMU(dev)
  imu.start()
