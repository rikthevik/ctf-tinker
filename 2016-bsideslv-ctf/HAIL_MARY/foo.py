import sys, requests
import time

cookie = {
	"PHPSESSID": "5tsnsv8cfdjoi1avpteh2kalf3"
}
headers = {
	'User-agent': 'Mozilla/5.0'
}
for i in range(0x00, 256):
	data = { 
		"flag": "0x%02x" % i,
		"flagguess": "+Submit+Flag+", 
	}
	print data
	r = requests.post("https://scoreboard.wctf.ninja/index.php?wtf=submitflag", cookies=cookie, data=data, headers=headers)
	r.raise_for_status()
	# print r.text
	time.sleep(0.1)

