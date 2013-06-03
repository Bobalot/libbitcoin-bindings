import time
import threading
import bitcoin
import os

def blockchain_start(error):
    print "Blockchain starts", error

def fetch_finished(error, block_header):
    print "FETCH", block_header
    print "Header fetched", block_header, error
    print " version", block_header.version
    print ' block_hash', block_header.previous_block_hash.encode("hex")
    print ' merkle', block_header.merkle.encode("hex")
    print " timestamp", block_header.timestamp, time.ctime(block_header.timestamp)
    print " bits", block_header.bits
    print " nonce", block_header.nonce
    if len(block_header.transactions):
        print " transactions", block_header.transactions, dir(block_header.transactions), len(block_header.transactions)
        for t in block_header.transactions:
            print t
    print " done"

def import_finished(error):
    print "Import finished", error
    chain.fetch_block_header(0, fetch_finished)
    chain.fetch_block_header(1000, fetch_finished)
    print "Import finished2"

# start up engine
pool = bitcoin.threadpool(1)
print pool
chain = bitcoin.leveldb_blockchain(pool)
chain.start("database", blockchain_start);
print 'chain', chain

# load the first block
first_block = bitcoin.genesis_block()
print first_block

chain._import(first_block, 0, import_finished)

# get some block headers
print "fetch block header"
chain.fetch_block_header(0, fetch_finished)

print "waiting..."
#time.sleep(60)
time.sleep(3)

print "pool.stop"
pool.stop()

print "pool.join"
pool.join()

chain.stop()
print "exiting"
