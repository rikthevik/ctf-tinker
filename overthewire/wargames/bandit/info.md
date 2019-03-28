
Bandit
======

http://overthewire.org/wargames/bandit/

I tried to do most of these with the shell. There were certainly a few instances
where the shell was being a pain (or netcat) and python would have been much easier.
Afterwards, I feel like I've gotten refreshed on some of the unix commands I don't
use a whole lot.

Major takeaways:
 - Leading dashes, spaces in unix filenames and hidden files - such a pain.
 - Whatever version of netcat is installed doesn't allow you to pipe stdin.  Wtf.

Ideas for more exercises:
 - Symlinks?
 - Pipes?

A few comments are inline.

### bandit0: bandit0
```
$ cat readme
```

### bandit1: boJ9jbbUNNfktd78OOpsqOltutMc3MY1
```
$ cat < -
```
This seems like a pretty hokey way to start this off. Files that start with dashes,
spaces, are so goddamn annoying and the shell falls on its face so hard. You can't
count on most commands to use -- properly, it's so frustrating. I feel like there 
are better ways they could have started this off. It's definitely an annoying part
of using the shell and you do have to know about it, but shouldn't be so early.

### bandit2: CV1DtqXWVFXTvM2F0k09SHz0YwRINYA9
```
$ cat spaces\ in\ this\ filename
```

### bandit3: UmHadQclWmgdLOKQ3YNgjWxGoRMb5luK
```
$ find . | grep hid | xargs cat
```

### bandit4: pIwrPrtPN36QITSp3EQaw936yaFoFgAB
```
$ file -- *
$ cat < -file07
```

### bandit5: koReBOKuIDDepwhWk7jZC0RTdopnAYKh
```
$ ls -la */.[a-z]* | grep 1033
```
More fun with hidden files and having to be super careful about your shell expansions.

### bandit6: DXjZPULLxYr17uwoI01bNLQbtFemEgo7
```
$ for f in `find /`; do ls -la $f; done > allfiles
```
Looking through the whole filesystem for a file with certain properties. Sent all of 
the output to a file and then used vim to search for it.

### bandit7: HKBPTKQnIay4Fw76bEy8PVxKEDQRKTzs
```
$ cat data.txt | grep million
```

### bandit8: cvX2JJa4CFALtqS87jk27qwqGhBM9plV
```
$ cat data.txt | sort | uniq -c
```
I had forgotten about `uniq -c` to count the occurrences in a file.

### bandit9: UsvVyFSfZZWbi6wgC7dAFyFuR6jQQUhR
```
$ strings data.txt  | grep ===
```

### bandit10: truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk
```
$ cat data.txt  | base64 -d
```

### bandit11: IFukwKGsFW8MOq3IRFqrxE1hxTNEbUPR
```
$ cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'
```
I knew tr could do this - had no idea how and had to google this.

### bandit12: 5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu
```
$ xxd -r hexcode.whatever
```
I'd never used xxd before, I think I've used hexedit or hexdump mostly, and I've
never had to revert a hexdump file before, so that was new. The exercise of running
file to determine whether you had to tar, gunzip, bunzip2 or whatever was annoying.

### bandit13: 8ZjyCRiBWFYkneahHwxCv3wb2a1ORpYL
```
$ ssh -l bandit14 localhost -i sshkey.private
```

### bandit14: 4wcYUJFw0k0XLShlDzztnTBHiqxU3b3e
```
$ telnet localhost 30000
```

### bandit15: BfMYroe26WYalil77FoDi9qh59eK5xNr 
```
$ openssl s_client -connect localhost:30001
```
Hadn't used this in a long time.  Usually I think about SSL being a HTTPS thing, but
there's plenty of applications for running any old data stream through SSL.

### bandit16: cluFn7wTiGryunymYOu4RcffSxQluehd
```
$ nmap localhost -p 31000-32000
$ openssl s_client -connect localhost:31790
```
Pretty straightforward - nmap told me which ones were running SSL, so there were only
a few choices. I think using netcat to scan you would have to do more work to see which 
ones had SSL support. Didn't know netcat was good for scanning, I've always used nmap.

### bandit17: <key>
```
$ diff passwords.old passwords.new
```

### bandit18: kfBf3eYk5BPBRzwjqutbbfE887SVc5Yd
```
$ ssh bandit.labs.overthewire.org -p 2220 -l bandit18 cat readme
```
Running the command directly means the interactive bashrc that would kick you out
doesn't run.

### bandit19: IueksS7Ubh8G3DCwVzrTd8rAVOwq3M5x
```
$ ./bandit20-do cat /etc/bandit_pass/bandit20
```
Suid binary to print the password.

### bandit20: GbKksEFF4yrVs6il55v6gwY5aVje5f0j
```
$ echo GbKksEFF4yrVs6il55v6gwY5aVje5f0j | nc -l -p 12345 &
$ ./suconnect 12345
```
Netcat seemed to work fine here...

