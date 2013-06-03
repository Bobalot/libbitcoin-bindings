import bitcoin
from future import Future

class SyncBlockchain:

    def __init__(self, chain):
        self._chain = chain

    def fetch_block_header(self, index):
        future = Future()
        self._chain.fetch_block_header(index, future)
        return future.get()

    def fetch_block_transaction_hashes(self, index):
        future = Future()
        self._chain.fetch_block_transaction_hashes(index, future)
        return future.get()

    def fetch_block_depth(self, hash):
        future = Future()
        self._chain.fetch_block_depth(hash, future)
        return future.get()

    def fetch_last_depth(self):
        future = Future()
        self._chain.fetch_last_depth(future)
        return future.get()

    def fetch_transaction(self, hash):
        future = Future()
        self._chain.fetch_transaction(hash, future)
        return future.get()

def test_methods(chain):
    print chain.fetch_block_header(110)
    # Doesn't work.
    #print chain.fetch_block_header("00000000a30e366158a1813a6fda9f913497000a68f1c008b9f935b866cee55b".decode("hex"))
    # Doesn't work.
    #print chain.fetch_block_transaction_hashes(110)
    # Doesn't work.
    #print chain.fetch_block_depth("00000000a30e366158a1813a6fda9f913497000a68f1c008b9f935b866cee55b".decode("hex"))
    print chain.fetch_last_depth()
    # Doesn't work.
    #print chain.fetch_transaction("abde5e83fc1973fd042c56c8cb41b6c739f3e50678d1fa2f99f0a409e4aa80c7".decode("hex"))

def main():
    pool = bitcoin.threadpool(1)
    chain = bitcoin.leveldb_blockchain(pool)
    future = Future()
    chain.start("database", future)
    ec, = future.get()
    if ec:
        print >> sys.stderr, "Couldn't start blockchain:", str(ec)
        return False
    print "Blockchain started."
    sync_chain = SyncBlockchain(chain)
    test_methods(sync_chain)
    raw_input()
    pool.stop()
    pool.join()
    chain.stop()
    return True

if __name__ == "__main__":
    main()

