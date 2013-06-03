import sys, time
from bitcoin import leveldb_blockchain, threadpool
from bitcoin import hash_block_header

def display_block_header(ec, blk):
    if ec:
        print "Failure fetching block header:", ec.message()
        sys.exit()
    blk_hash = hash_block_header(blk)
    print "hash:", blk_hash.encode('hex')
    print "version:", blk.version
    print "previous_block_hash:", blk.previous_block_hash.encode('hex')
    print "merkle:", blk.merkle.encode('hex')

def depth_fetched(ec, depth):
    if ec:
        print "Failed to fetch last depth:", ec.message()
        sys.exit()
    print 'depth: ' + str(depth)
    ldb_chain.fetch_block_header(depth, display_block_header)

def blockchain_started(ec):
    if ec:
        print "Blockchain failed to start:", ec.message()
        sys.exit()
    print "Blockchain started."
    ldb_chain.fetch_last_depth(depth_fetched)

pool = threadpool(1)
ldb_chain = leveldb_blockchain(pool)
ldb_chain.start("database", blockchain_started)
time.sleep(5)

pool.stop()
pool.join()
ldb_chain.stop()

