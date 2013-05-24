import time
import threading
import bitcoin
import os

a = bitcoin.deterministic_wallet()
a.new_seed()
seed = a.seed()
a.set_seed(seed)
mpk = a.master_public_key()
print 'mpk', str(mpk).encode('hex'), mpk.__class__
pub = a.generate_public_key(0, True)
print "public key"
print str(pub).encode('hex'), pub.__class__


