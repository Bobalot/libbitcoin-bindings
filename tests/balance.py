import bitcoin
import sys
import time
from decimal import Decimal as D

def blockchain_started(ec, chain, address):
    if ec:
        print >> sys.stderr, str(ec)
    print "Blockchain started"
    addr = bitcoin.payment_address(address)
    bitcoin.fetch_history(chain, addr,
        lambda ec, outs, ins: fetched(ec, outs, ins, chain))

def fetched(ec, outpoints, inpoints, chain):
    if ec:
        print >> sys.stderr, str(ec)
    unspent = []
    for outpoint, inpoint in zip(outpoints, inpoints):
        # If the hash is all zeroes, then this output is unspent.
        if inpoint.hash == "\0" * 32:
            unspent.append(outpoint)
    # If too many outputs then we would paginate this address on the website.
    # Clip number of unspent to 100 maximum.
    # Would give an inaccurate final balance, but you'll see the amounts
    # for the first 100 deposits.
    #if len(unspent) > 100:
    #    unspent = unspent[:100]
    bitcoin.fetch_output_values(chain, unspent, fetched_values)

def fetched_values(ec, values):
    if ec:
        print >> sys.stderr, str(ec)
    print D(sum(values)) / 10**8

def main(address):
    pool = bitcoin.threadpool(2)
    chain = bitcoin.leveldb_blockchain(pool)
    chain.start("database", lambda ec: blockchain_started(ec, chain, address))
    raw_input()
    pool.stop()
    pool.join()
    chain.stop()

if __name__ == "__main__":
    #main("1DC4sirYJ9SuYqPkMQFosJ63ue46knSw2o")
    if len(sys.argv) != 2:
        print "Usage: balance ADDRESS"
    else:
        main(sys.argv[1])

