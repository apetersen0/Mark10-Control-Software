import getpass
import sys
import telnetlib
import time

HOST = "138.67.239.254"
PORT = 5200

tn = telnetlib.Telnet(HOST, PORT)

for i in range(1, 5):
	print "Sending trigger\n"
	tn.write("\n")
	time.sleep(5)

tn.write("Q")

tn.close()
