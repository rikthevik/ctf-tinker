import sys, collections
unique = collections.defaultdict(list)
for f in sys.argv[1:]:
	unique[open(f).read()].append(f)

for i, (content, filenames) in enumerate(unique.iteritems()): 
	print i, filenames
	open("uniq-%d.html" % i, "w").write(content)

