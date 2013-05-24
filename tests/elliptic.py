import time
import threading
import bitcoin
import os

c = bitcoin.elliptic_curve_key()
c.new_key_pair()
print 'public_key', str(c.public_key()).encode('hex'), c.public_key().__class__
print 'secret', c.secret().encode('hex')
print 'private_key', str(c.private_key()).encode('hex'), c.private_key().__class__


