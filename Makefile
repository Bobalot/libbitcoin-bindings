CC = g++ -fPIC -DPIC
SWIG = swig2.0

all: swig compile

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

test: basetests fullnode

basetests:
	echo "WALLET TEST"
	PYTHONPATH=$(PWD) python tests/wallet.py
	echo "CURVES TEST"
	PYTHONPATH=$(PWD) python tests/elliptic.py
	echo "GENERAL TEST"
	PYTHONPATH=$(PWD) python tests/test.py
	echo "GENESIS BLOCK"
	PYTHONPATH=$(PWD) python tests/satoshiwords.py

fullnode:
	echo "FULL NODE TEST"
	PYTHONPATH=$(PWD) python tests/fullnode.py

compile:
	$(CC) -c -v libbitcoin_wrap.cxx  `pkg-config --cflags --libs libbitcoin` `pkg-config --cflags python`
	$(CC) -shared -Wl,-soname,_bitcoin.so libbitcoin_wrap.o `pkg-config --libs libbitcoin` `pkg-config --libs python` -o _bitcoin.so

