#!/usr/bin/python2.7

import sys

for l in sys.stdin:
	try:
		print l.strip().decode('ascii')
	except UnicodeDecodeError:
		pass
 

