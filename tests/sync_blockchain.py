import bitcoin

def test_methods(chain):
    print chain.fetch_block_header(110)
    print chain.fetch_block_header("00000000a30e366158a1813a6fda9f913497000a68f1c008b9f935b866cee55b".decode("hex"))
    print chain.fetch_block_transaction_hashes("00000000a30e366158a1813a6fda9f913497000a68f1c008b9f935b866cee55b".decode("hex"))
    print chain.fetch_block_transaction_hashes(110)
    print chain.fetch_block_depth("00000000a30e366158a1813a6fda9f913497000a68f1c008b9f935b866cee55b".decode("hex"))
    print chain.fetch_last_depth()
    print chain.fetch_transaction("abde5e83fc1973fd042c56c8cb41b6c739f3e50678d1fa2f99f0a409e4aa80c7".decode("hex"))
    print chain.fetch_transaction_index("abde5e83fc1973fd042c56c8cb41b6c739f3e50678d1fa2f99f0a409e4aa80c7".decode("hex"))
    addr = bitcoin.payment_address("1Afgoy1AoSMW5U7pgiMEDM98dpuLbTFNy1")
    ec, outs = chain.fetch_outputs(addr)
    print (ec, outs)
    print chain.fetch_spend(outs[0])
    ec, outs, ins = chain.fetch_history(addr)
    print (ec, outs, ins)
    ec, values = chain.fetch_output_values(outs)
    print (ec, values)
    print sum(values)

def main():
    pool = bitcoin.threadpool(1)
    chain = bitcoin.leveldb_blockchain(pool)
    future = bitcoin.Future()
    chain.start("database", future)
    ec, = future.get()
    if ec:
        print >> sys.stderr, "Couldn't start blockchain:", str(ec)
        return False
    print "Blockchain started."
    sync_chain = bitcoin.SyncBlockchain(chain)
    test_methods(sync_chain)
    raw_input()
    pool.stop()
    pool.join()
    chain.stop()
    return True

if __name__ == "__main__":
    main()

