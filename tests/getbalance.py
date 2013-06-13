#!/usr/bin/python
import bitcoin
import sys

def blockchain_started(ec, chain, address):
    if ec:
        print >> sys.stderr, str(ec)
        return
    print "Blockchain started"
    payaddr = bitcoin.payment_address()
    if not payaddr.set_encoded(address):
        print >> sys.stderr, "Invalid Bitcoin address"
    chain.fetch_outputs(payaddr,
        lambda ec, outpoints: outputs_fetched(ec, outpoints, chain))

def outputs_fetched(ec, outpoints, chain):
    if ec:
        print >> sys.stderr, str(ec)
        return
    # Threadsafe only because we have a single thread of control.
    # This is a simple example. Don't use locks though,
    # use a better sync pattern.
    spends_queue = []
    spends_size = len(outpoints)
    for hash, index in outpoints:
        outp = bitcoin.output_point()
        outp.hash.copy(hash)
        outp.index = index
        chain.fetch_spend(outp,
            lambda ec, inpoint: \
                spend_fetched(ec, inpoint, outp, chain,
                              spends_queue, spends_size))

def spend_fetched(ec, inpoint, outpoint, chain, spends_queue, spends_size):
    if ec:
        #print >> sys.stderr, str(ec)
        spends_queue.append((outpoint, None))
    else:
        spends_queue.append((outpoint, inpoint))
    # Still more spends to fetch... continue the loop.
    if len(spends_queue) != spends_size:
        return
    # Now prune spent outputs because we're only interested in the balance.
    unspent = [outpoint for outpoint, inpoint in spends_queue if inpoint is None]
    current_count = [len(unspent)]
    total_balance = [0]
    for outpoint in unspent:
        # Hack to convert py_hash_digest to a Python string.
        hash = "".join(chr(c) for c in outpoint.hash[:])
        chain.fetch_transaction(hash,
            lambda ec, tx: tx_fetched(ec, tx, outpoint.index,
                                      total_balance, current_count))

def tx_fetched(ec, tx, index, total_balance, current_count):
    assert current_count >= 0
    if ec:
        print >> sys.stderr, str(ec)
        # ... Stop because there was an error. We will never show the balance.
        return
    current_count[0] -= 1
    # Update balance
    assert tx.outputs.size() > index
    total_balance[0] += tx.outputs[index].value
    # Keep looping
    if current_count[0] != 0:
        return
    print total_balance[0]

def main(address):
    pool = bitcoin.threadpool(1)
    chain = bitcoin.leveldb_blockchain(pool)
    chain.start("database",
        lambda ec: blockchain_started(ec, chain, address))
    raw_input()
    pool.stop()
    pool.join()
    chain.stop()

if __name__ == "__main__":
    if len(sys.argv) == 2:
        main(sys.argv[1])
    else:
        print "Usage: getbalance ADDRESS"

