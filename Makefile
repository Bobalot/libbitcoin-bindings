CC = g++-4.8 -fPIC -DPIC
SWIG = swig2.0

all: cleandatabase swig compile test

clean:
	rm *.o
	rm *.cxx
	rm *.pyc
	rm bitcoin.py
	rm *.so
	
cleandatabase:
	rm -rf database/*

swig:
	$(SWIG) -c++ -python -modern -threads `pkg-config --cflags-only-I libbitcoin` -I`$(SWIG) -swiglib`/python libbitcoin.i

test:
	export PYTHONPATH=$(PWD)
	echo "WALLET TEST"
	python tests/wallet.py
	echo "CURVES TEST"
	python tests/elliptic.py
	echo "GENERAL TEST"
	python tests/test.py

compile:
	$(CC) -c -v libbitcoin_wrap.cxx  `pkg-config --cflags --libs libbitcoin` `pkg-config --cflags python`
	$(CC) -shared -Wl,-soname,_bitcoin.so libbitcoin_wrap.o `pkg-config --libs libbitcoin` `pkg-config --libs python` -o _bitcoin.so

