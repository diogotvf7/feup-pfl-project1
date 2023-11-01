run:
	/usr/local/sicstus4.8.0/bin/sicstus -l main.pl
	# rlwrap /usr/local/sicstus4.8.0/bin/sicstus -l main.pl

test:
	# /usr/local/sicstus4.8.0/bin/sicstus -l test.pl
	rlwrap /usr/local/sicstus4.8.0/bin/sicstus -l test.pl