### bandit21: gE269g2h3mw3pwgrj0Ha9Uoqen1c9DGr
```
$ cat /etc/cron.d/*
$ cat /usr/bin/cronjob_bandit22.sh
$ cat /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
```

### bandit22: Yk7owGAcWjwMVRwrTesJEwB7WVOiILLI
```
change myname to bandit23 in /usr/bin/cronjob_bandit23.sh
$ cat /tmp/8ca319486bfbbc3663ea0fbe81326349
```
Kind of cool to look at the script, but running it without modifications
gives you the wrong answer, you need to modify it and re-run it.

### bandit23: jc1udXuA1tiHqjIsL8yaapX5XIAI6i0n
```
wrote a /tmp/tmp.NwNxV2gym6/rik.sh script 
 $ cp /etc/bandit_pass/bandit* /tmp/tmp.NwNxV2gym6
 $ chmod 777 /tmp/tmp.NwNxV2gym6/*
$ cp rik.sh /var/spool/bandit24/
```
Kind of cool that you're writing a script that'll get run as another user.
So you copy out all of the password files available to that user and 
consume them from a shared location.

### bandit24: UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ 
```
$ for f in `seq -w 1000 9999`; do sleep 0.5; echo "trying $f" >&2; echo UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ $f; done | ncat -o output localhost 30002
```
Netcat really gave me some headaches here.  For whatever reason, piping output straight
to nc/netcat, expecting netcat to send it was not working properly.  Turns out netcat 
is pretty fragmented and I think I had an old version, or my terminal was screwed up -
something was not working as intended.

Then there was some timing issues where it seemed like the service couldn't read output 
fast enough.  I thought I could put that `seq` output into a file and pipe it straight 
to netcat and it would read and write as it got lines, but that sure didn't work out.
On another day I'd write a python program to have good control over the socket, but I felt like the 
shell _really_ should be able to do this.

### bandit25: uNG9O58gUE7snukf3bvZ0rxhtnjzSGzG
```
$ grep bandit26 /etc/passwd
$ /usr/bin/showtext
$ ssh -i 
the weakness is in /bin/more.  if you shrink your terminal, more will be semi-interactive
hit v to get into vi
:r /etc/bandit_pass/bandit26
:set shell=/bin/bash
```

I had to google this one. This is kind of like the ps aux thing where it chops off input
to your terminal size.  So we couldn't grep for particular commands running if the terminal
was too small.  Bunch of horseshit, really, and unix should have fixed this a long time ago.

Anyway, yeah, I guess you can hit v within more and get it to go to vim. That's new.

### bandit26: 5czgV9L3Xx8JPOyRbXh6lQbmIOWvPT6Z
```
$ ssh -i bandit26.sshkey localhost -p 22 -l bandit26
$ ./bandit27-do cat /etc/bandit_pass/bandit27
```

### bandit27: 3ba3118a22e93127a4ed485be72ef5ea
```
$ git clone ssh://bandit27-git@localhost/home/bandit27-git/repo
$ cat repo/README
```

### bandit28: 0ef186ac70e04ea33b4c1853d2526fa2
```
$ git clone ssh://bandit28-git@localhost/home/bandit28-git/repo
$ cd repo
$ git log
$ git checkout 186a1038cc54d1358d42d468cdc8e3cc28a93fcb
$ cat README*
```

### bandit29: bbc96594b4e001778eee9975372716b2
```
$ git branch -r
$ git checkout dev
$ cat README.md
```
Forgot about `-r` for that git branch command. I thought a `fetch --all`
would pull the branches down, but that's on me, I guess.

### bandit30: 5b90576bedb2cc04c86a9e924ce42faf
```
$ git tag -l
$ git show-ref --tags -d
$ git unpack-file 47e603bb428404d265f59c42920d81e5
$ vi .merge_file_miVrqL
```
This was new.  I knew there was something hiding in here, but seeing a tag
that referenced a commit hash I couldn't find, that was new. I found the objects
within the .git structure, but had to google how to get them into a format I could read.

### bandit31: 47e603bb428404d265f59c42920d81e5
```
$ cat README.md
$ vi key.txt
$ git add key.txt -f
$ git commit -m "wat"
$ git push origin
```

### bandit32: 56a9bf19c63d650ce78e6ec0354ee45e
```
as bandit31 in bash
$ echo vi > /tmp/VI
$ chmod 777 /tmp/VI
as bandit32 in uppershell
>> /*/VI
:set shell=/bin/bash
```
This was kind of cute.  I tried a few things with trying to pass environment variables
into the shell somehow.  It looks like LC variables come across with SSH, and I maybe
could have hidden a command in there. I ended up finding a tempdir and running a script
out of there. Probably could have run bash directly.

After reading a solution online, it looks like you could type $0 to break out.

### bandit33: c9c3199ddf4121b10cf581a98d51caee

The end!

